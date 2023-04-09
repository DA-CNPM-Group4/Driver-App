import 'dart:async';
import 'package:driver_app/Data/models/local_entity/driver_entity.dart';
import 'package:driver_app/Data/models/local_entity/position_point.dart';
import 'package:driver_app/Data/models/local_entity/vehicle_entity.dart';
import 'package:driver_app/Data/models/realtime_models/realtime_driver.dart';
import 'package:driver_app/Data/models/realtime_models/realtime_location.dart';
import 'package:driver_app/Data/models/realtime_models/realtime_passenger.dart';
import 'package:driver_app/Data/models/realtime_models/trip_request.dart';
import 'package:driver_app/Data/providers/firesbase_realtime_provider.dart';
import 'package:driver_app/Data/services/device_location_service.dart';
import 'package:driver_app/Data/services/driver_api_service.dart';
import 'package:driver_app/Data/services/firebase_realtime_service.dart';
import 'package:driver_app/core/constants/backend_enviroment.dart';
import 'package:driver_app/core/constants/common_object.dart';
import 'package:driver_app/modules/utils_widget/widgets.dart';
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

  late DriverEntity driver;
  late VehicleEntity vehicle;

  var incomeController = Get.find<IncomeController>();

  StreamSubscription<Position>? gpsStreamSubscription;
  StreamSubscription? listenRequestAgent;
  StreamSubscription? listenTripAgent;
  StreamSubscription? listenPassengerLocationAgent;

  var isDriverActive = false.obs;
  var isAcceptedTrip = false.obs;

  var isLoading = false.obs;
  var isMapLoaded = false.obs;

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

      listenRequestAgent =
          firebaseRequestRef.onChildAdded.listen((event) async {
        if (event.snapshot.exists) {
          final data = Map<String, dynamic>.from(event.snapshot.value as Map);
          var request = RealtimeTripRequest.fromJson(data);

          if (await handleRequestTimeout(request, event.snapshot.key ?? "")) {
            return;
          }

          var result = await Get.toNamed(Routes.REQUEST, arguments: {
            'requestId': event.snapshot.key,
            "trip": request,
          });

          if (result['accept'] == false) {
            showSnackBar("Failed", "You Late! Or Passenger just cancel request",
                second: 5);
          }

          if (result['accept'] == true) {
            listenRequestAgent?.pause();

            isAcceptedTrip.value = true;
            String tripId = result["tripId"];

            RealtimePassengerInfo passengerInfo =
                await handlePassenger(request);

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
              tripId: tripId,
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

  Future<bool> handleRequestTimeout(
      RealtimeTripRequest request, String requestId) async {
    DateTime requestDate = DateTime.parse(request.CreatedTime);
    var waitingTime = DateTime.now().difference(requestDate).inSeconds;
    if (waitingTime > 30 + 40) {
      try {
        await DriverAPIService.tripApi.cancelRequest(requestId: requestId);
      } catch (e) {
        //
      }
      return true;
    } else {
      return false;
    }
  }

  Future<RealtimePassengerInfo> handlePassenger(
      RealtimeTripRequest request) async {
    if (request.isCreatedByPassenger()) {
      assignPassengerLocationListener(request);
    }
    var passengerNode = await FireBaseRealtimeService.instance
        .readPassengerNode(request.PassengerId!);

    return passengerNode == null
        ? RealtimePassengerInfo(
            phone: request.PassengerPhone, name: "Outside Passenger")
        : passengerNode.info;
  }

  void insertOverlay({
    required BuildContext context,
    required RealtimeTripRequest? trip,
    required String tripId,
    required RealtimePassengerInfo passenger,
  }) {
    assignTripRemovedListner(tripId);
    overlayState = Overlay.of(context);
    overlayEntry = OverlayEntry(builder: (context) {
      return OrderInformation(
        passenger: passenger,
        tripRequest: trip!,
        onStart: () async {
          await changeToPickPassengerState(tripId, trip);
        },
        onCancel: () async {
          await handleCancleTrip(tripId);
        },
        onTrip: () async {
          if (checkCompleteTripCondition()) {
            isLoading.value = true;
            try {
              await DriverAPIService.tripApi.completeTrip(tripId);
              showSnackBar("Success", "The trip was completed");
            } catch (e) {
              showSnackBar("Completed Trip Failed", e.toString());
            }
            isLoading.value = false;
            overlayEntry!.remove();
            reset();
          } else {
            showSnackBar("Completed Trip Failed",
                "you have to carry passengers to nearly 10m");
          }
        },
      );
    });

    overlayState!.insert(overlayEntry!);
  }

  Future<void> handleCancleTrip(String tripId) async {
    try {
      isLoading.value = true;
      await listenPassengerLocationAgent?.cancel();
      await DriverAPIService.tripApi.cancelTrip(tripId);
    } catch (e) {
      showSnackBar("Trip Canceled", "The trip was canceled");
    }
    isLoading.value = false;
    overlayEntry!.remove();
    reset();
  }

  void assignTripRemovedListner(String tripId) {
    var firebaseRequestRef = FirebaseDatabase.instance
        .ref(FirebaseRealtimePaths.TRIPS)
        .child(tripId);

    listenTripAgent = firebaseRequestRef.onChildRemoved.listen((event) async {
      overlayEntry!.remove();
      await listenPassengerLocationAgent?.cancel();
      reset();
      showSnackBar("Oops", "The trip was canceld");
    });
  }

  Future<void> changeToPickPassengerState(
      String tripId, RealtimeTripRequest trip) async {
    await DriverAPIService.tripApi.pickPassenger(tripId);
    await listenPassengerLocationAgent?.cancel();

    currentDestinationPostion['address'] = trip.Destination;
    currentDestinationPostion['latitude'] = trip.LatDesAddr;
    currentDestinationPostion['longitude'] = trip.LongDesAddr;
    drawDestination(trip);

    await drawRoute(
        from: PositionPoint(
            address: currentDriverPosition['address'],
            latitude: currentDriverPosition['latitude'],
            longitude: currentDriverPosition['longitude']),
        to: PositionPoint(
            address: trip.Destination,
            latitude: trip.LatDesAddr,
            longitude: trip.LongDesAddr));
  }

  void assignPassengerLocationListener(RealtimeTripRequest request) {
    if (request.isCreatedByPassenger()) {
      var firebasePassengerRef =
          FireBaseRealtimeService.instance.getDatabaseReference(
        nodeId: request.PassengerId ?? CommonObject.test_passenger_id,
        rootPath: FirebaseRealtimePaths.PASSENGERS,
      );

      listenPassengerLocationAgent =
          firebasePassengerRef.onValue.listen((event) {
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
    } else {
      currentDestinationPostion['latitude'] = request.LatStartAddr;
      currentDestinationPostion['longitude'] = request.LongStartAddr;
      currentDestinationPostion['address'] = request.StartAddress;

      markers[const MarkerId("1")] = Marker(
          markerId: const MarkerId("1"),
          infoWindow: const InfoWindow(title: "Passenger Location"),
          position: LatLng(request.LatStartAddr, request.LongStartAddr));
    }
  }

  void drawDestination(RealtimeTripRequest tripRequest) {
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

    listenRequestAgent?.resume();

    isAcceptedTrip.value = false;
  }

  @override
  void onInit() async {
    super.onInit();
    isLoading.value = true;

    driver = await lifeCycleController.getDriver;
    vehicle = await lifeCycleController.getVehicle;

    if (isDriverActive.value) {
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
    await disableRealtimeLocator();
    super.onClose();
  }

  Future<void> toggleActive(BuildContext context) async {
    isLoading.value = true;

    isDriverActive.value = !isDriverActive.value;
    if (isDriverActive.value) {
      try {
        await changeActiveMode(context);
      } catch (e) {}
    } else {
      listenRequestAgent?.pause();
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

      await FireBaseRealtimeService.instance.updateDriverLocationNode(
        driver.accountId,
        RealtimeLocation(
          lat: location.latitude,
          long: location.longitude,
          address: address,
        ),
      );

      if (isAcceptedTrip.value && !BackendEnviroment.isPoor) {
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
    await FireBaseRealtimeService.instance.deleteDriverNode(driver.accountId);
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

    lifeCycleController.realtimeDriver = RealtimeDriver(
      info: RealtimeDriverInfo(
        name: driver.name,
        phone: driver.phone,
      ),
      vehicle: RealtimeDriverVehicle(
          brand: vehicle.brand,
          name: vehicle.vehicleName,
          vehicleId: vehicle.vehicleId),
      location: realtimeLocation,
    );

    await FireBaseRealtimeService.instance
        .setDriverNode(driver.accountId, lifeCycleController.realtimeDriver);
  }

  bool checkCompleteTripCondition() {
    return true;
  }
}
