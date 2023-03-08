import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import './otp_controller.dart';

class OtpView extends GetView<OtpController> {
  const OtpView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    const h = SizedBox(
      height: 10,
    );
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
              onPressed: () {
                Get.back();
              },
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.info,
                    color: Colors.black,
                  ),
                ),
              )
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  "assets/icons/phone_icon.png",
                  height: 80,
                ),
                h,
                Text(
                  "You're almost there!",
                  style: textTheme.displayLarge,
                ),
                h,
                const Text(
                  "You must enter OTP which we sent you earlier",
                ),
                h,
                Form(
                  key: controller.formKey,
                  child: Pinput(
                    length: 6,
                    controller: controller.otpController,
                    errorText: controller.error.value,
                  ),
                ),
                h,
                h,
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: Obx(
                    () => ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red),
                        onPressed: controller.isClicked.value
                            ? null
                            : () {
                                controller.startTimer();
                              },
                        child: controller.isClicked.value
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "${controller.start.value}s",
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                ],
                              )
                            : const Text("Resend")),
                  ),
                )
              ],
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: ElevatedButton(
              onPressed: () async {
                // var check = controller.check();
                // if(check){
                //   controller.validateOTP();
                // }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: Obx(() => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: controller.isLoading.value
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Text("Continue"),
                  )),
            ),
          ),
        ));
  }
}
