import 'package:driver_app/Data/models/local_entity/driver_entity.dart';
import 'package:driver_app/Data/models/local_entity/vehicle_entity.dart';
import 'package:driver_app/Data/services/rest/driver_api_service.dart';
import 'package:driver_app/core/exceptions/bussiness_exception.dart';
import 'package:driver_app/modules/utils_widget/widgets.dart';
import 'package:driver_app/modules/lifecycle_controller.dart';
import 'package:driver_app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final LifeCycleController lifeCycleController =
      Get.find<LifeCycleController>();

  final GlobalKey<FormState> phoneFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> emailFormKey = GlobalKey<FormState>();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  RxString error = ''.obs;
  RxBool isLoading = false.obs;
  RxBool isUsingEmail = false.obs;

  Future<void> validateAndSave() async {
    isLoading.value = true;

    //.. if using phone and email
    if (!phoneFormKey.currentState!.validate() &&
        !emailFormKey.currentState!.validate()) {
      isLoading.value = false;
      return;
    }

    //.. if using phone or email
    // if (!isUsingEmail.value) {
    //   if (!phoneFormKey.currentState!.validate()) {
    //     isLoading.value = false;
    //     return;
    //   }
    // } else {
    //   if (!emailFormKey.currentState!.validate()) {
    //     isLoading.value = false;
    //     return;
    //   }
    // }
    // call api to check

    isUsingEmail.value
        ? emailFormKey.currentState!.save()
        : phoneFormKey.currentState!.save();
    isLoading.value = false;

    lifeCycleController.preLoginedState.setField(
      phone: phoneNumberController.text,
      email: emailController.text,
    );
    lifeCycleController.preLoginedState.isloginByGoogle = false;
    Get.toNamed(Routes.PASSWORD_LOGIN);
  }

  void changeLoginMethod() {
    isUsingEmail.value = !isUsingEmail.value;
  }

  Future<void> signInWithGoogle() async {
    isLoading.value = true;

    // handle google login
    try {
      final String googleEmail = await DriverAPIService.authApi.loginByGoogle();
      lifeCycleController.preLoginedState.isloginByGoogle = true;
      lifeCycleController.preLoginedState.googleEmail = googleEmail;
    } on CancelActionException catch (_) {
      isLoading.value = false;
      return;
    } catch (e) {
      showSnackBar("Sign in", e.toString());
      isLoading.value = false;
      return;
    }

    try {
      DriverEntity driverInfo = await DriverAPIService.getDriverInfo();
      lifeCycleController.setDriver = driverInfo;

      if (driverInfo.haveVehicleRegistered != true) {
        showSnackBar(
            "Register Vehicle", "You Need Setup Vehicle Before Driving");

        Get.toNamed(Routes.VEHICLE_REGISTRATION);
        return;
      }

      VehicleEntity vehicleEntity = await DriverAPIService.getVehicle();
      lifeCycleController.setVehicle = vehicleEntity;

      Get.offNamedUntil(
          Routes.DASHBOARD_PAGE, ModalRoute.withName(Routes.HOME));
    } on IBussinessException catch (_) {
      showSnackBar(
          "Setup Driver Info", "You Need Setup Driver Info Before Driving");

      Get.toNamed(Routes.SET_UP_PROFILE);
    } catch (e) {
      showSnackBar("Error", e.toString());

      await lifeCycleController.logout();
    }
    isLoading.value = false;
  }
}
