import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final GlobalKey<FormState> phoneFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> emailFormKey = GlobalKey<FormState>();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  RxString error = ''.obs;
  RxBool isLoading = false.obs;
  RxBool isUsingEmail = false.obs;

  String? phoneNumberValidator(String value) {
    if (value.isEmpty) {
      return "This field must be filled";
    } else if (!value.isPhoneNumber) {
      return "You must enter a right phone number";
    }
    return null;
  }

  String? emailValidator(String value) {
    if (value.isEmpty) {
      return "This field must be filled";
    } else if (!value.isEmail) {
      return "You must enter a email address";
    }
    return null;
  }

  Future<bool> validateAndSave() async {
    isLoading.value = true;
    if (!isUsingEmail.value) {
      if (!phoneFormKey.currentState!.validate()) {
        isLoading.value = false;
        return false;
      }
    } else {
      if (!emailFormKey.currentState!.validate()) {
        isLoading.value = false;
        return false;
      }
    }
    // call api to check

    isUsingEmail.value
        ? emailFormKey.currentState!.save()
        : phoneFormKey.currentState!.save();
    isLoading.value = false;
    return true;
  }

  void changeLoginMethod() {
    isUsingEmail.value = !isUsingEmail.value;
  }
}
