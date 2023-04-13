import 'dart:async';

import 'package:driver_app/Data/models/local_entity/driver_entity.dart';
import 'package:driver_app/Data/models/local_entity/vehicle_entity.dart';
import 'package:driver_app/Data/models/local_entity/wallet.dart';
import 'package:driver_app/modules/lifecycle_controller.dart';
import 'package:get/get.dart';
import '../../routes/app_routes.dart';

class UserController extends GetxController {
  LifeCycleController lifeCycleController = Get.find<LifeCycleController>();

  late Rxn<DriverEntity>? driverEntity;
  late Rxn<VehicleEntity>? vehicleEntity;

  var isLoading = false.obs;
  Wallet? wallet;
  var isClicked = false.obs;
  var start = 30.obs;
  Timer? timer;
  var error = ''.obs;
  var buttonLoading = false.obs;

  @override
  void onInit() async {
    super.onInit();
    isLoading.value = true;

    driverEntity = await lifeCycleController.getRXDriver;
    vehicleEntity = await lifeCycleController.getRXVehicle;
    isLoading.value = false;
  }

  void goToProfileView() {
    Get.toNamed(Routes.EDIT_PROFILE);
  }

  void goToTripHistoryView() {
    Get.toNamed(Routes.TRIP_INFO);
  }

  void goToChangePasswordView() {
    Get.toNamed(Routes.PASSWORD_CHANGE);
  }
}
