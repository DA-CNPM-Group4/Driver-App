import 'package:driver_app/Data/models/local_entity/driver_entity.dart';
import 'package:driver_app/Data/models/requests/get_income_request.dart';
import 'package:driver_app/Data/services/rest/driver_api_service.dart';
import 'package:driver_app/core/utils/utils.dart';
import 'package:driver_app/modules/lifecycle_controller.dart';
import 'package:driver_app/modules/utils_widget/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IncomeController extends GetxController {
  var isLoading = false.obs;
  final lifeCycleController = Get.find<LifeCycleController>();

  DateTime from = DateTime.now();
  DateTime to = DateTime.now();
  RxInt income = 0.obs;
  late DriverEntity driverEntity;

  @override
  void onInit() async {
    super.onInit();
    isLoading.value = true;
    driverEntity = await lifeCycleController.getDriver;
    isLoading.value = false;
  }

  Future<void> getRevenue() async {
    from = DateTime.now();
    to = DateTime.now();

    isLoading.value = true;
    try {
      income.value = await DriverAPIService.tripApi.getInComeRequest(
        requestBody: GetIncomeRequestBody(
          from: Utils.dateTimeToDate(from),
          to: Utils.dateTimeToDate(to),
        ),
      );
    } catch (e) {
      debugPrint(e.toString());
      showSnackBar("Error", e.toString());
    }
    isLoading.value = false;
  }
}
