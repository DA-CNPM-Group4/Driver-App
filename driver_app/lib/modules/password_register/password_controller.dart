import 'package:driver_app/Data/models/requests/register_driver_request.dart';
import 'package:driver_app/Data/services/driver_api_service.dart';
import 'package:driver_app/modules/utils_widget/widgets.dart';
import 'package:driver_app/modules/lifecycle_controller.dart';
import 'package:driver_app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PasswordController extends GetxController {
  final LifeCycleController lifeCycleController =
      Get.find<LifeCycleController>();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController passwordController = TextEditingController();
  var isLoading = false.obs;

  String? passwordValidator(String value) {
    if (value.isEmpty) {
      return "This field must be filled";
    } else if (value.length < 6) {
      return "The password length must be greater than 6 digits";
    }
    return null;
  }

  bool validateAndSave() {
    final FormState? form = formKey.currentState;
    if (form!.validate()) {
      return true;
    }
    return false;
  }

  Future<void> registerDriver() async {
    var body = RegisterDriverRequestBody(
        email: lifeCycleController.email,
        phone: lifeCycleController.phone,
        password: passwordController.text,
        name: lifeCycleController.email);

    try {
      isLoading.value = true;
      await DriverAPIService.authApi.register(body);
      Get.offAllNamed(Routes.WELCOME);
      showSnackBar("Register Sucess", "Please Sign In To Setup Your Profile");
    } catch (e) {
      showSnackBar("Error", e.toString());
    }
    isLoading.value = false;
  }
}
