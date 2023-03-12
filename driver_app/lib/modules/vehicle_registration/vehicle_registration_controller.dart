import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:driver_app/data/api_handler.dart';
import 'package:driver_app/modules/password/password_controller.dart';
import 'package:driver_app/modules/register/register_controller.dart';
import 'package:driver_app/modules/set_up_profile/set_up_profile_controller.dart';

import '../../routes/app_pages.dart';
import '../../routes/app_routes.dart';

class VehicleRegistrationController extends GetxController {
  //TODO: Implement VehicleRegistrationController
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  var isLoading = false.obs;
  APIHandlerImp apiHandlerImp = APIHandlerImp();
  List<String> motorcycleBrand = [
    "Honda",
    "Triumph",
    "Yamaha",
    "Harley – Davidson",
    "Benelli",
    "Kawasaki",
    "Ducati",
    "Suzuki",
    "BMW",
    "Zongshen",
    "SYM",
    "Yadea",
    "Niu",
    "Piaggio",
    "Vinfast",
  ];

  List<String> carBrand = [
    "Abarth",
    "Alfa Romeo",
    "Aston Martin",
    "Audi",
    "Bentley",
    "BMW",
    "Bugatti",
    "Cadillac",
    "Chevrolet",
    "Chrysler",
    "Citroën",
    "Dacia",
    "Daewoo",
    "Daihatsu",
    "Dodge",
    "Donkervoort",
    "DS",
    "Ferrari",
    "Fiat",
    "Fisker",
    "Ford",
    "Honda",
    "Hummer",
    "Hyundai",
    "Infiniti",
    "Iveco",
    "Jaguar",
    "Jeep",
    "Kia",
    "KTM",
    "Lada",
    "Lamborghini",
    "Lancia",
    "Land Rover",
    "Landwind",
    "Lexus",
    "Lotus",
    "Maserati",
    "Maybach",
    "Mazda",
    "McLaren",
    "Mercedes-Benz",
    "MG",
    "Mini",
    "Mitsubishi",
    "Morgan",
    "Nissan",
    "Opel",
    "Peugeot",
    "Porsche",
    "Renault",
    "Rolls-Royce",
    "Rover",
    "Saab",
    "Seat",
    "Skoda",
    "Smart",
    "SsangYong",
    "Subaru",
    "Suzuki",
    "Tesla",
    "Toyota",
    "Volkswagen",
    "Volvo"
  ];

  var setUpProfileController = Get.find<SetUpProfileController>();
  var registerController = Get.find<RegisterController>();
  var passwordController = Get.find<PasswordController>();

  TextEditingController vehicleBrandController = TextEditingController();
  TextEditingController numberPlateController = TextEditingController();
  TextEditingController vehicleType = TextEditingController();
  TextEditingController ownerName = TextEditingController();

  String? ownerNameValidator(String value) {
    if (value.isEmpty) {
      return "This field must be filled";
    }
    return RegExp(r'^[a-z A-Z,.\-]+$',
                caseSensitive: false, unicode: true, dotAll: true)
            .hasMatch(value)
        ? null
        : "Name can't contains special characters or number";
  }

  String? numberPlateValidator(String value) {
    if (value.isEmpty) return "This field must be filled";

    return value.length < 6 ? "Please enter a real number plate" : null;
  }

  String? vehicleBrandValidator(String value) {
    if (value.isEmpty) return "This field must be filled";

    return null;
  }

  String? vehicleTypeValidator(String value) {
    if (value.isEmpty) return "This field must be filled";

    return null;
  }

  Future<bool> validateAndSave() async {
    isLoading.value = true;
    final isValid = formKey.currentState!.validate();
    if (!isValid) {
      isLoading.value = false;
      return false;
    }

    var response = await apiHandlerImp.post({
      "vehiclePlateNum": numberPlateController.text,
      "ownername": ownerName.text
    }, "driver/checkVehiclePlateNum");

    if (!response.data["status"]) {
      print(response.data["data"]);
      isLoading.value = false;
      return false;
    }

    formKey.currentState!.save();
    isLoading.value = false;
    return true;
  }

  Future<void> register() async {
    isLoading.value = true;
    var response = await apiHandlerImp.post({
      "username": "0${registerController.phoneNumberController.text}",
      "password": passwordController.passwordController.text,
      "driverInfor": {
        "phoneNumber": setUpProfileController.phoneNumberController.text,
        "email": setUpProfileController.emailController.text,
        "driverName": setUpProfileController.nameController.text,
        "gender":
            setUpProfileController.defaultGender.value ? "Male" : "Female",
        "driverAddress": setUpProfileController.addressController.text,
        "citizenId": setUpProfileController.idController.text,
        "driverLicenseId": setUpProfileController.driverLicenseController.text,
        "vehicleList": [
          {
            "ownername": ownerName.text,
            "licensePlateNum": numberPlateController.text,
            "typeOfVehicle": setUpProfileController
                .vehicles[setUpProfileController.selectedIndex.value].type,
            "brand": "${vehicleBrandController.text} ${vehicleType.text}"
          }
        ]
      }
    }, "driver/signup");
    if(response.data["status"]){
      Get.snackbar("Success", "You can use your account to experience our app from now on",backgroundColor: Colors.grey[100]!);
      Get.offAllNamed(Routes.WELCOME);
    }
    isLoading.value = false;
  }

  var selectedItem = 0.obs;

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
