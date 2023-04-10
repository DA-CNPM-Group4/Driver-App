import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showSnackBar(String title, String message, {int second = 3}) {
  Get.snackbar(title, message,
      isDismissible: true,
      colorText: Colors.white,
      backgroundColor: Color.fromARGB(255, 87, 139, 52),
      duration: Duration(seconds: second));
}
