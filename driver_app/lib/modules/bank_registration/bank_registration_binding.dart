import 'package:get/get.dart';

import 'bank_registration_controller.dart';

class BankRegistrationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BankRegistrationController>(
      () => BankRegistrationController(),
    );
  }
}
