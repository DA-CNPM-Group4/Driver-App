import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

FirebaseDatabase database = FirebaseDatabase.instance;
DatabaseReference onlDriversRef = FirebaseDatabase.instance.ref('onlDrivers');
DatabaseReference requestsRef = FirebaseDatabase.instance.ref('requests');

String? pathToRequest;

const myPassengerId = 'passengerId1';
const myDriverId = 'driverId1';

class TestUpdateLocation extends StatefulWidget {
  const TestUpdateLocation({super.key});

  @override
  State<TestUpdateLocation> createState() => _TestUpdateLocationState();
}

class _TestUpdateLocationState extends State<TestUpdateLocation> {
  DatabaseReference? yourRequest;
  Future<void> createRequest() async {
    yourRequest = FirebaseDatabase.instance.ref('requests/${pathToRequest!}');
  }

  Future<void> listenRequest() async {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Live location tracking"),
      ),
      body: Center(
        child: Column(
          children: [
            TextButton(
              onPressed: () async {
                var mylocation = await determinePosition();

                print(mylocation);
              },
              child: const Text("Active"),
            ),
            TextButton(
              onPressed: () {},
              child: const Text("Inactive"),
            ),
          ],
        ),
      ),
    );
  }
}

/// Determine the current position of the device.
///
/// When the location services are not enabled or permissions
/// are denied the `Future` will return an error.
Future<Position> determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();

  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.

    // return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition();
}
