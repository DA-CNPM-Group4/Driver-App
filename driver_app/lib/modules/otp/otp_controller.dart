import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../register/register_controller.dart';

class OtpController extends GetxController {
  var isLoading = false.obs;
  var isClicked = true.obs;
  TextEditingController otpController = TextEditingController();
  Timer? timer;
  var start = 15.obs;
  var registerController = Get.find<RegisterController>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  var error = ''.obs;
  
  @override
  void onInit() async{
    super.onInit();
    await startTimer();
  }

  String? validator(){
    if(otpController.text.isEmpty){
      return "OTP can't be empty";
    }
    else if(otpController.text.length < 6){
      return "Please fill all the numbers";
    }
    return null;
  }

  Future<bool> validateOTP() async{
    return true;
  }

  bool check() {
    final isValid = formKey.currentState!.validate();
    if (!isValid) {
      return false;
    }
    formKey.currentState!.save();
    return true;
  }


  sendOTP() async {
    // var response = await apiHandlerImp.put(
    //     {"username": "0${registerController.phoneNumberController.text}"},
    //     "sendOTP");
  }

  Future<void> startTimer() async {
    isClicked.value = true;
    const oneSec = Duration(seconds: 1);
    await sendOTP();
    timer = Timer.periodic(
      oneSec,
          (Timer timer) {
        if (start.value == 0) {
          start.value = 30;
          isClicked.value = false;
          timer.cancel();
        } else {
          start.value -= 1;
        }
      },
    );
  }

}
