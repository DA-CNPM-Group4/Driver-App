import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PasswordController extends GetxController {
  //TODO: Implement PasswordController
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController passwordController = TextEditingController();

  String? passwordValidator(String value){
    if(value.isEmpty){
      return "This field must be filled";
    } else if(value.length < 6){
      return "The password length must be greater than 6 digits";
    }
    return null;
  }

  bool validateAndSave() {
    final FormState? form = formKey.currentState;
    if (form!.validate()) {
      return true;
    }
    return false;
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
