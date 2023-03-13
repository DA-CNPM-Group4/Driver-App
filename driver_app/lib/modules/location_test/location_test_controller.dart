import 'dart:async';

import 'package:driver_app/Data/services/device_location_service.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';

class LocationTestController extends GetxController {
  late final StreamSubscription<Position> gpsStreamSubscription;
  final RxBool isActive = false.obs;
  final RxDouble lat = 0.0.obs;
  final RxDouble long = 0.0.obs;

  @override
  void onInit() async {
    super.onInit();
    // gpsStreamSubscription =
    //     Geolocator.getPositionStream().listen((Position position) {
    //   lat.value = position.latitude;
    //   long.value = position.longitude;
    //   print(position);
    // });

    var stream = await DeviceLocationService.instance.getLocationStream();
    gpsStreamSubscription = stream.listen((Position position) {
      lat.value = position.latitude;
      long.value = position.longitude;
      print(position);
    });

    if (isActive.value) {
      gpsStreamSubscription.resume();
    } else {
      gpsStreamSubscription.pause();
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    gpsStreamSubscription.cancel();
  }

  Future<void> getCurrentLocation() async {
    var location = await DeviceLocationService.instance.getCurrentPosition();
    lat.value = location.latitude;
    long.value = location.longitude;
  }

  void toggleActive() async {
    isActive.value = !isActive.value;

    if (isActive.value) {
      try {
        gpsStreamSubscription.resume();
        print("resume");
      } catch (e) {
        print(e);
      }
    } else {
      gpsStreamSubscription.pause();
      print("Pause");
    }
  }
}
