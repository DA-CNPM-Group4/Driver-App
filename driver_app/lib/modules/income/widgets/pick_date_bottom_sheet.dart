import 'package:driver_app/core/utils/utils.dart';
import 'package:driver_app/modules/income/income_controller.dart';
import 'package:driver_app/themes/base_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PickDateBottomSheet extends StatelessWidget {
  const PickDateBottomSheet({super.key, required this.controller});

  final IncomeController controller;
  @override
  Widget build(BuildContext context) {
    return Container(
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
            "Calculate Revenue",
            style: BaseTextStyle.heading2(color: Colors.black),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(height: 22),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Icon(Icons.date_range),
                      Obx(
                        () => Text(
                          "From: ${Utils.dateTimeToDate(controller.from.value)}",
                          style: BaseTextStyle.body2(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                      icon: const Icon(Icons.keyboard_arrow_right),
                      onPressed: () async {
                        await controller.chooseDate(
                            controller.from, "Select From",
                            predicate: controller.disableDateFrom);
                      }),
                ],
              ),
              const SizedBox(height: 22),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Icon(Icons.date_range),
                      Obx(
                        () => Text(
                          "To: ${Utils.dateTimeToDate(controller.to.value)}",
                          style: BaseTextStyle.body2(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                      icon: const Icon(Icons.keyboard_arrow_right),
                      onPressed: () async {
                        await controller.chooseDate(
                          controller.to,
                          "Select To",
                          predicate: controller.disableDateTo,
                        );
                      }),
                ],
              ),
            ],
          ),
        ),
        resizeToAvoidBottomInset: true,
        bottomSheet: SizedBox(
          width: double.infinity,
          height: 60,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: () {
                Get.back(result: true);
              },
              child: const Text("Confirm")),
        ),
      ),
    );
  }
}
