import 'dart:async';

import 'package:driver_app/modules/location_test/location_test_controller.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

String? pathToRequest;

const myPassengerId = 'passengerId1';
const myDriverId = 'driverId1';
Future<void> createRequest() async {
  FirebaseDatabase.instance.ref('requests/${pathToRequest!}');
}

class TestUpdateLocation extends GetView<LocationTestController> {
  const TestUpdateLocation({super.key});
  @override
  Widget build(BuildContext context) {
    Get.put(LocationTestController());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Live location tracking"),
      ),
      body: Center(
        child: Column(
          children: [
            Obx(
              () => Text(
                  'Latitude: ${controller.lat.toString()}; Longitude: ${controller.long.toString()}'),
            ),
            TextButton(
              onPressed: () async {
                await controller.setDriverInfo();
              },
              child: const Text("Get Location"),
            ),
            TextButton(
              onPressed: () {
                controller.toggleActive();
              },
              child: Obx(() => controller.isActive.value
                  ? const Text("Inactive")
                  : const Text("Active")),
            ),
            TextButton(
              onPressed: () async {
                await controller.setDriverInfo();
              },
              child: const Text("Init"),
            ),
          ],
        ),
      ),
    );
  }
}

void doshit() async {}
