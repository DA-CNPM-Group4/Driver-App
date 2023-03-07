import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController phoneNumberController = TextEditingController();
  RxString error = ''.obs;
  RxBool isLoading = false.obs;

  TextEditingController emailController = TextEditingController();
  
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

    // call api to check if phone existed -  (very bad code from references resource)

    formKey.currentState!.save();
    isLoading.value = false;
    return true;
  }

}
