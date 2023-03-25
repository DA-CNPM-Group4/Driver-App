import 'package:driver_app/modules/welcome/welcome_controller.dart';
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
    final isPhoneValid = phoneFormKey.currentState!.validate();
    final isEmailValid = emailFormKey.currentState!.validate();
    if (!isPhoneValid || !isEmailValid) {
      isLoading.value = false;
    }

    // call api to check

    phoneFormKey.currentState!.save();
    emailFormKey.currentState!.save();
    isLoading.value = false;

    lifeCycleController.setAuthFieldInfo(
        phoneNumberController.text, emailController.text);
    Get.toNamed(Routes.PASSWORD_REGISTER);
  }
}
