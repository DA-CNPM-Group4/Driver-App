import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:driver_app/data/user_response.dart';

class ConfirmOrder extends StatelessWidget {
  final UserResponse userResponse;
  final void Function(Timer timer)? onStart;
  final void Function(Timer timer)? onTrip;

  const ConfirmOrder(
      {Key? key, required this.userResponse, this.onStart, this.onTrip})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    var text = "Đã đón khách".obs;
    Timer? timer;

    return AnimatedPositioned(
      width: size.width,
      height: size.height - size.height * 0.65,
      top: size.height * 0.65,
      duration: const Duration(milliseconds: 1000),
      child: Material(
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        child: Image.asset("assets/images/face.png"),
                      ),
                      minVerticalPadding: 0,
                      title: Text(
                        userResponse.user!.fullName!,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      subtitle: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userResponse.user!.phoneNumber!,
                            style: const TextStyle(
                                fontSize: 11, color: Colors.grey),
                          ),
                          Text(
                            userResponse.startAddress!.address!,
                            style: const TextStyle(
                                fontSize: 11, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      width: double.infinity,
                      child: const Divider(
                        height: 1,
                      ),
                    ),
                    ListTile(
                      leading: CircleAvatar(
                        child: Image.asset("assets/images/face.png"),
                      ),
                      minVerticalPadding: 0,
                      title: Text(
                        userResponse.destination!.address!,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      subtitle: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userResponse.destination!.address!,
                            style: const TextStyle(
                                fontSize: 11, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Container(
                width: Get.width,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: ElevatedButton(
                    onPressed: () {
                      switch (text.value) {
                        case "Đã đón khách":
                          if (onStart != null) onStart!(timer!);
                          text.value = "Hoàn thành chuyến";
                          break;
                        case "Hoàn thành chuyến":
                          if (onTrip != null) onTrip!(timer!);
                          break;
                      }
                    },
                    child: Obx(() => Text(text.value))),
              )
            ],
          )),
    );
  }
}
