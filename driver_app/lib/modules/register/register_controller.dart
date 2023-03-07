import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController phoneNumberController = TextEditingController();
  var isLoading = false.obs;
  var error = ''.obs;


  String? phoneNumberValidator(String value) {
    if(value.isEmpty){
      return "This field must be filled";
    } else if(!value.isPhoneNumber){
      return "You must enter a right phone number";
    }
    return null;
  }

  Future<bool> validateAndSave() async{
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
}
