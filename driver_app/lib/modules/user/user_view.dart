import 'package:driver_app/themes/base_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';

import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

import 'user_controller.dart';

class UserView extends GetView<UserController> {
  const UserView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.grey,
            ),
            onPressed: () {
              Get.back();
            },
          ),
          title: Text(
            "Account",
            style: BaseTextStyle.heading2(fontSize: 18, color: Colors.white),
          ),
        ),
        extendBodyBehindAppBar: true,
        body: Stack(
          children: [
            Image.asset(
              "assets/images/background.jpg",
              height: Get.height,
              fit: BoxFit.fitHeight,
            ),
            Positioned(
                top: Get.height * 0.20,
                child: Container(
                  height: Get.height - Get.height * 0.2,
                  width: Get.width,
                  padding: EdgeInsets.only(top: Get.height * 0.1, bottom: 10),
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16))),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.bottomSheet(choice(textTheme: textTheme));
                        },
                        child: Obx(
                          () => controller.isLoading.value
                              ? const Center(child: CircularProgressIndicator())
                              : CreditCardWidget(
                                  isSwipeGestureEnabled: false,
                                  cardNumber: "123456789123456789",
                                  expiryDate: "",
                                  cvvCode: "",
                                  cardHolderName:
                                      "Balance ${controller.wallet!.balance!}",
                                  bankName: controller.driverEntity?.name ??
                                      "unKnown",
                                  isHolderNameVisible: true,
                                  showBackView: false,
                                  onCreditCardWidgetChange:
                                      (CreditCardBrand) {}, //true when you want to show cvv(back) view
                                ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      ListTile(
                        leading: const Icon(
                          Icons.star,
                          color: Colors.brown,
                        ),
                        title: Text(
                          "Assessment",
                          style: BaseTextStyle.heading2(fontSize: 18),
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios),
                      ),
                      ListTile(
                        onTap: () async {
                          await controller.logout();
                        },
                        leading: const Icon(
                          Icons.logout,
                          color: Colors.brown,
                        ),
                        title: Text(
                          "Log out",
                          style: BaseTextStyle.heading2(fontSize: 18),
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios),
                      ),
                    ],
                  ),
                )),
            Positioned(
                top: Get.height * 0.13,
                child: SizedBox(
                  height: Get.height * 0.15,
                  width: Get.width,
                  child: Card(
                    elevation: 5,
                    margin: const EdgeInsets.symmetric(horizontal: 30),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Obx(
                      () => controller.isLoading.value
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 15),
                              leading: Image.asset("assets/Flexibility.png"),
                              title: Text(
                                controller.driverEntity?.name ?? "Unknown",
                                style: BaseTextStyle.heading4(fontSize: 18),
                              ),
                              subtitle: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    controller.driverEntity?.phone ?? "Unknown",
                                    style: BaseTextStyle.body2(fontSize: 14),
                                  ),
                                  Text(
                                    controller.driverEntity?.address ??
                                        "Unknown",
                                    style: BaseTextStyle.body2(fontSize: 14),
                                  ),
                                  Text(
                                    controller.vehicleEntity?.brand ?? "Unknow",
                                    style: BaseTextStyle.body2(fontSize: 14),
                                  )
                                ],
                              ),
                            ),
                    ),
                  ),
                ))
          ],
        ));
  }

  Widget choice({required TextTheme textTheme}) {
    return Container(
      padding: const EdgeInsets.only(top: 10),
      height: Get.height * 0.2,
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          )),
      child: Column(
        children: [
          const SizedBox(
            width: 25,
            child: Divider(
              color: Colors.black,
              thickness: 5,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            "Which choice do you want to choose?",
            style: BaseTextStyle.heading2(fontSize: 16),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView(
              children: [
                // ListTile(
                //   onTap: () {
                //     Get.back();
                //     method(type: true, textTheme: textTheme);
                //   },
                //   leading: const Icon(
                //     Icons.move_to_inbox,
                //     color: Colors.black,
                //   ),
                //   title: const Text("Recharge"),
                //   trailing: const Icon(
                //     Icons.arrow_forward_ios,
                //     color: Colors.black,
                //   ),
                // ),
                ListTile(
                  onTap: () {
                    Get.back();
                    method(type: false, textTheme: textTheme);
                  },
                  leading: const Icon(
                    Icons.outbox,
                    color: Colors.black,
                  ),
                  title: const Text("Withdraw"),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.black,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void method({required bool type, required TextTheme textTheme}) async {
    TextEditingController otpController = TextEditingController();
    TextEditingController moneyController = TextEditingController();
    var check1 = false.obs;
    var check2 = false.obs;
    moneyController.addListener(() {
      if (moneyController.text.isNotEmpty) {
        check1.value = true;
      } else {
        check1.value = false;
      }
    });
    otpController.addListener(() {
      if (otpController.text.length == 6) {
        check2.value = true;
      } else {
        check2.value = false;
      }
    });
    const h = SizedBox(
      height: 10,
    );

    Get.bottomSheet(
        isDismissible: false,
        isScrollControlled: true,
        Container(
          padding: const EdgeInsets.all(10),
          height: Get.height * 0.52,
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              )),
          child: Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  icon: const Icon(
                    Icons.close,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Get.back();
                  },
                ),
                centerTitle: true,
                title: Text(
                  type ? "Recharge" : "Withdraw",
                  style: BaseTextStyle.heading2(fontSize: 16),
                ),
              ),
              body: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    h,
                    Text(
                      "Money",
                      style: BaseTextStyle.body2(fontSize: 16),
                    ),
                    TextFormField(
                        controller: moneyController,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: const InputDecoration(
                          hintText: 'e.g 50000',
                        )),
                    h,
                    Text(
                      "OTP",
                      style: BaseTextStyle.body2(fontSize: 16),
                    ),
                    h,
                    Pinput(
                      length: 6,
                      controller: otpController,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Obx(
                        () => ElevatedButton(
                            onPressed: controller.isClicked.value
                                ? null
                                : () async {
                                    await controller.startTimer();
                                  },
                            child: controller.isClicked.value
                                ? Text(
                                    "${controller.start.value}s",
                                    style: const TextStyle(fontSize: 20),
                                  )
                                : const Text("Resend")),
                      ),
                    ),
                  ],
                ),
              ),
              resizeToAvoidBottomInset: false,
              bottomSheet: SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: Obx(
                    () => ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: Colors.green),
                        onPressed: () {},
                        // onPressed: check1.value && check2.value
                        //     ? () async {
                        //         await controller.validateOTP(
                        //             otpController, moneyController, type);
                        //       }
                        //     : null,
                        child: controller.buttonLoading.value
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text("Confirm")),
                  ))),
        ));
  }
}
