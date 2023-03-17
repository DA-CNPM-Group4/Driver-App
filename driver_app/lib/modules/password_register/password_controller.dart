import 'package:driver_app/Data/models/requests/create_driver_request.dart';
import 'package:driver_app/Data/models/requests/register_driver_request.dart';
import 'package:driver_app/Data/services/driver_api_service.dart';
import 'package:driver_app/core/utils/widgets.dart';
import 'package:driver_app/modules/register/register_controller.dart';
import 'package:driver_app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PasswordController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController passwordController = TextEditingController();
  var registerController = Get.find<RegisterController>();
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
        email: registerController.emailController.text,
        phone: registerController.phoneNumberController.text,
        password: passwordController.text,
        name: registerController.emailController.text);

    try {
      isLoading.value = true;
      await DriverAPIService.register(body);
      Get.toNamed(Routes.SET_UP_PROFILE);
    } catch (e) {
      showSnackBar("Oh no", e.toString());
    }
    isLoading.value = false;
  }
}
