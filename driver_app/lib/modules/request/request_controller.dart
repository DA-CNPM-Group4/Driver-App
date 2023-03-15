import 'dart:async';

import 'package:driver_app/Data/models/realtime_models/trip_request.dart';
import 'package:driver_app/Data/models/requests/accept_trip_request.dart';
import 'package:driver_app/Data/services/driver_api_service.dart';
import 'package:get/get.dart';
import 'package:driver_app/data/api_handler.dart';

class RequestController extends GetxController {
  final count = 10.obs;
  var isLoading = false.obs;
  APIHandlerImp apiHandlerImp = APIHandlerImp();
  late String requestId = "";
  late RealtimeTripRequest trip;

  Future<void> handleAccept() async {
    try {
      var params = AcceptTripRequestParams(
          requestId: requestId, driverId: Get.arguments['testDriverId']);
      var tripId = await DriverAPIService.acceptTripRequest(params);
      Get.back(result: {
        "accept": true,
        "tripId": tripId,
      });
    } catch (e) {
      Get.snackbar("Failed", "Failed");
      Get.back();
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

  @override
  void onClose() {
    super.onClose();
  }
}
