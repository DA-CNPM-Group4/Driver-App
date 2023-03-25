import 'dart:async';

import 'package:driver_app/Data/models/realtime_models/realtime_passenger.dart';
import 'package:driver_app/Data/models/realtime_models/trip_request.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class OrderInformation extends StatelessWidget {
  void Function()? onStart;
  void Function(RxBool)? onTrip;
  final RealtimeTripRequest tripRequest;
  final RealtimePassenger passenger;
  RxBool? isLoading = false.obs;
  Timer? timer;

  OrderInformation(
      {Key? key,
      this.onStart,
      this.onTrip,
      required this.tripRequest,
      this.timer,
      required this.passenger})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    var h = (size.height * 0.55).obs;
    var text = "Đã đón khách".obs;
    final formatBalance = NumberFormat("#,##0", "vi_VN");

    return Obx(
      () => AnimatedPositioned(
          width: size.width,
          height: size.height - h.value,
          top: h.value,
          duration: const Duration(milliseconds: 250),
          child: GestureDetector(
            onVerticalDragUpdate: (details) {
              int sensitivity = 8;
              if (details.delta.dy > sensitivity) {
                h.value = size.height * 0.55;
              } else if (details.delta.dy < -sensitivity) {
                h.value = 0;
              }
            },
            child: SafeArea(
              child: Scaffold(
                body: SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        width: 30,
                        child: const Divider(
                          height: 5,
                          thickness: 5,
                          color: Colors.grey,
                        ),
                      ),
                      ListTile(
                        leading: Image.asset(
                          "assets/icons/cat_icon.png",
                          height: 40,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 15),
                        title: const Text(
                          "Order by",
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        subtitle: Text(passenger.info.name),
                        trailing: IconButton(
                            icon: const Icon(
                              Icons.call,
                              color: Colors.green,
                            ),
                            onPressed: () async {
                              await FlutterPhoneDirectCaller.callNumber(
                                  passenger.info.phone);
                            }),
                      ),
                      const Divider(
                        height: 1,
                        color: Colors.black,
                      ),
                      ListTile(
                        leading: Image.asset(
                          "assets/icons/profile_icon.png",
                          height: 40,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 15),
                        title: Text(
                          tripRequest.StartAddress,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        subtitle: Text(tripRequest.StartAddress),
                      ),
                      ListTile(
                        leading: Image.asset(
                          "assets/icons/address_icon.png",
                          height: 40,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 15),
                        title: Text(
                          tripRequest.Destination,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        subtitle: Text(tripRequest.Destination),
                      ),
                      Visibility(
                        visible: h.value == 0 ? true : false,
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            const Divider(
                              height: 1,
                              color: Colors.black,
                            ),
                            ListTile(
                              title: const Text(
                                "Tiền mặt",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              trailing: Text(
                                  "${formatBalance.format(tripRequest.Price)}đ"),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const Divider(
                              height: 1,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                bottomSheet: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: ElevatedButton(
                      onPressed: () {
                        switch (text.value) {
                          case "Đã đón khách":
                            if (onStart != null) onStart!();
                            text.value = "Hoàn thành chuyến";
                            break;
                          case "Hoàn thành chuyến":
                            if (onTrip != null) onTrip!(isLoading!);
                            break;
                        }
                      },
                      child: Obx(() => isLoading!.value
                          ? const CircularProgressIndicator()
                          : Text(text.value))),
                ),
              ),
            ),
          )),
    );
  }
}
