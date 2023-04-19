import 'dart:async';
import 'package:driver_app/Data/services/driver_api_service.dart';
import 'package:driver_app/modules/utils_widget/widgets.dart';
import 'package:driver_app/modules/lifecycle_controller.dart';
import 'package:driver_app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OtpController extends GetxController {
  final lifeCycleController = Get.find<LifeCycleController>();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> passwordFormKey = GlobalKey<FormState>();

  TextEditingController otpController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  var error = ''.obs;

  Timer? timer;
  var start = 15.obs;

  var isLoading = false.obs;
  var isLoading2 = false.obs;
  var isClicked = true.obs;

  Future<void> confirmOTP() async {
    isLoading.value = true;
    final isValid = formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    formKey.currentState!.save();

    try {
      if (lifeCycleController.isActiveOTP) {
        await DriverAPIService.authApi
            .activeAccountByOTP(lifeCycleController.email, otpController.text);
      } else {
        await DriverAPIService.authApi.resetPassword(lifeCycleController.email,
            passwordController.text, otpController.text);
      }
      isLoading.value = false;
      showSnackBar(
          "Success",
          lifeCycleController.isActiveOTP
              ? "Active Account Successfully"
              : "Reset Password Sucessfully");

      lifeCycleController.isActiveOTP
          ? Get.offAllNamed(Routes.SET_UP_PROFILE)
          : Get.offAllNamed(Routes.WELCOME);
      return;
    } catch (e) {
      showSnackBar("Error", e.toString());
    }
  }

  Future<void> startTimer() async {
    isLoading2.value = true;
    try {
      await handleSendOTP();
      showSnackBar(
          "Success",
          lifeCycleController.isActiveOTP
              ? "Check your email to active account"
              : "check your email to get reset password code");
    } catch (e) {
      showSnackBar("Failed", e.toString());
    } finally {
      isLoading2.value = false;
    }
  }

  Future<void> handleSendOTP() async {
    isLoading2.value = true;
    if (lifeCycleController.isActiveOTP) {
      DriverAPIService.authApi
          .requestActiveAccountOTP(lifeCycleController.email);
    } else {
      DriverAPIService.authApi.requestResetPassword(lifeCycleController.email);
    }
    isLoading2.value = false;
  }

  String? validator() {
    if (otpController.text.isEmpty) {
      return "OTP can't be empty";
    } else if (otpController.text.length < 6) {
      return "Please fill all the numbers";
    }
    return null;
  }

  String? passwordValidator(String value) {
    if (value.isEmpty) {
      return "This field is required";
    } else if (value.length < 6) {
      return "Password length must be longer than 6 digits";
    }
    return null;
  }
}
