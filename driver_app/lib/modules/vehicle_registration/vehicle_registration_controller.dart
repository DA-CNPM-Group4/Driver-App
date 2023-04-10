import 'package:driver_app/Data/models/requests/create_vehicle_request.dart';
import 'package:driver_app/Data/services/driver_api_service.dart';
import 'package:driver_app/modules/utils_widget/widgets.dart';
import 'package:driver_app/modules/lifecycle_controller.dart';
import 'package:driver_app/modules/password_register/password_controller.dart';
import 'package:driver_app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:driver_app/modules/register/register_controller.dart';
import 'package:driver_app/modules/set_up_profile/set_up_profile_controller.dart';

class VehicleRegistrationController extends GetxController {
  final LifeCycleController lifeCycleController =
      Get.find<LifeCycleController>();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  var isLoading = false.obs;
  var setupProfileController = Get.find<SetUpProfileController>();

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
  TextEditingController vehicleNameController = TextEditingController();

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

    formKey.currentState!.save();
    isLoading.value = false;
    return true;
  }

  Future<void> register() async {
    isLoading.value = true;
    try {
      var body = CreateVehicleRequestBody(
        Brand: vehicleBrandController.text,
        VehicleName: vehicleNameController.text,
        VehicleType: setupProfileController
            .vehicles[setupProfileController.selectedIndex.value].type,
        LicensePlatesNum: numberPlateController.text,
      );
      await DriverAPIService.registerVehicle(body: body);
      lifeCycleController.setVehicle = await DriverAPIService.getVehicle();

      Get.offNamedUntil(
          Routes.DASHBOARD_PAGE, ModalRoute.withName(Routes.HOME));
      showSnackBar("Sucess", "You can access our system from now on");
    } catch (e) {
      showSnackBar("Error", e.toString());
    }

    isLoading.value = false;
  }

  var selectedItem = 0.obs;
}
