import 'dart:async';

import 'package:driver_app/Data/model/driver_entity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../../data/model/wallet.dart';

class IncomeController extends GetxController {
  final count = 0.obs;

  var isLoading = false.obs;
  Wallet? wallet;
  var isClicked = false.obs;
  var start = 30.obs;
  Timer? timer;
  var error = ''.obs;
  var buttonLoading = false.obs;
  DriverEntity? driverEntity;

  @override
  void onInit() async {
    super.onInit();
    isLoading.value = true;
    var box = await Hive.openBox("box");
    driverEntity = await box.get("driver");
    // await getWallet();
    isLoading.value = false;
  }

  @override
  void onReady() async {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  // Future<void> getWallet() async {
  //   isLoading.value = true;
  //   var response_1 = await apiHandlerImp.get("driver/getWallet", {});
  //   try {
  //     wallet = Wallet.fromJson(response_1.data["data"]);
  //   } catch (e) {
  //     wallet = Wallet.fromJson(response_1.data["data"]);
  //   }
  //   isLoading.value = false;
  // }

  // sendOTP() async {
  //   var response =
  //       await apiHandlerImp.put({"username": driverEntity!.phone!}, "sendOTP");
  // }

  // validateOTP(TextEditingController otpController,
  //     TextEditingController moneyController, bool type) async {
  //   buttonLoading.value = true;
  //   var response = await apiHandlerImp.put(
  //       {"username": driverEntity!.phone!, "otp": otpController.text},
  //       "validateOTP");
  //   if (response.data["status"]) {
  //     var response_1 = await apiHandlerImp
  //         .put({"money": moneyController.text}, "driver/withdraw");
  //     if (response_1.data["status"]) {
  //       isLoading.value = true;
  //       if (type) {
  //         wallet!.balance =
  //             wallet!.balance! + double.parse(moneyController.text);
  //       } else {
  //         wallet!.balance =
  //             wallet!.balance! - double.parse(moneyController.text);
  //       }
  //       Get.back();
  //       Get.snackbar("Success", "Your order was success",
  //           backgroundColor: Colors.grey[100]);
  //       isLoading.value = false;
  //     } else {
  //       Get.snackbar("Fail", "Balance is inefficient",
  //           backgroundColor: Colors.grey[100]);
  //     }
  //   } else {
  //     Get.snackbar("Fail", "OTP was wrong, try again",
  //         backgroundColor: Colors.grey[100]);
  //   }
  //   buttonLoading.value = false;
  // }

  // Future<void> startTimer() async {
  //   isClicked.value = true;
  //   const oneSec = Duration(seconds: 1);
  //   await sendOTP();
  //   timer = Timer.periodic(
  //     oneSec,
  //     (Timer timer) {
  //       if (start.value == 0) {
  //         start.value = 30;
  //         isClicked.value = false;
  //         timer.cancel();
  //       } else {
  //         start.value -= 1;
  //       }
  //     },
  //   );
  // }

  void increment() => count.value++;
}
