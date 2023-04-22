import 'package:driver_app/Data/models/local_entity/driver_entity.dart';
import 'package:driver_app/Data/models/requests/update_driver_request.dart';
import 'package:driver_app/Data/services/rest/driver_api_service.dart';
import 'package:driver_app/modules/utils_widget/widgets.dart';
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

  Future<void> validateAndSave() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    isLoading.value = true;

    var body = UpdateDriverRequestBody(
      Address: addressController.text,
      Gender: gender.value,
      IdentityNumber: identityController.text,
      Name: nameController.text,
      Email: driver?.email,
      Phone: driver?.phone,
    );

    try {
      await DriverAPIService.updateDriver(body: body);
      showSnackBar("Success", "Edit Profile Success");
      lifeCycleController.setDriver = await DriverAPIService.getDriverInfo();
    } catch (e) {
      showSnackBar("Error", e.toString());
      // await lifeCycleController.logout();
    }

    isLoading.value = false;
  }
}
