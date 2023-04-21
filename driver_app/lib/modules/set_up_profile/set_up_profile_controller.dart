import 'package:driver_app/Data/models/requests/create_driver_request.dart';
import 'package:driver_app/Data/services/driver_api_service.dart';
import 'package:driver_app/core/constants/backend_enviroment.dart';
import 'package:driver_app/modules/utils_widget/widgets.dart';
import 'package:driver_app/modules/lifecycle_controller.dart';
import 'package:driver_app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/vehicle.dart';

class SetUpProfileController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  var isLoading = false.obs;
  final LifeCycleController lifeCycleController =
      Get.find<LifeCycleController>();

  List<Vehicle> vehicles = [
    Vehicle(
        name: "Bike driver",
        type: "Motorbike",
        description: "Get orders for ride, food, and send.",
        img: "assets/icons/bike.png"),
    Vehicle(
        name: "Car4S",
        type: "Car4S",
        description: "Get orders for Cars4S",
        img: "assets/icons/car.png"),
    Vehicle(
        name: "Car7S",
        type: "Car7S",
        description: "Get orders for Cars7S",
        img: "assets/icons/car.png"),
  ];

  RxBool defaultGender = true.obs;

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

  String? emailValidator(String value) {
    if (value.isEmpty) {
      return "This field must be filled";
    }
    return value.isEmail ? null : "You must enter a right email";
  }

  String? idValidator(String value) {
    if (value.isEmpty) {
      return "This field must be filled";
    }
    return value.length >= 12 ? null : "ID length can't be lower than 12";
  }

  String? driverLicenseValidator(String value) {
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

  var selectedIndex = 0.obs;

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController idController = TextEditingController();
  TextEditingController driverLicenseController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  Future<void> validateAndSave() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    isLoading.value = true;

    lifeCycleController.preLoginedState.setField(
      name: nameController.text,
      identityNumber: idController.text,
      address: addressController.text,
      gender: defaultGender.value,
    );

    if (BackendEnviroment.checkV2Comunication()) {
      Get.toNamed(Routes.PASSWORD_REGISTER);
    } else {
      await _handleCreateInfo(
          lifeCycleController.preLoginedState.toCreateDriverRequestBody());
    }

    isLoading.value = false;
    return;
  }

  Future<void> _handleCreateInfo(CreateDriverRequestBody body) async {
    try {
      await DriverAPIService.createDriverInfo(body: body);
      isLoading.value = false;
      Get.offNamed(Routes.VEHICLE_REGISTRATION);
    } catch (e) {
      showSnackBar("Error", e.toString());
    }
  }
}
