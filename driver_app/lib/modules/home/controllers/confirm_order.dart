import 'package:driver_app/Data/models/realtime_models/realtime_passenger.dart';
import 'package:driver_app/Data/models/realtime_models/trip_request.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class OrderInformation extends StatelessWidget {
  final void Function()? onStart;
  final void Function()? onCancel;
  final void Function()? onTrip;
  final RealtimeTripRequest tripRequest;
  final RealtimePassengerInfo passenger;
  final RxBool? isLoading = false.obs;
  final RxBool onDestination = false.obs;

  OrderInformation(
      {Key? key,
      this.onStart,
      this.onCancel,
      this.onTrip,
      required this.tripRequest,
      required this.passenger})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    var h = (size.height * 0.55).obs;
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
                          "assets/icons/profile_icon.png",
                          height: 40,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 15),
                        title: const Text(
                          "Order by",
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        subtitle: Text(passenger.name),
                        trailing: IconButton(
                            icon: const Icon(
                              Icons.call,
                              color: Colors.green,
                            ),
                            onPressed: () async {
                              await FlutterPhoneDirectCaller.callNumber(
                                  passenger.phone);
                            }),
                      ),
                      const Divider(
                        height: 1,
                        color: Colors.black,
                      ),
                      ListTile(
                        leading: Image.asset(
                          "assets/icons/address_icon.png",
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
                                "Price",
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
                  child: Obx(
                    () => !onDestination.value
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ElevatedButton(
                                key: const Key("confirm_order_cancel_trip"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                ),
                                onPressed: () {
                                  if (onCancel != null) onCancel?.call();
                                },
                                child: Obx(
                                  () => isLoading!.value
                                      ? const CircularProgressIndicator()
                                      : const Text("Canceling Trip"),
                                ),
                              ),
                              ElevatedButton(
                                key:
                                    const Key("confirm_order_picked_passenger"),
                                onPressed: () {
                                  if (onStart != null) onStart!();
                                  onDestination.value = true;
                                },
                                child: Obx(
                                  () => isLoading!.value
                                      ? const CircularProgressIndicator()
                                      : const Text("Picked Passenger"),
                                ),
                              ),
                            ],
                          )
                        : ElevatedButton(
                            key: const Key("confirm_order_complete_trip"),
                            onPressed: () async {
                              onTrip?.call();
                            },
                            child: Obx(() => isLoading!.value
                                ? const CircularProgressIndicator()
                                : const Text("Completed Trip")),
                          ),
                  ),
                ),
              ),
            ),
          )),
    );
  }
}
