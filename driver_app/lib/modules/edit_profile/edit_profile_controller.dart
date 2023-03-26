import 'package:driver_app/Data/models/local_entity/driver_entity.dart';
import 'package:driver_app/Data/models/requests/update_driver_request.dart';
import 'package:driver_app/Data/services/driver_api_service.dart';
import 'package:driver_app/core/utils/widgets.dart';
import 'package:driver_app/modules/lifecycle_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

class EditProfileController extends GetxController {
  final LifeCycleController lifeCycleController =
      Get.find<LifeCycleController>();
  DriverEntity? driver;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  var isLoading = false.obs;

  RxBool gender = true.obs;
  TextEditingController nameController = TextEditingController();
  TextEditingController identityController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  @override
  void onInit() async {
    driver = await lifeCycleController.getDriver;
    nameController.setText(driver!.name);
    identityController.setText(driver!.identityNumber);
    addressController.setText(driver!.address);
    gender.value = driver!.gender;
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

  Future<void> validateAndSave() async {
    isLoading.value = true;
    final isValid = formKey.currentState!.validate();
    if (!isValid) {
      isLoading.value = false;
    }

    var body = UpdateDriverRequestBody(
      Address: addressController.text,
      Gender: gender.value,
      IdentityNumber: identityController.text,
      Name: nameController.text,
    );

    try {
      await DriverAPIService.updateDriver(body: body);
      showSnackBar("Success", "Edit Profile Success");
      lifeCycleController.setDriver = await DriverAPIService.getDriverInfo();
    } catch (e) {
      showSnackBar("Error", e.toString());
    }

    isLoading.value = false;
  }

  String? nameValidator(String value) {
    if (value.isEmpty) {
      return "This field must be filled";
    }
    return RegExp(r'^[a-z A-Z,.\-]+$',
                caseSensitive: false, unicode: true, dotAll: true)
            .hasMatch(value)
        ? null
        : "Name can't contains special characters or number";
  }

  String? phoneNumberValidator(String value) {
    if (value.isEmpty) {
      return "This field must be filled";
    }
    return value.isPhoneNumber ? null : "You must enter a right phone number";
  }

  String? idValidator(String value) {
    if (value.isEmpty) {
      return "This field must be filled";
    }
    return value.length >= 12 ? null : "ID length can't be lower than 12";
  }

  String? addressValidator(String value) {
    if (value.isEmpty) {
      return "This field must be filled";
    }
    return null;
  }
}
