import 'package:driver_app/Data/models/requests/login_driver_request.dart';
import 'package:driver_app/Data/services/driver_api_service.dart';
import 'package:driver_app/core/utils/widgets.dart';
import 'package:driver_app/modules/login/login_controller.dart';
import 'package:driver_app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PasswordLoginController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController passwordController = TextEditingController();
  var loginController = Get.find<LoginController>();

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

  Future<void> login() async {
    isLoading.value = false;
    try {
      var body = await LoginDriverRequestBody(
        email: loginController.emailController.text,
        phone: loginController.phoneNumberController.text,
        password: passwordController.text,
      );
      await DriverAPIService.login(body: body);
      Get.offNamedUntil(
          Routes.DASHBOARD_PAGE, ModalRoute.withName(Routes.HOME));
    } catch (e) {
      showSnackBar("Error", e.toString());
    }
  }
}
