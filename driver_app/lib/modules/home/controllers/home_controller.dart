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
import 'package:driver_app/Data/services/rest/driver_api_service.dart';
import 'package:driver_app/Data/services/firebase/firebase_realtime_service.dart';
import 'package:driver_app/core/constants/backend_enviroment.dart';
import 'package:driver_app/core/constants/common_object.dart';
import 'package:driver_app/modules/dashboard_page/dashboard_page_controller.dart';
import 'package:driver_app/modules/utils_widget/widgets.dart';
import 'package:driver_app/modules/lifecycle_controller.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:driver_app/modules/home/controllers/confirm_order.dart';

import '../../../data/network_handler.dart';
import '../../../routes/app_routes.dart';

class HomeController extends GetxController {
  final LifeCycleController lifeCycleController =
      Get.find<LifeCycleController>();

  final GlobalKey parentKey = GlobalKey();

  late DriverEntity driver;
  late VehicleEntity vehicle;

  StreamSubscription<Position>? gpsStreamSubscription;
  StreamSubscription? listenRequestAgent;
  StreamSubscription? listenTripAgent;
  StreamSubscription? listenPassengerLocationAgent;

  var isDriverActive = false.obs;
  var isAcceptedTrip = false.obs;
  var isPickupPassenger = false.obs;

  var isLoading = false.obs;
  var isMapLoaded = false.obs;

  var currentDriverPosition = {}.obs;
  var currentDestinationPostion = {}.obs;

  String? tripId;

  late GoogleMapController googleMapController;
  RxList<LatLng> polylinePoints = <LatLng>[].obs;
  List<PointLatLng> searchResult = [];
  final RxList<Polyline> polyline = <Polyline>[].obs;
  RxMap<MarkerId, Marker> markers = <MarkerId, Marker>{}.obs;

  OverlayEntry? overlayEntry;
  OverlayState? overlayState;

  Future<void> changeActiveMode(BuildContext context) async {
    isLoading.value = true;
    try {
      currentDriverPosition.value =
          await DeviceLocationService.instance.getCurrentPositionAsMap();
      await enableRealtimeLocator();

      var firebaseRequestRef =
          FirebaseDatabase.instance.ref(FirebaseRealtimePaths.REQUESTS);

      listenRequestAgent =
          firebaseRequestRef.onChildAdded.listen((event) async {
        if (event.snapshot.exists) {
          final data = Map<String, dynamic>.from(event.snapshot.value as Map);
          var request = RealtimeTripRequest.fromJson(data);

          if (await handleAcceptRequest(request, event.snapshot.key ?? "")) {
            return;
          }

          await Get.toNamed(Routes.REQUEST, arguments: {
            'requestId': event.snapshot.key,
            "trip": request,
          })?.then((value) async {
            final bool isSucess = value['success'];

            if (!isSucess) {
              final bool isNotify = value['notify'];
              if (isNotify) {
                final String message = value['message'];
                showSnackBar("Request", message, second: 5);
              }
              return;
            }

            if (isSucess) {
              listenRequestAgent?.pause();

              isAcceptedTrip.value = true;
              String tripId = value["tripId"];

              await Get.find<DashboardPageController>()
                  .initChat(request.PassengerId ?? "fake-passenger-id", tripId);

              RealtimePassengerInfo passengerInfo =
                  await handleReadPassenger(request);

              await drawRoute(
                  from: PositionPoint(
                      address: "",
                      latitude: currentDriverPosition['latitude'],
                      longitude: currentDriverPosition['longitude']),
                  to: PositionPoint(
                      address: "",
                      latitude: currentDestinationPostion['latitude'],
                      longitude: currentDestinationPostion['longitude']));

              routingHomeTab();
              insertOverlay(
                context: context,
                trip: request,
                passenger: passengerInfo,
                tripId: tripId,
              );
            }
          });
        }
      });
    } catch (e) {
      showSnackBar("Error", e.toString());
    }
    isLoading.value = false;
  }

  void routingHomeTab() {
    if (Get.routing.current == Routes.DASHBOARD_PAGE) {
      Get.until((route) => route.settings.name == Routes.DASHBOARD_PAGE);
    }
    Get.find<DashboardPageController>().tabIndex(0);
  }

  void insertOverlay({
    required BuildContext context,
    required RealtimeTripRequest? trip,
    required String tripId,
    required RealtimePassengerInfo passenger,
  }) {
    assignTripRemovedListener(tripId);
    overlayState = Overlay.of(context);
    overlayEntry = OverlayEntry(builder: (context) {
      return Builder(builder: (context) {
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
            await handleOntrip(tripId);
          },
        );
      });
    });
    overlayState?.insert(overlayEntry!);
  }

  Future<void> handleOntrip(String tripId) async {
    if (checkCompleteTripCondition()) {
      await listenTripAgent?.cancel();
      try {
        EasyLoading.show();
        isLoading.value = true;

        await DriverAPIService.tripApi.completeTrip(tripId);
        showSnackBar("Success", "The trip was completed");
      } catch (e) {
        debugPrint(e.toString());
        showSnackBar("Completed Trip Failed", "The trip was completed");
      } finally {
        EasyLoading.dismiss();
        isLoading.value = false;
        await Get.find<DashboardPageController>().resetState();
      }
    } else {
      showSnackBar("Completed Trip Failed",
          "you have to carry passengers to nearly 10m");
    }
  }

  Future<bool> handleAcceptRequest(
      RealtimeTripRequest request, String requestId) async {
    DateTime requestDate = DateTime.parse(request.CreatedTime);

    var waitingTime = DateTime.now().difference(requestDate).inSeconds - 60;
    if (waitingTime > 60 * 5) {
      try {
        await DriverAPIService.tripApi.cancelRequest(requestId: requestId);
      } catch (e) {
        showSnackBar("Error", e.toString());
      }
      return true;
    } else {
      return false;
    }
  }

  Future<RealtimePassengerInfo> handleReadPassenger(
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

  Future<void> handleCancleTrip(String tripId) async {
    try {
      EasyLoading.show();
      await listenPassengerLocationAgent?.cancel();
      await listenTripAgent?.cancel();

      await DriverAPIService.tripApi.cancelTrip(tripId);
      showSnackBar("Trip Canceled", "The trip was canceled");
    } catch (e) {
      showSnackBar("Trip Canceled Failed", "The trip was canceled");
    } finally {
      EasyLoading.dismiss();
      await Get.find<DashboardPageController>().resetState();
    }
  }

  void assignTripRemovedListener(String tripId) {
    var firebaseRequestRef = FirebaseDatabase.instance
        .ref(FirebaseRealtimePaths.TRIPS)
        .child(tripId);

    listenTripAgent = firebaseRequestRef.onChildRemoved.listen((event) async {
      await listenPassengerLocationAgent?.cancel();
      await Get.find<DashboardPageController>().resetState();
      showSnackBar("Oops", "The trip was canceld");
      listenTripAgent?.cancel();
    });
  }

  Future<void> changeToPickPassengerState(
      String tripId, RealtimeTripRequest trip) async {
    try {
      EasyLoading.show();
      await DriverAPIService.tripApi.pickPassenger(tripId);
    } catch (e) {
      showSnackBar("Failed",
          "Failed to pickup passenger but process must be continuing");
      debugPrint(e.toString());
    } finally {
      EasyLoading.dismiss();
    }
    await listenPassengerLocationAgent?.cancel();
    isPickupPassenger.value = true;

    currentDestinationPostion['address'] = trip.Destination;
    currentDestinationPostion['latitude'] = trip.LatDesAddr;
    currentDestinationPostion['longitude'] = trip.LongDesAddr;
    _drawDestinationMarker(trip);

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

        drawMarker(
          markerId: "1",
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          title: "Passenger Location",
          latLng: LatLng(location.lat, location.long),
        );

        // markers[const MarkerId("1")] = Marker(
        //     markerId: const MarkerId("1"),
        //     infoWindow: const InfoWindow(title: "Passenger Location"),
        //     position: LatLng(location.lat, location.long));
      });
    } else {
      currentDestinationPostion['latitude'] = request.LatStartAddr;
      currentDestinationPostion['longitude'] = request.LongStartAddr;
      currentDestinationPostion['address'] = request.StartAddress;

      drawMarker(
        markerId: "1",
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        title: "Passenger Location",
        latLng: LatLng(request.LatStartAddr, request.LongStartAddr),
      );
      // markers[const MarkerId("1")] = Marker(
      //   markerId: const MarkerId("1"),
      //   infoWindow: const InfoWindow(title: "Passenger Location"),
      //   position: LatLng(request.LatStartAddr, request.LongStartAddr),
      // );
    }
  }

  void _drawDestinationMarker(RealtimeTripRequest tripRequest) {
    drawMarker(
        markerId: "1",
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        title: "Destination",
        latLng: LatLng(
          tripRequest.LatDesAddr,
          tripRequest.LongDesAddr,
        ));
    // markers[const MarkerId("1")] = Marker(
    //     markerId: const MarkerId("1"),
    //     icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
    //     infoWindow: const InfoWindow(title: "Destination"),
    //     position: LatLng(
    //       tripRequest.LatDesAddr,
    //       tripRequest.LongDesAddr,
    //     ));
  }

  void drawMarker({
    required String markerId,
    required BitmapDescriptor icon,
    required String title,
    required LatLng latLng,
  }) {
    MarkerId id = MarkerId(markerId);
    markers[id] = Marker(
      markerId: id,
      icon: icon,
      infoWindow: InfoWindow(title: title),
      position: latLng,
    );
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

  Future<void> resetState() async {
    polylinePoints.clear();
    polyline.refresh();
    markers.clear();
    markers.refresh();

    removeOverlay();
    listenRequestAgent?.resume();
    isAcceptedTrip.value = false;
    isPickupPassenger.value = false;
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

    currentDriverPosition.value =
        await DeviceLocationService.instance.getCurrentPositionAsMap();

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
    debugPrint("Home Onclose Start");

    gpsStreamSubscription?.cancel();
    listenRequestAgent?.cancel();
    listenTripAgent?.cancel();
    listenPassengerLocationAgent?.cancel();
    super.onClose();
  }

  Future<void> toggleActive(BuildContext context) async {
    isLoading.value = true;

    isDriverActive.value = !isDriverActive.value;
    if (isDriverActive.value) {
      try {
        await changeActiveMode(context);
      } catch (_) {
        showSnackBar("Error", "Enable To Active");
      }
    } else {
      listenRequestAgent?.pause();
      await disableRealtimeLocator();
    }
    isLoading.value = false;
  }

  Future<void> disableRealtimeLocator() async {
    await gpsStreamSubscription?.cancel();
    await FireBaseRealtimeService.instance.deleteDriverNode(driver.accountId);
  }

  Future<void> enableRealtimeLocator() async {
    await setDriverInfo();

    var stream = await DeviceLocationService.instance.getLocationStream();

    gpsStreamSubscription = stream.listen((Position location) async {
      var address = await DeviceLocationService.instance.getAddressFromLatLang(
          latitude: location.latitude, longitude: location.longitude);

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

  Future<void> setDriverInfo() async {
    RealtimeLocation realtimeLocation = await getDriverRealtimeLocation();

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

  Future<RealtimeLocation> getDriverRealtimeLocation() async {
    var location = await DeviceLocationService.instance.getCurrentPosition();
    currentDriverPosition.value = {
      "latitude": location.latitude,
      "longitude": location.longitude,
      'address': await DeviceLocationService.instance.getAddressFromLatLang(
          latitude: location.latitude, longitude: location.longitude)
    };

    var realtimeLocation = RealtimeLocation(
        lat: currentDriverPosition['latitude'],
        long: currentDriverPosition['longitude'],
        address: currentDriverPosition['address']);
    return realtimeLocation;
  }

  bool checkCompleteTripCondition() {
    return true;
  }

  void removeOverlay() {
    if (overlayEntry != null) {
      overlayEntry?.remove();
      overlayEntry?.dispose();
    }
  }
}
