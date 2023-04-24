import 'package:driver_app/Data/models/local_entity/driver_entity.dart';
import 'package:driver_app/Data/models/requests/trip_response.dart';
import 'package:driver_app/Data/services/rest/driver_api_service.dart';
import 'package:driver_app/modules/lifecycle_controller.dart';
import 'package:driver_app/modules/utils_widget/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TripInfoController extends GetxController {
  final LifeCycleController lifeCycleController =
      Get.find<LifeCycleController>();

  late DriverEntity driverEntity;

  RxBool isLoading = false.obs;
  final bookedList = <TripResponse>[].obs;

  RxBool isLoadMore = false.obs;
  final int pageSize = 1;
  late final int maxPage;
  int currentPage = 1;

  @override
  void onInit() async {
    driverEntity = await lifeCycleController.getDriver;

    isLoading.value = true;

    await _getTotalPageSize();
    await _loadinitialTrip();

    isLoading.value = false;
    super.onInit();
  }

  Future<void> _loadinitialTrip() async {
    try {
      // bookedList.value = await DriverAPIService.tripApi.getDriverTrips();

      bookedList.value = await DriverAPIService.tripApi
          .getDriverTripsPaging(pageNum: currentPage, pageSize: pageSize);
      debugPrint("Load Init");
    } catch (e) {
      showSnackBar("Error", "Failed to fetch trips history");
    }
  }

  Future<void> _getTotalPageSize() async {
    try {
      maxPage = await DriverAPIService.tripApi
          .getDriverTripsTotalPage(pageSize: pageSize);
      debugPrint("Max Page: ${maxPage.toString()}");
    } catch (e) {
      maxPage = 1;
      debugPrint(e.toString());
    }
  }

  loadMoreTrip() async {
    if (currentPage >= maxPage) {
      return;
    }
    try {
      isLoadMore.value = true;
      currentPage++;
      final newTrips = await DriverAPIService.tripApi
          .getDriverTripsPaging(pageSize: pageSize, pageNum: currentPage);
      bookedList.addAll(newTrips);
      debugPrint("Load More");
    } catch (e) {
      currentPage--;
      debugPrint(e.toString());
      showSnackBar("Failed", "Failed to load more trip");
    } finally {
      isLoadMore.value = false;
    }
  }
}
