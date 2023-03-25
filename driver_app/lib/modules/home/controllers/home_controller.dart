import 'dart:async';
import 'package:driver_app/Data/models/local_entity/position_point.dart';
import 'package:driver_app/Data/models/realtime_models/realtime_driver.dart';
import 'package:driver_app/Data/models/realtime_models/realtime_location.dart';
import 'package:driver_app/Data/models/realtime_models/realtime_passenger.dart';
import 'package:driver_app/Data/models/realtime_models/trip_request.dart';
import 'package:driver_app/Data/providers/firestore_realtime_provider.dart';
import 'package:driver_app/Data/services/device_location_service.dart';
import 'package:driver_app/Data/services/driver_api_service.dart';
import 'package:driver_app/Data/services/firestore_realtime_service.dart';
import 'package:driver_app/modules/lifecycle_controller.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:driver_app/modules/home/controllers/confirm_order.dart';
import 'package:driver_app/modules/income/income_controller.dart';

import '../../../data/Maps.dart';
import '../../../data/network_handler.dart';
import '../../../routes/app_routes.dart';

class HomeController extends GetxController {
  final LifeCycleController lifeCycleController =
      Get.find<LifeCycleController>();
  var incomeController = Get.find<IncomeController>();

  StreamSubscription<Position>? gpsStreamSubscription;
  StreamSubscription? listenTripAgent;
  StreamSubscription? passengerLisenterAgent;

  var fakePassengerId = '5686df08-cdc0-45a0-a45a-08db257d53cf';

  var isActive = false.obs;
  var isLoading = false.obs;
  var isMapLoaded = false.obs;
  var isAccepted = false.obs;

  var currentDriverPosition = {}.obs;
  var currentDestinationPostion = {}.obs;

  String? tripId;
  Maps map = Maps();

  late GoogleMapController googleMapController;
  RxList<LatLng> polylinePoints = <LatLng>[].obs;
  List<PointLatLng> searchResult = [];
  final RxList<Polyline> polyline = <Polyline>[].obs;
  RxMap<MarkerId, Marker> markers = <MarkerId, Marker>{}.obs;

  OverlayEntry? overlayEntry;
  OverlayState? overlayState;

  Future<void> changeActiveMode(BuildContext context) async {
    await enableRealtimeLocator();

    isLoading.value = true;
    currentDriverPosition.value = await map.getCurrentPosition();
    try {
      var firebaseRequestRef =
          FirebaseDatabase.instance.ref(FirebaseRealtimePaths.REQUESTS);

      listenTripAgent = firebaseRequestRef.onChildAdded.listen((event) async {
        if (event.snapshot.exists) {
          final data = Map<String, dynamic>.from(event.snapshot.value as Map);
          var request = RealtimeTripRequest.fromJson(data);

          var result = await Get.toNamed(Routes.REQUEST,
              arguments: {'requestId': event.snapshot.key, "trip": request});

          if (result["accept"] == true) {
            isAccepted.value = true;

            var tripId = result["tripId"];

            assignPassengerListener(request);
            listenTripAgent?.pause();

            var passengerInfo = await FirestoreRealtimeService.instance
                .readPassengerNode(request.PassengerId ?? 'fake-passenger-id');

            await drawRoute(
                from: PositionPoint(
                    address: "",
                    latitude: currentDriverPosition['latitude'],
                    longitude: currentDriverPosition['longitude']),
                to: PositionPoint(
                    address: "",
                    latitude: currentDestinationPostion['latitude'],
                    longitude: currentDestinationPostion['longitude']));

            insertOverlay(
              context: context,
              trip: request,
              passenger: passengerInfo,
              tripId: tripId!,
            );
          }
        }
      });
    } catch (e) {
      Get.log(e.toString());
      isLoading.value = false;
    }
    isLoading.value = false;
  }

  void insertOverlay({
    required BuildContext context,
    required RealtimeTripRequest? trip,
    required String tripId,
    required RealtimePassenger? passenger,
  }) {
    overlayState = Overlay.of(context);
    overlayEntry = OverlayEntry(builder: (context) {
      return OrderInformation(
        passenger: passenger!,
        tripRequest: trip!,
        onStart: () async {
          await DriverAPIService.tripApi.pickPassenger(tripId);
          await passengerLisenterAgent?.cancel();

          currentDestinationPostion['address'] = trip.Destination;
          currentDestinationPostion['latitude'] = trip.LatDesAddr;
          currentDestinationPostion['longitude'] = trip.LongDesAddr;
          drawMarker(trip);

          await drawRoute(
              from: PositionPoint(
                  address: currentDriverPosition['address'],
                  latitude: currentDriverPosition['latitude'],
                  longitude: currentDriverPosition['longitude']),
              to: PositionPoint(
                  address: trip.Destination,
                  latitude: trip.LatDesAddr,
                  longitude: trip.LongDesAddr));
        },
        onCancle: () async {
          try {
            isLoading.value = true;
            await passengerLisenterAgent?.cancel();
            await DriverAPIService.tripApi.cancelTrip(tripId);
          } catch (e) {
            print(e.toString());
          }
          isLoading.value = false;
          overlayEntry!.remove();
          reset();
          Get.snackbar("Success", "The trip was canceled");
        },
        onTrip: (RxBool isLoading) async {
          if (checkCompleteTripCondition()) {
            isLoading.value = true;
            overlayEntry!.remove();
            reset();
            Get.snackbar("Success", "The trip was completed");
            // await incomeController.getWallet();
            isLoading.value = false;
          } else {
            try {
              isLoading.value = true;
              await DriverAPIService.tripApi.completeTrip(tripId);
            } catch (e) {
              print(e.toString());
            }
            isLoading.value = false;
            overlayEntry!.remove();
            reset();
            Get.snackbar("Success", "The trip was completed");
          }
        },
      );
    });

    overlayState!.insert(overlayEntry!);
  }

  void assignPassengerListener(RealtimeTripRequest request) {
    var firebasePassengerRef =
        FirestoreRealtimeService.instance.getDatabaseReference(
      nodeId: request.PassengerId ?? fakePassengerId,
      rootPath: FirebaseRealtimePaths.PASSENGERS,
    );

    passengerLisenterAgent = firebasePassengerRef.onValue.listen((event) {
      final data = Map<String, dynamic>.from(event.snapshot.value as Map);
      var passengerNode = RealtimePassenger.fromMap(data);

      final location = passengerNode.location;

      currentDestinationPostion['latitude'] = location.lat;
      currentDestinationPostion['longitude'] = location.long;
      currentDestinationPostion['address'] = location.address;

      markers[const MarkerId("1")] = Marker(
          markerId: const MarkerId("1"),
          infoWindow: const InfoWindow(title: "Passenger Location"),
          position: LatLng(location.lat, location.long));
    });
  }

  void drawMarker(RealtimeTripRequest tripRequest) {
    markers[const MarkerId("1")] = Marker(
        markerId: const MarkerId("1"),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        infoWindow: const InfoWindow(title: "Destination"),
        position: LatLng(
          tripRequest.LatDesAddr,
          tripRequest.LongDesAddr,
        ));
  }

  drawRoute({PositionPoint? from, PositionPoint? to}) async {
    polylinePoints.clear();
    var start = "${from?.latitude},${from?.longitude}";
    var end = "${to?.latitude},${to?.longitude}";
    Map<String, String> query = {
      "key": "007f1251dd7ab0b676d064a314b46fa4",
      "origin": start,
      "destination": end,
      "mode": "motorcycle"
    };
    try {
      var response = await NetworkHandler.getWithQuery('route', query);
      searchResult = PolylinePoints()
          .decodePolyline(response["result"]["routes"][0]["overviewPolyline"]);
      for (var point in searchResult) {
        polylinePoints.add(LatLng(point.latitude, point.longitude));
      }
      polyline.refresh();
    } catch (e) {
      Future.error(e.toString());
    }
  }

  void reset() {
    polylinePoints.clear();
    polyline.refresh();
    markers.clear();
    markers.refresh();

    listenTripAgent?.resume();

    isAccepted.value = false;
  }

  @override
  void onInit() async {
    super.onInit();
    isLoading.value = true;

    if (isActive.value) {
      await enableRealtimeLocator();
    }

    isMapLoaded.value = true;

    await map.determinePosition();
    if (map.permission == LocationPermission.whileInUse ||
        map.permission == LocationPermission.always) {
      currentDriverPosition.value = await map.getCurrentPosition();
    }
    isMapLoaded.value = false;

    polyline.add(Polyline(
      polylineId: const PolylineId('line1'),
      visible: true,
      points: polylinePoints,
      width: 5,
      color: Colors.blue,
    ));

    isLoading.value = false;
  }

  @override
  void onClose() async {
    // disableRealtimeLocator();
    super.onClose();
  }

  Future<void> toggleActive(BuildContext context) async {
    isLoading.value = true;

    isActive.value = !isActive.value;
    if (isActive.value) {
      try {
        await changeActiveMode(context);
      } catch (e) {}
    } else {
      listenTripAgent?.pause();
      await disableRealtimeLocator();
    }
    isLoading.value = false;
  }

  Future<void> enableRealtimeLocator() async {
    await setDriverInfo();

    var stream = await DeviceLocationService.instance.getLocationStream();

    gpsStreamSubscription = stream.listen((Position location) async {
      var address =
          await DeviceLocationService.instance.getAddressFromLatLang(location);

      currentDriverPosition['latitude'] = location.latitude;
      currentDriverPosition['longitude'] = location.longitude;
      currentDriverPosition['address'] = address;

      await FirestoreRealtimeService.instance.updateDriverLocationNode(
        lifeCycleController.driver.accountId,
        RealtimeLocation(
          lat: location.latitude,
          long: location.longitude,
          address: address,
        ),
      );

      if (isAccepted.value) {
        drawRoute(
          from: PositionPoint(
              address: address,
              latitude: location.latitude,
              longitude: location.longitude),
          to: PositionPoint(
              address: currentDestinationPostion['address'],
              latitude: currentDestinationPostion['latitude'],
              longitude: currentDestinationPostion['longitude']),
        );
      }
    });
  }

  Future<void> disableRealtimeLocator() async {
    await gpsStreamSubscription?.cancel();
    await FirestoreRealtimeService.instance
        .deleteDriverNode(lifeCycleController.driver.accountId);
  }

  Future<void> setDriverInfo() async {
    var location = await DeviceLocationService.instance.getCurrentPosition();
    currentDriverPosition.value = {
      "latitude": location.latitude,
      "longitude": location.longitude,
      'address':
          await DeviceLocationService.instance.getAddressFromLatLang(location)
    };

    var realtimeLocation = RealtimeLocation(
        lat: currentDriverPosition['latitude'],
        long: currentDriverPosition['longitude'],
        address: currentDriverPosition['address']);

    final driver = lifeCycleController.driver;
    final vehicle = lifeCycleController.vehicle;

    lifeCycleController.realtimeDriver = RealtimeDriver(
      info: RealtimeDriverInfo(
        name: driver.name,
        phone: driver.phone,
      ),
      vehicle: RealtimeDriverVehicle(
          brand: vehicle.brand ?? "Unknown",
          name: vehicle.vehicleName ?? "Unknown",
          vehicleId: vehicle.vehicleId ?? "Unknown"),
      location: realtimeLocation,
    );

    await FirestoreRealtimeService.instance.setDriverNode(
        lifeCycleController.driver.accountId,
        lifeCycleController.realtimeDriver);
  }

  bool checkCompleteTripCondition() {
    return false;
  }
}
