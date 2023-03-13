import 'dart:async';

import 'package:driver_app/Data/services/device_location_service.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';

class LocationTestController extends GetxController {
  late StreamSubscription<Position> gpsStreamSubscription;
  final RxBool isActive = false.obs;
  final RxDouble lat = 0.0.obs;
  final RxDouble long = 0.0.obs;

  @override
  void onInit() async {
    super.onInit();
    await enableRealtimeLocator();
    if (isActive.value) {
    } else {
      gpsStreamSubscription.cancel();
    }
  }

  Future<void> enableRealtimeLocator() async {
    var stream = await DeviceLocationService.instance.getLocationStream();
    // gpsStreamSubscription = Geolocator.getPositionStream(
    //   locationSettings: DeviceLocationService.instance.currentSetting,
    // ).listen((Position position) {
    //   lat.value = position.latitude;
    //   long.value = position.longitude;
    //   print(position);
    // });

    gpsStreamSubscription = stream.listen((Position position) {
      lat.value = position.latitude;
      long.value = position.longitude;
      print(position);
    });
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() async {
    gpsStreamSubscription.cancel();
    super.onClose();
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
        await enableRealtimeLocator();
        print("resume");
      } catch (e) {
        print(e);
      }
    } else {
      await gpsStreamSubscription.cancel();
      print("Pause");
    }
  }
}
