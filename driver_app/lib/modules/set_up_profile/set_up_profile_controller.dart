import 'package:driver_app/Data/models/requests/create_driver_request.dart';
import 'package:driver_app/Data/services/rest/driver_api_service.dart';
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
    if (BackendEnviroment.checkV2Comunication() &&
        !lifeCycleController.isloginByGoogle) {
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
