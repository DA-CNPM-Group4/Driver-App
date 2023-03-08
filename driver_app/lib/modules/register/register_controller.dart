import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
  final GlobalKey<FormState> phoneFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> emailFormKey = GlobalKey<FormState>();

  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  var isLoading = false.obs;
  var isUsingEmail = false.obs;
  var phoneError = ''.obs;
  var emailError = ''.obs;

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
    final isPhoneValid = phoneFormKey.currentState!.validate();
    final isEmailValid =  emailFormKey.currentState!.validate();
    if (!isPhoneValid || !isEmailValid) {
      isLoading.value = false;
      return false;
    }

    // call api to check

    phoneFormKey.currentState!.save();
    emailFormKey.currentState!.save();
    isLoading.value = false;
    return true;
  }
}
