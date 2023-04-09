import 'dart:async';

import 'package:driver_app/Data/models/realtime_models/trip_request.dart';
import 'package:driver_app/Data/models/requests/accept_trip_request.dart';
import 'package:driver_app/Data/services/driver_api_service.dart';
import 'package:driver_app/modules/lifecycle_controller.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class RequestController extends GetxController {
  final LifeCycleController lifeCycleController =
      Get.find<LifeCycleController>();

  final count = 30.obs;
  late Timer _timer;
  var isLoading = false.obs;
  var isPressing = false;
  late String requestId = "";
  late RealtimeTripRequest trip;

  Future<void> handleAccept() async {
    try {
      isPressing = true;
      EasyLoading.show(status: 'Waiting...');

      final driverEnitty = await lifeCycleController.getDriver;
      var requestBody = AcceptTripRequestBody(
          requestId: requestId, driverId: driverEnitty.accountId);

      var tripId =
          await DriverAPIService.tripApi.acceptTripRequest(requestBody);

      Get.back(result: {
        "accept": true,
        "tripId": tripId,
      });
    } catch (e) {
      Get.back(result: {"accept": false});
    }
    EasyLoading.dismiss();
  }

  @override
  void onInit() async {
    super.onInit();
    isLoading.value = true;
    requestId = Get.arguments['requestId'] as String;
    trip = Get.arguments["trip"];
    isLoading.value = false;
    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) {
        if (isPressing) {
          timer.cancel();
        }
        if (count.value <= 0) {
          timer.cancel();
          Get.back(result: {"accept": false});
        } else {
          count.value--;
        }
      },
    );
  }

  @override
  void onClose() {
    _timer.cancel();
    super.onClose();
  }
}
