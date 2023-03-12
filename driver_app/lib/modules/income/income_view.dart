import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

import 'income_controller.dart';

class IncomeView extends GetView<IncomeController> {
  const IncomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    const h_20 = SizedBox(
      height: 20,
    );
    const h_10 = SizedBox(
      height: 10,
    );
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Income',
            style: textTheme.headline1!.copyWith(fontSize: 25),
          ),
          centerTitle: false,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Summary of revenue",
                style: textTheme.headline1,
              ),
              h_20,
              //first card
              SizedBox(
                width: Get.width,
                child: Card(
                  color: Colors.grey[100],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Today revenue",
                          style: textTheme.headline1!.copyWith(fontSize: 15),
                        ),
                        h_20,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("0 đ", style: textTheme.headline1),
                                h_20,
                                Text(
                                  "O complete order today",
                                  style: textTheme.headline2,
                                )
                              ],
                            ),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.green,
                                    shape: StadiumBorder()),
                                onPressed: () {},
                                child: const Text("Detail"))
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
              h_20,
              //second card
              SizedBox(
                width: Get.width,
                child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  elevation: 3,
                  child:  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Balance",style: textTheme.headline2!.copyWith(fontSize: 15),),
                            Obx(()=> controller.isLoading.value ?  const CircularProgressIndicator() : Text(controller.wallet!.balance!.toString(),style: textTheme.headline1!,)),
                          ],
                        ),
                        h_20,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              onTap: (){
                                method(type: false, textTheme: textTheme);
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children:  [
                                  const Icon(
                                    Icons.arrow_circle_down_sharp,
                                    color: Colors.green,
                                  ),
                                  h_10,
                                  Text("Withdraw to bank",style: textTheme.headline2!.copyWith(fontSize: 15, color: Colors.green),),

                                ],
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children:  [
                                const Icon(
                                    Icons.schedule_rounded,
                                  color: Colors.green,
                                ),
                                h_10,
                                Text("Transaction history",style: textTheme.headline2!.copyWith(fontSize: 15,  color: Colors.green),),

                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              )

            ],
          ),
        )
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
          height: Get.height * 0.45,
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
                  style: textTheme.headline1,
                ),
              ),
              body: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    h,
                    Text(
                      "Money",
                      style: textTheme.headline1!.copyWith(fontSize: 16),
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
                      style: textTheme.headline1!.copyWith(fontSize: 16),
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
                        onPressed: check1.value && check2.value
                            ? () async {
                          await controller.validateOTP(
                              otpController, moneyController, type);
                        }
                            : null,
                        child: controller.buttonLoading.value
                            ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                            : const Text("Confirm")),
                  ))),
        ));
  }

}
