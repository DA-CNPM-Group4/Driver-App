import 'package:driver_app/Data/models/local_entity/driver_entity.dart';
import 'package:driver_app/Data/models/requests/trip_feedback_response.dart';
import 'package:driver_app/Data/models/requests/trip_response.dart';
import 'package:driver_app/Data/services/driver_api_service.dart';
import 'package:driver_app/modules/lifecycle_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class TripDetailController extends GetxController {
  final LifeCycleController lifeCycleController =
      Get.find<LifeCycleController>();

  late Rxn<DriverEntity>? driver;

  late TripResponse trip;
  late TripFeedbackResponse feedback;
  var isLoading = false.obs;

  RxBool isRate = false.obs;

  int star = 2;
  TextEditingController feedbackController = TextEditingController();
  @override
  void onInit() async {
    super.onInit();
    isLoading.value = true;
    EasyLoading.show();
    trip = Get.arguments as TripResponse;
    driver = await lifeCycleController.getRXDriver;

    try {
      feedback = await DriverAPIService.tripApi.getTripFeedback(trip.tripId);
      isRate.value = true;
    } catch (e) {
      isRate.value = false;
    }
    isLoading.value = false;
    EasyLoading.dismiss();
  }
}
