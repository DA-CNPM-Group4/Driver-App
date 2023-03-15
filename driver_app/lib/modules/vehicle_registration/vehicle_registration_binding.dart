import 'package:get/get.dart';

import 'vehicle_registration_controller.dart';

class VehicleRegistrationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VehicleRegistrationController>(
      () => VehicleRegistrationController(),
    );
  }
}
