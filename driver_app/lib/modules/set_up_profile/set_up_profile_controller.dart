import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/api_handler.dart';
import '../../data/vehicle.dart';

class SetUpProfileController extends GetxController {
  //TODO: Implement SetUpProfileController
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  APIHandlerImp apiHandlerImp = APIHandlerImp();
  var isLoading = false.obs;

  List<Vehicle> vehicles = [
    Vehicle(
        name: "Bike driver",
        type: "MOTORBIKE",
        description: "Get orders for ride, food, and send.",
        img: "assets/icons/bike.png"),
    Vehicle(
        name: "Car4S",
        type: "CAR4S",
        description: "Get orders for Cars4S",
        img: "assets/icons/car.png"),
    Vehicle(
        name: "Car7S",
        type: "CAR7S",
        description: "Get orders for Cars7S",
        img: "assets/icons/car.png"),
    Vehicle(
        name: "Car16S",
        type: "CAR16S",
        description: "Get orders for Cars16S",
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

  Future<bool> validateAndSave() async {
    isLoading.value = true;
    final isValid = formKey.currentState!.validate();
    if (!isValid) {
      isLoading.value = false;
      return false;
    }

    var response = await apiHandlerImp.post({
      "phoneNumber": phoneNumberController.text,
      "email": emailController.text,
      "driverName": nameController.text,
      "gender": defaultGender.value ? "Male" : "Female",
      "driverAddress": addressController.text,
      "citizenId": idController.text,
      "driverLicenseId": driverLicenseController.text
    }, "driver/checkDriverInfo");

    if (!response.data["status"]) {
      print(response.data["data"]);
      isLoading.value = false;
      return false;
    }

    isLoading.value = false;
    return true;
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
