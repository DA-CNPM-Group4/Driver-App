import 'dart:async';
import 'dart:collection';
import 'package:driver_app/Data/model/driver_entity.dart';
import 'package:driver_app/Data/models/realtime_models/realtime_driver.dart';
import 'package:driver_app/Data/models/realtime_models/realtime_location.dart';
import 'package:driver_app/Data/models/realtime_models/realtime_passenger.dart';
import 'package:driver_app/Data/models/realtime_models/trip_request.dart';
import 'package:driver_app/Data/providers/firestore_realtime_provider.dart';
import 'package:driver_app/Data/services/device_location_service.dart';
import 'package:driver_app/Data/services/driver_api_service.dart';
import 'package:driver_app/Data/services/firestore_realtime_service.dart';
import 'package:intl/intl.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive/hive.dart';
import 'package:driver_app/data/api_handler.dart';
import 'package:driver_app/data/user_response.dart';
import 'package:driver_app/modules/home/controllers/confirm_order.dart';
import 'package:driver_app/modules/income/income_controller.dart';

import '../../../data/Maps.dart';
import '../../../data/network_handler.dart';
import '../../../routes/app_pages.dart';
import '../../../routes/app_routes.dart';

class HomeController extends GetxController {
  StreamSubscription<Position>? gpsStreamSubscription;
  String address = "";

  var driverId = "driverId";
  var driverInfo = RealtimeDriverInfo(phone: '09080812032', name: 'Rabit');
  var vehicleInfo = RealtimeDriverVehicle(
      brand: 'Yamaha', name: 'Samsung Galaxy', vehicleId: '12325');
  var driverLocation = RealtimeLocation(lat: 0, long: 0, address: '');

  late RealtimeDriver driver = RealtimeDriver(
      info: driverInfo, vehicle: vehicleInfo, location: driverLocation);

  StreamSubscription? listenTripAgent;
  RealtimeTripRequest? tripRequest;

////////////////////////////////////////////////////////////

  var isActive = false.obs;
  var isLoading = false.obs;
  var isMapLoaded = false.obs;
  var isAccepted = false.obs;
  var position = {}.obs;
  var text = "bắt đầu".obs;
  APIHandlerImp apiHandlerImp = APIHandlerImp();
  String? id;
  var incomeController = Get.find<IncomeController>();

  Maps map = Maps();
  late GoogleMapController googleMapController;
  UserResponse? userResponse;
  OverlayEntry? overlayEntry;
  OverlayState? overlayState;
  StreamSubscription? listener;
  RxList<LatLng> polylinePoints = <LatLng>[].obs;
  List<PointLatLng> searchResult = [];
  final RxList<Polyline> polyline = <Polyline>[].obs;
  RxMap<MarkerId, Marker> markers = <MarkerId, Marker>{}.obs;

  void insertOverlay({
    required BuildContext context,
    required RealtimeTripRequest? trip,
    required String id,
    required RealtimePassenger? passenger,
  }) {
    overlayState = Overlay.of(context);
    isAccepted.value = true;
    overlayEntry = OverlayEntry(builder: (context) {
      return OrderInformation(
        passenger: passenger!,
        tripRequest: trip!,
        onStart: () {},
        onTrip: (RxBool isLoading) async {
          if (position["latitude"].toStringAsFixed(3) ==
                  trip.LatDesAddr.toStringAsFixed(3) &&
              position["longitude"].toStringAsFixed(3) ==
                  trip.LongDesAddr.toStringAsFixed(3)) {
            isLoading.value = true;
            try {
              DriverAPIService.completeTrip(id);
              overlayEntry!.remove();
            } catch (e) {}
            overlayEntry!.remove();
            reset();
            Get.snackbar("Success", "The trip was completed");
            await incomeController.getWallet();
            isLoading.value = false;
          }
        },
      );
    });

    overlayState!.insert(overlayEntry!);
  }

  Future<void> changeStatus(BuildContext context) async {
    isLoading.value = true;
    position.value = await map.getCurrentPosition();
    enableRealtimeLocator();
    try {
      var ref = FirebaseDatabase.instance.ref(FirebaseRealtimePaths.REQUESTS);
      listenTripAgent = ref.onChildAdded.listen((event) async {
        if (event.snapshot.exists) {
          final data = Map<String, dynamic>.from(event.snapshot.value as Map);
          var trip = RealtimeTripRequest.fromJson(data);

          var result = await Get.toNamed(Routes.REQUEST,
              arguments: {'requestId': event.snapshot.key, "trip": trip});
          if (result["accept"] == true) {
            id = result["tripId"];

            var passenger = await FirestoreRealtimeService.instance
                .readPassengerNode("fake-passenger-id");

            markers[const MarkerId("1")] = Marker(
                markerId: const MarkerId("1"),
                infoWindow: const InfoWindow(title: "Start address"),
                position: LatLng(trip.LatStartAddr, trip.LongStartAddr));

            markers[const MarkerId("2")] = Marker(
                markerId: const MarkerId("2"),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueBlue),
                infoWindow: const InfoWindow(title: "Destination"),
                position: LatLng(
                  trip.LatDesAddr,
                  trip.LongDesAddr,
                ));
            await route(
                Destination(
                    address: trip.StartAddress,
                    latitude: trip.LatDesAddr,
                    longitude: trip.LongDesAddr),
                Destination(
                    address: trip.StartAddress,
                    latitude: trip.LatDesAddr,
                    longitude: trip.LongDesAddr));
            listenTripAgent?.pause();

            insertOverlay(
              context: context,
              trip: tripRequest,
              passenger: passenger,
              id: id!,
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

  route(Destination? from, Destination? to) async {
    polylinePoints.clear();
    var start = "${from?.latitude},${from?.longitude}";
    var end = "${to?.latitude},${to?.longitude}";
    Map<String, String> query = {
      "key": "007f1251dd7ab0b676d064a314b46fa4",
      "origin": start,
      "destination": end,
      "mode": "motorcycle"
    };
    var response = await NetworkHandler.getWithQuery('route', query);
    searchResult = PolylinePoints()
        .decodePolyline(response["result"]["routes"][0]["overviewPolyline"]);
    for (var point in searchResult) {
      polylinePoints.add(LatLng(point.latitude, point.longitude));
    }
    polyline.refresh();
  }

  Future<void> completeTrip() async {}

  Future<void> cancelStatus() async {
    isLoading.value = true;

    listener!.cancel();
    // listener1!.cancel();
    isLoading.value = false;
  }

  void reset() {
    polylinePoints.clear();
    polyline.refresh();
    markers.clear();
    markers.refresh();
    listener!.resume();

    isAccepted.value = false;
  }

  @override
  void onInit() async {
    super.onInit();
    if (isActive.value) {
      await enableRealtimeLocator();
    }

    isLoading.value = true;
    isMapLoaded.value = true;
    await map.determinePosition();
    if (map.permission == LocationPermission.whileInUse ||
        map.permission == LocationPermission.always) {
      position.value = await map.getCurrentPosition();
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
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() async {
    disableRealtimeLocator();
    super.onClose();
  }

  void toggleActive() async {
    isActive.value = !isActive.value;
    if (isActive.value) {
      try {
        await enableRealtimeLocator();
      } catch (e) {
        // do nothing
      }
    } else {
      await disableRealtimeLocator();
    }
  }

///////////////////////////////////////////////////
  Future<void> enableRealtimeLocator() async {
    await setDriverInfo();
    var stream = await DeviceLocationService.instance.getLocationStream();
    gpsStreamSubscription = stream.listen((Position location) async {
      position['latitude'] = location.latitude;
      position['longitude'] = location.longitude;
      address =
          await DeviceLocationService.instance.getAddressFromLatLang(location);

      await FirestoreRealtimeService.instance.updateDriverLocationNode(
        driverId,
        RealtimeLocation(
          lat: location.latitude,
          long: location.latitude,
          address: address,
        ),
      );
    });
  }

  Future<void> disableRealtimeLocator() async {
    await gpsStreamSubscription?.cancel();
    await FirestoreRealtimeService.instance.deleteDriverNode(driverId);
  }

  Future<void> setDriverInfo() async {
    var location = await DeviceLocationService.instance.getCurrentPosition();
    position.value = {
      "latitude": location.latitude,
      "longitude": location.longitude,
    };
    address =
        await DeviceLocationService.instance.getAddressFromLatLang(location);
    driver.location = RealtimeLocation(
        lat: position['latitude'],
        long: position['longitude'],
        address: address);
    await FirestoreRealtimeService.instance.setDriverNode(driverId, driver);
  }
}
