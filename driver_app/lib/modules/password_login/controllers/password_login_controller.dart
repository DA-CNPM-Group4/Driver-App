import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:driver_app/data/api_handler.dart';
import 'package:driver_app/data/model/driver_entity.dart';
import 'package:driver_app/modules/login/login_controller.dart';

import '../../../routes/app_pages.dart';
import '../../../routes/app_routes.dart';

class PasswordLoginController extends GetxController {
  //TODO: Implement PasswordLoginController
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController passwordController = TextEditingController();
  var loginController = Get.find<LoginController>();
  var isLoading = false.obs;
  APIHandlerImp apiHandler = APIHandlerImp();

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
    isLoading.value = true;
    print(passwordController.text);

    var response = await apiHandler.post({
      "username": '0${loginController.phoneNumberController.text}',
      "password": passwordController.text
    }, "driver/login");

    if (response.data["status"]) {
      var box = await Hive.openBox("box");
      await box.put("notFirstTime", false);

      Get.offNamedUntil(Routes.DASHBOARD_PAGE, ModalRoute.withName(Routes.HOME));
      apiHandler.storeToken(response.data["data"]);
      var response1 = await apiHandler.get("driver/getInforByToken", {
      });

      DriverEntity driverEntity = DriverEntity.fromJson(response1.data["data"]);
      Get.log(driverEntity.fullname!);
      await box.put("driver", driverEntity);

    } else {
      Get.snackbar("Lỗi", "Mật khẩu không đúng");
    }
    isLoading.value = false;
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
