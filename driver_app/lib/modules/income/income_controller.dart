import 'package:driver_app/Data/models/local_entity/driver_entity.dart';
import 'package:driver_app/Data/models/requests/trip_response.dart';
import 'package:driver_app/Data/services/rest/driver_api_service.dart';
import 'package:driver_app/modules/income/widgets/pick_date_bottom_sheet.dart';
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
  RxInt tripOrderNumber = 0.obs;

  late DriverEntity driverEntity;

  List<TripResponse> trips = [];

  @override
  void onInit() async {
    super.onInit();
    isLoading.value = true;
    driverEntity = await lifeCycleController.getDriver;
    isLoading.value = false;
  }

  Future<void> calculateRevenue({required TextTheme textTheme}) async {
    bool? isCaculate = await Get.bottomSheet(
        isDismissible: false,
        isScrollControlled: true,
        PickDateBottomSheet(
          controller: this,
        ));

    if (isCaculate != null && isCaculate != false) {
      isLoading.value = true;
      try {
        var result = await DriverAPIService.tripApi.getDriverCompletedTrips(
          from: from.value,
          to: to.value,
        );
        income.value = result.totalIncome;
        tripOrderNumber.value = result.total;
        trips = result.trips;
      } catch (e) {
        debugPrint(e.toString());
        showSnackBar("Error", e.toString());
      }
      isLoading.value = false;
    }
  }

  Future<void> chooseDate(Rx<DateTime> time, String title,
      {bool Function(DateTime)? predicate}) async {
    DateTime? pickedDate = await showDatePicker(
        context: Get.context!,
        initialDate: time.value,
        firstDate: DateTime(2000),
        lastDate: DateTime(2024),
        //initialEntryMode: DatePickerEntryMode.input,
        // initialDatePickerMode: DatePickerMode.year,
        helpText: title,
        cancelText: 'Close',
        confirmText: 'Confirm',
        errorFormatText: 'Enter valid date',
        errorInvalidText: 'Enter valid date range',
        fieldLabelText: 'DOB',
        fieldHintText: 'Month/Date/Year',
        selectableDayPredicate: predicate ?? disableDate);
    if (pickedDate == null) {
      return;
    }
    if (pickedDate != time.value) {
      time.value = pickedDate;
      return;
    }
  }

  bool disableDateFrom(DateTime day) {
    if ((day.isAfter(DateTime.now().subtract(const Duration(days: 600))) &&
        day.isBefore(to.value.add(const Duration(days: 1))))) {
      return true;
    }
    return false;
  }

  bool disableDateTo(DateTime day) {
    if ((day.isAfter(from.value.subtract(const Duration(days: 1))) &&
        day.isBefore(DateTime.now().add(const Duration(days: 0))))) {
      return true;
    }
    return false;
  }

  bool disableDate(DateTime day) {
    if ((day.isAfter(DateTime.now().subtract(const Duration(days: 365))) &&
        day.isBefore(DateTime.now().add(const Duration(days: 0))))) {
      return true;
    }
    return false;
  }
}
