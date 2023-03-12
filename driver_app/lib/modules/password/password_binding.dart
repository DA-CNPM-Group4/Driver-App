import 'package:get/get.dart';

import 'password_controller.dart';

class PasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PasswordController>(
      () => PasswordController(),
    );
  }
}
