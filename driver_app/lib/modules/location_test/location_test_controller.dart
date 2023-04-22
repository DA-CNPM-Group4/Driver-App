import 'dart:async';

import 'package:driver_app/Data/models/realtime_models/realtime_driver.dart';
import 'package:driver_app/Data/models/realtime_models/realtime_location.dart';
import 'package:driver_app/Data/services/device_location_service.dart';
import 'package:driver_app/Data/services/firebase/firebase_realtime_service.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';

class LocationTestController extends GetxController {
  StreamSubscription<Position>? gpsStreamSubscription;
  final RxBool isActive = false.obs;
  final RxDouble lat = 0.0.obs;
  final RxDouble long = 0.0.obs;
  final RxString address = "".obs;

  var driverId = "driverId";
  var driverInfo = RealtimeDriverInfo(phone: '09080812032', name: 'Rabit');
  var vehicleInfo = RealtimeDriverVehicle(
      brand: 'Yamaha', name: 'Samsung Galaxy', vehicleId: '12325');
  var driverLocation = RealtimeLocation(lat: 0, long: 0, address: '');

  late RealtimeDriver driver = RealtimeDriver(
      info: driverInfo, vehicle: vehicleInfo, location: driverLocation);

  @override
  void onInit() async {
    super.onInit();
    if (isActive.value) {
      await enableRealtimeLocator();
    } else {
      // gpsStreamSubscription.cancel();
    }
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

  Future<void> enableRealtimeLocator() async {
    await setDriverInfo();
    var stream = await DeviceLocationService.instance.getLocationStream();
    gpsStreamSubscription = stream.listen((Position position) async {
      lat.value = position.latitude;
      long.value = position.longitude;
      address.value = await DeviceLocationService.instance
          .getAddressFromLatLang(
              latitude: position.latitude, longitude: position.longitude);

      await FireBaseRealtimeService.instance.updateDriverLocationNode(
        driverId,
        RealtimeLocation(
          lat: position.latitude,
          long: position.latitude,
          address: address.value,
        ),
      );
    });
  }

  Future<void> disableRealtimeLocator() async {
    await gpsStreamSubscription?.cancel();
    await FireBaseRealtimeService.instance.deleteDriverNode(driverId);
  }

  Future<void> setDriverInfo() async {
    var location = await DeviceLocationService.instance.getCurrentPosition();

    lat.value = location.latitude;
    long.value = location.longitude;
    address.value = await DeviceLocationService.instance.getAddressFromLatLang(
        latitude: location.latitude, longitude: location.longitude);
    driver.location = RealtimeLocation(
        lat: lat.value, long: long.value, address: address.value);
    await FireBaseRealtimeService.instance.setDriverNode(driverId, driver);
  }
}
