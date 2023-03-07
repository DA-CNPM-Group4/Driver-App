import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../register/register_controller.dart';

class OtpController extends GetxController {
  var isLoading = false.obs;
  final count = 0.obs;
  var isClicked = true.obs;
  TextEditingController otpController = TextEditingController();
  Timer? timer;
  var start = 30.obs;
  var registerController = Get.find<RegisterController>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  var error = ''.obs;
  
}
