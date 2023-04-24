import 'package:driver_app/core/constants/backend_enviroment.dart';
import 'package:driver_app/core/utils/utils.dart';
import 'package:driver_app/themes/base_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

void showSnackBar(String title, String message, {int second = 3}) {
  Get.snackbar(title, message,
      isDismissible: true,
      colorText: Colors.white,
      backgroundColor: const Color.fromARGB(255, 87, 139, 52),
      duration: Duration(seconds: second));
}

Future<String?> openInputPhoneBottomSheet() async {
  final GlobalKey<FormState> phoneFormKeyBottomSheet = GlobalKey<FormState>();
  String? errorText;
  TextEditingController phoneNumberBottomSheetController =
      TextEditingController();
  String? phone = await Get.bottomSheet(
    Container(
      padding: const EdgeInsets.all(20),
      height: Get.height * 0.2,
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: SizedBox(
        width: Get.width,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Form(
                key: phoneFormKeyBottomSheet,
                child: TextFormField(
                  controller: phoneNumberBottomSheetController,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) =>
                      FieldValidator.phoneNumberValidator(value!),
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      errorText: errorText,
                      hintText: 'Enter phone number',
                      hintStyle: BaseTextStyle.body3(color: Colors.grey),
                      suffixIcon: const Icon(Icons.phone_android)),
                ),
              ),
            ),
            ElevatedButton(
                onPressed: () async {
                  if (await FieldValidator.validateField(
                      phoneFormKeyBottomSheet)) {
                    Get.back(
                      result: phoneNumberBottomSheetController.text,
                    );
                  }
                },
                child: const Text("OK"))
          ],
        ),
      ),
    ),
  );
  return phone;
}

Future<void> openInputStringBottomSheet() async {
  final GlobalKey<FormState> fieldValidator = GlobalKey<FormState>();
  String? errorText;
  TextEditingController fieldController = TextEditingController();
  await Get.bottomSheet(
    Container(
      padding: const EdgeInsets.all(20),
      height: Get.height * 0.2,
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: SizedBox(
        width: Get.width,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Form(
                key: fieldValidator,
                child: TextFormField(
                  controller: fieldController,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.url,
                  decoration: InputDecoration(
                      errorText: errorText,
                      hintText: 'Enter your Ipv4 Address',
                      hintStyle: BaseTextStyle.body3(color: Colors.grey),
                      suffixIcon: const Icon(Icons.phone_android)),
                ),
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  BackendEnviroment.url = fieldController.text;
                },
                child: const Text("OK"))
          ],
        ),
      ),
    ),
  );
}
