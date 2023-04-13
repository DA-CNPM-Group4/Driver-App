import 'package:driver_app/Data/models/local_entity/driver_entity.dart';
import 'package:driver_app/Data/models/requests/trip_response.dart';
import 'package:driver_app/Data/services/driver_api_service.dart';
import 'package:driver_app/modules/lifecycle_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TripInfoController extends GetxController {
  final LifeCycleController lifeCycleController =
      Get.find<LifeCycleController>();

  late DriverEntity driverEntity;

  RxBool isLoading = false.obs;
  RxBool isLoadMore = false.obs;
  ScrollController scrollController = ScrollController();
  final bookedList = <TripResponse>[].obs;

  @override
  void onInit() async {
    super.onInit();
    driverEntity = await lifeCycleController.getDriver;
    isLoading.value = true;
    bookedList.value = await DriverAPIService.tripApi.getDriverTrips();

    isLoading.value = false;
  }
}
