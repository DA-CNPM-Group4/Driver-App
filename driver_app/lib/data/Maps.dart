import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class Maps {
  late Position position;
  late bool serviceEnabled;
  late LocationPermission permission;

  Future<Position> determinePosition() async {
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Future<Map<String, dynamic>> getCurrentPosition() async {
    bool canAccessLocation = await requestPermission();
    if (canAccessLocation) {
      position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      return {"latitude": position.latitude, "longitude": position.longitude};
    } else {
      throw Future.error('Access Device Location Denied');
    }
  }

  Future<Placemark> getCurrentAddress(
      dynamic latitude, dynamic longitude) async {
    List<Placemark> newPlace =
        await placemarkFromCoordinates(latitude, longitude);
    return newPlace[0];
  }

  Future<Stream<Position>> getLocationStream() async {
    if (await requestPermission()) {
      return Geolocator.getPositionStream(
          locationSettings: _getDeviceSetting());
    } else {
      throw Stream.error("Access Device Location Denied");
    }
  }

  Future<String> getAddressFromLatLang(Position position) async {
    List<Placemark> placemark =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placemark[0];
    return '${place.street}, ${place.subAdministrativeArea}, ${place.administrativeArea}, ${place.country}';
  }

  Future<bool> requestPermission() async {
    LocationPermission permission;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }

      // Only in IOS
      if (permission == LocationPermission.deniedForever) {
        // Permissions are denied forever, handle appropriately.
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }
    }
    return true;
  }

  LocationSettings _getDeviceSetting() {
    // if (defaultTargetPlatform == TargetPlatform.android) {
    //   return AndroidSettings(
    //       accuracy: LocationAccuracy.bestForNavigation,
    //       distanceFilter: 5,
    //       forceLocationManager: true,
    //       intervalDuration: const Duration(seconds: 5),
    //       //(Optional) Set foreground notification config to keep the app alive
    //       //when going to the background
    //       foregroundNotificationConfig: const ForegroundNotificationConfig(
    //         notificationText:
    //             "Example app will continue to receive your location even when you aren't using it",
    //         notificationTitle: "Running in Background",
    //         enableWakeLock: true,
    //       ));
    // } else if (defaultTargetPlatform == TargetPlatform.iOS ||
    //     defaultTargetPlatform == TargetPlatform.macOS) {
    //   return AppleSettings(
    //     accuracy: LocationAccuracy.bestForNavigation,
    //     activityType: ActivityType.fitness,
    //     distanceFilter: 5,
    //     pauseLocationUpdatesAutomatically: true,
    //     // Only set to true if our app will be started up in the background.
    //     showBackgroundLocationIndicator: false,
    //   );
    // } else {
    return const LocationSettings(
      accuracy: LocationAccuracy.bestForNavigation,
      distanceFilter: 5,
    );
  }
}
