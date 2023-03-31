import 'dart:async';
import 'package:driver_app/Data/services/driver_api_service.dart';
import 'package:driver_app/core/utils/widgets.dart';
import 'package:driver_app/modules/lifecycle_controller.dart';
import 'package:driver_app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OtpController extends GetxController {
  final lifeCycleController = Get.find<LifeCycleController>();
  var isLoading = false.obs;
  var isLoading2 = false.obs;

  var isClicked = true.obs;

  TextEditingController otpController = TextEditingController();
  Timer? timer;
  var start = 15.obs;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  var error = ''.obs;

  @override
  void onInit() async {
    super.onInit();
    await startTimer();
  }

  String? validator() {
    if (otpController.text.isEmpty) {
      return "OTP can't be empty";
    } else if (otpController.text.length < 6) {
      return "Please fill all the numbers";
    }
    return null;
  }

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
        await DriverAPIService.authApi.resetPassword(
            lifeCycleController.email, "123123", otpController.text);
      }
    } catch (e) {
      showSnackBar("Error", e.toString());
    }
    isLoading.value = false;
    Get.offAndToNamed(Routes.SET_UP_PROFILE);
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
}
