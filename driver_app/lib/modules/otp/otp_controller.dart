import 'dart:async';
import 'package:driver_app/Data/services/driver_api_service.dart';
import 'package:driver_app/modules/utils/widgets.dart';
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

  Future<bool> validateOTP() async {
    return true;
  }

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
    } catch (e) {
      showSnackBar("Error", e.toString());
    }
    isLoading.value = false;
    Get.offAllNamed(Routes.WELCOME);
    return;
  }

  Future<void> startTimer() async {
    await handleSendOTP();
    // isClicked.value = true;
    // const oneSec = Duration(seconds: 1);

    // timer = Timer.periodic(
    //   oneSec,
    //   (Timer timer) {
    //     if (start.value == 0) {
    //       start.value = 30;
    //       isClicked.value = false;
    //       timer.cancel();
    //     } else {
    //       start.value -= 1;
    //     }
    //   },
    // );
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
