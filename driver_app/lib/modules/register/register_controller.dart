import 'package:driver_app/core/constants/backend_enviroment.dart';
import 'package:driver_app/modules/lifecycle_controller.dart';
import 'package:driver_app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
  var lifeCycleController = Get.find<LifeCycleController>();

  final GlobalKey<FormState> phoneFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> emailFormKey = GlobalKey<FormState>();

  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  var isLoading = false.obs;
  var isUsingEmail = false.obs;
  var phoneError = ''.obs;
  var emailError = ''.obs;

  Future<void> validateAndSave() async {
    isLoading.value = true;
    final isPhoneValid = phoneFormKey.currentState!.validate();
    final isEmailValid = emailFormKey.currentState!.validate();
    if (!isPhoneValid || !isEmailValid) {
      isLoading.value = false;
    }

    // call api to check

    phoneFormKey.currentState!.save();
    emailFormKey.currentState!.save();
    isLoading.value = false;

    lifeCycleController.isloginByGoogle = false;
    lifeCycleController.preLoginedState.setField(
      phone: phoneNumberController.text,
      email: emailController.text,
    );
    if (BackendEnviroment.checkV2Comunication()) {
      Get.toNamed(Routes.SET_UP_PROFILE);
    } else {
      Get.toNamed(Routes.PASSWORD_REGISTER);
    }
  }
}
