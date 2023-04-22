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

  final from = DateTime.now().obs;
  final to = DateTime.now().obs;

  RxInt income = 0.obs;
  late DriverEntity driverEntity;

  @override
  void onInit() async {
    super.onInit();
    isLoading.value = true;
    driverEntity = await lifeCycleController.getDriver;
    isLoading.value = false;
  }

  bool disableDate(DateTime day) {
    if ((day.isAfter(DateTime.now().subtract(const Duration(days: 365))) &&
        day.isBefore(DateTime.now().add(const Duration(days: 0))))) {
      return true;
    }
    return false;
  }

  Future<void> getRevenue() async {
    await chooseDate(from);
    to.value = DateTime.now();

    isLoading.value = true;
    try {
      var result = await DriverAPIService.tripApi.getDriverCompletedTrips(
        from: from.value,
        to: to.value,
      );
      income.value = result.totalIncome;
      // income.value = await DriverAPIService.tripApi.getInComeRequest(
      //   requestBody: GetIncomeRequestBody(
      //     from: Utils.dateTimeToDate(from.value),
      //     to: Utils.dateTimeToDate(to.value),
      //   ),
      // );
    } catch (e) {
      debugPrint(e.toString());
      showSnackBar("Error", e.toString());
    }
    isLoading.value = false;
  }

  chooseDate(Rx<DateTime> time) async {
    DateTime? pickedDate = await showDatePicker(
        context: Get.context!,
        initialDate: time.value,
        firstDate: DateTime(2000),
        lastDate: DateTime(2024),
        //initialEntryMode: DatePickerEntryMode.input,
        // initialDatePickerMode: DatePickerMode.year,
        helpText: 'Select DOB',
        cancelText: 'Close',
        confirmText: 'Confirm',
        errorFormatText: 'Enter valid date',
        errorInvalidText: 'Enter valid date range',
        fieldLabelText: 'DOB',
        fieldHintText: 'Month/Date/Year',
        selectableDayPredicate: disableDate);
    if (pickedDate != null && pickedDate != time.value) {
      time.value = pickedDate;
      debugPrint(Utils.dateTimeToDate(time.value));
    }
  }
}
