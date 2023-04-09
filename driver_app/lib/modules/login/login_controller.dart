import 'package:driver_app/Data/models/local_entity/driver_entity.dart';
import 'package:driver_app/Data/models/local_entity/vehicle_entity.dart';
import 'package:driver_app/Data/services/driver_api_service.dart';
import 'package:driver_app/core/exceptions/bussiness_exception.dart';
import 'package:driver_app/modules/utils/widgets.dart';
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

  String? phoneNumberValidator(String value) {
    if (value.isEmpty) {
      return "This field must be filled";
    } else if (!value.isPhoneNumber) {
      return "You must enter a right phone number";
    }
    return null;
  }

  String? emailValidator(String value) {
    if (value.isEmpty) {
      return "This field must be filled";
    } else if (!value.isEmail) {
      return "You must enter a email address";
    }
    return null;
  }

  Future<void> validateAndSave() async {
    isLoading.value = true;
    lifeCycleController.isloginByGoogle = false;

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

    lifeCycleController.setAuthFieldInfo(
        phoneNumberController.text, emailController.text);
    Get.toNamed(Routes.PASSWORD_LOGIN);
  }

  void changeLoginMethod() {
    isUsingEmail.value = !isUsingEmail.value;
  }

  Future<void> signInWithGoogle() async {
    isLoading.value = true;
    lifeCycleController.isloginByGoogle = true;

    try {
      await DriverAPIService.authApi.loginByGoogle();
    } catch (e) {
      showSnackBar("Sign in", e.toString());
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
    } on IBussinessException catch (e) {
      showSnackBar(
          "Setup Driver Info", "You Need Setup Driver Info Before Driving");
      Get.toNamed(Routes.SET_UP_PROFILE);
    } catch (e) {
      showSnackBar("Error", e.toString());
      // await lifeCycleController.logout();
    }
    isLoading.value = false;
  }
}
