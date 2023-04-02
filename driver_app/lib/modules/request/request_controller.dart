import 'dart:async';

import 'package:driver_app/Data/models/local_entity/driver_entity.dart';
import 'package:driver_app/Data/models/realtime_models/trip_request.dart';
import 'package:driver_app/Data/models/requests/accept_trip_request.dart';
import 'package:driver_app/Data/services/driver_api_service.dart';
import 'package:driver_app/modules/lifecycle_controller.dart';
import 'package:get/get.dart';

class RequestController extends GetxController {
  final LifeCycleController lifeCycleController =
      Get.find<LifeCycleController>();

  final count = 20.obs;
  var isLoading = false.obs;
  late String requestId = "";
  late RealtimeTripRequest trip;

  Future<void> handleAccept() async {
    try {
      final driverEnitty = await lifeCycleController.getDriver;
      var params = AcceptTripRequestBody(
          requestId: requestId, driverId: driverEnitty.accountId);

      var tripId = await DriverAPIService.tripApi.acceptTripRequest(params);

      Get.back(result: {
        "accept": true,
        "tripId": tripId,
      });
    } catch (e) {
      Get.snackbar("Failed", "You Late! Or Passenger just cancel request");
      Get.back(result: {"accept": false});
    }
  }

  @override
  void onInit() {
    super.onInit();
    isLoading.value = true;
    requestId = Get.arguments['requestId'] as String;
    trip = Get.arguments["trip"];
    isLoading.value = false;
  }

  @override
  void onReady() async {
    super.onReady();

    while (true) {
      if (count.value == 0) {
        Get.back();
      }
      await Future.delayed(const Duration(seconds: 1)).then((_) {
        count.value -= 1;
      });
    }
  }
}
