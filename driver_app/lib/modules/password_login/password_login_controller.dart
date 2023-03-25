import 'package:driver_app/Data/models/local_entity/driver_entity.dart';
import 'package:driver_app/Data/models/requests/login_driver_request.dart';
import 'package:driver_app/Data/services/driver_api_service.dart';
import 'package:driver_app/core/exceptions/bussiness_exception.dart';
import 'package:driver_app/core/utils/widgets.dart';
import 'package:driver_app/modules/welcome/welcome_controller.dart';
import 'package:driver_app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PasswordLoginController extends GetxController {
  var lifeCycleController = Get.find<LifeCycleController>();

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

  Future<void> login() async {
    isLoading.value = false;
    try {
      var body = await LoginDriverRequestBody(
        email: lifeCycleController.email,
        phone: lifeCycleController.phone,
        password: passwordController.text,
      );
      await DriverAPIService.authApi.login(body: body);

      DriverEntity driverInfo = await DriverAPIService.getDriverInfo();
      if (driverInfo.haveVehicleRegistered != true) {
        Get.toNamed(Routes.VEHICLE_REGISTRATION);
      }

      Get.offNamedUntil(
          Routes.DASHBOARD_PAGE, ModalRoute.withName(Routes.HOME));
    } on IBussinessException catch (e) {
      print("Set driver Info");
      Get.toNamed(Routes.SET_UP_PROFILE);
    } catch (e) {
      showSnackBar("Error", e.toString());
    }
  }
}
