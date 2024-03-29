import 'package:driver_app/Data/services/rest/driver_api_service.dart';
import 'package:driver_app/modules/utils_widget/widgets.dart';
import 'package:driver_app/modules/lifecycle_controller.dart';
import 'package:driver_app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordController extends GetxController {
  final LifeCycleController lifeCycleController =
      Get.find<LifeCycleController>();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  var isLoading = false.obs;
  var emailError = ''.obs;

  TextEditingController emailController = TextEditingController();

  Future<void> sendResetPasswordOTP() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid || isLoading.value) {
      return;
    }
    isLoading.value = true;

    try {
      lifeCycleController.preLoginedState.email = emailController.text;
      await DriverAPIService.authApi
          .requestResetPassword(lifeCycleController.preLoginedState.email);
      showSnackBar("Success", "Check your email to get reset password code");
      toOTPPage();
    } catch (e) {
      showSnackBar("Error", e.toString());
    }

    isLoading.value = false;
  }

  void toOTPPage() {
    lifeCycleController.isActiveOTP = false;
    lifeCycleController.preLoginedState.email = emailController.text;
    Get.toNamed(Routes.OTP);
  }
}
