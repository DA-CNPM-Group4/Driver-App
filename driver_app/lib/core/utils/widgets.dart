import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showSnackBar(String title, String message, {int second = 3}) {
  Get.snackbar(title, message,
      colorText: Colors.black,
      backgroundColor: Colors.grey[500],
      duration: Duration(seconds: second));
}
