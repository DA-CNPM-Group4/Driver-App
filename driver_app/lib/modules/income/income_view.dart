import 'package:driver_app/modules/trip_info/widgets/session_item.dart';
import 'package:driver_app/themes/base_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

import 'income_controller.dart';

class IncomeView extends GetView<IncomeController> {
  const IncomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          style: BaseTextStyle.heading2(fontSize: 22),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Summary of revenue",
              style: BaseTextStyle.heading2(fontSize: 18),
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
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Revenue",
                        style: BaseTextStyle.heading2(fontSize: 16),
                      ),
                      h_20,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Obx(
                                () => !controller.isLoading.value
                                    ? Text("${controller.income.value} đ",
                                        style: BaseTextStyle.heading2(
                                            fontSize: 16))
                                    : const CircularProgressIndicator(),
                              ),
                              h_20,
                              Obx(() => Text(
                                    "${controller.tripOrderNumber.value} complete orders",
                                    style: BaseTextStyle.heading2(
                                        fontSize: 16, color: Colors.grey),
                                  ))
                            ],
                          ),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  shape: const StadiumBorder()),
                              onPressed: () async {
                                await controller.calculateRevenue(
                                    textTheme: Theme.of(context).textTheme);
                              },
                              child: const Text("Refresh"))
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
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Balance",
                            style: BaseTextStyle.heading2(fontSize: 16),
                          ),
                          Obx(() => controller.isLoading.value
                              ? const CircularProgressIndicator()
                              : Text(
                                  "50000",
                                  // controller.wallet!.balance!.toString(),
                                  style: BaseTextStyle.heading4(fontSize: 16),
                                )),
                        ],
                      ),
                      h_20,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () {
                              // method(type: false, textTheme: TextTheme());
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.arrow_circle_down_sharp,
                                  color: Colors.green,
                                ),
                                h_10,
                                Text(
                                  "Withdraw to bank",
                                  style: BaseTextStyle.heading1(
                                      fontSize: 14, color: Colors.green),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              await controller.calculateRevenue(
                                  textTheme: Theme.of(context).textTheme);
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.schedule_rounded,
                                  color: Colors.green,
                                ),
                                h_10,
                                Text(
                                  "Trips History",
                                  style: BaseTextStyle.heading1(
                                      fontSize: 14, color: Colors.green),
                                ),
                              ],
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Obx(
              () => controller.isLoading.value
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : controller.trips.isEmpty
                      ? SizedBox(
                          height: MediaQuery.of(context).size.height * 0.8,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SvgPicture.asset(
                                  "assets/icons/ic_empty.svg",
                                  width: 200,
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 20),
                                  child: Text(
                                    "You don't have any booking history",
                                    style: TextStyle(color: Colors.grey[700]),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : SizedBox(
                          height: Get.height * 1,
                          child: Column(
                            children: [
                              Expanded(
                                child: ListView.separated(
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(height: 14),
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: controller.trips.length,
                                  itemBuilder: (context, index) => Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    child: SessionItem(
                                      session: controller.trips[index],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
            ),
          ],
        ),
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
          height: Get.height * 0.55,
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              )),
          child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
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
                style: BaseTextStyle.heading2(fontSize: 18),
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 22),
                  Text(
                    "Money",
                    style: BaseTextStyle.body2(fontSize: 16),
                  ),
                  TextFormField(
                      controller: moneyController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
                    child: ElevatedButton(
                        onPressed: () {}, child: const Text("Resend")),
                  ),
                ],
              ),
            ),
            resizeToAvoidBottomInset: false,
            bottomSheet: SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  onPressed: () {},
                  child: const Text("Confirm")),
            ),
          ),
        ));
  }
}
