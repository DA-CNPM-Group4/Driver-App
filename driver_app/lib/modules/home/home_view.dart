import 'package:driver_app/modules/dashboard_page/dashboard_page_controller.dart';
import 'package:driver_app/modules/home/widgets/dragable_buble_chat.dart';
import 'package:driver_app/themes/base_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:progress_indicators/progress_indicators.dart';

import '../../routes/app_routes.dart';
import 'controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Stack(
        key: controller.parentKey,
        children: [
          Obx(
            () => controller.isMapLoaded.value
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : GoogleMap(
                    zoomControlsEnabled: false,
                    myLocationButtonEnabled: false,
                    polylines: controller.polyline.toSet(),
                    myLocationEnabled: true,
                    markers: controller.markers.values.toSet(),
                    onMapCreated: (GoogleMapController control) {
                      controller.googleMapController = control;
                    },
                    initialCameraPosition: CameraPosition(
                      target: LatLng(
                          controller.currentDriverPosition["latitude"] ?? 0,
                          controller.currentDriverPosition["longitude"] ?? 0),
                      zoom: 14.44,
                    ),
                  ),
          ),
          Obx(
            () => Visibility(
              visible: !controller.isAcceptedTrip.value,
              child: SafeArea(
                child: Container(
                  height: 55,
                  margin:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  color: Colors.transparent,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.toNamed(Routes.USER);
                        },
                        child: Image.asset(
                          "assets/images/Flexibility.png",
                          height: 50,
                        ),
                      ),
                      Expanded(
                          child: GestureDetector(
                        onTap: () {
                          if (controller.isDriverActive.value) {
                            showGeneralDialog(
                                barrierColor: Colors.black.withOpacity(0.5),
                                transitionBuilder: (context, a1, a2, widget) {
                                  return ScaleTransition(
                                      alignment: Alignment.center,
                                      scale: Tween<double>(begin: 0.25, end: 1)
                                          .animate(a1),
                                      child: FadeTransition(
                                        opacity:
                                            Tween<double>(begin: 0.25, end: 1)
                                                .animate(a1),
                                        child: SafeArea(
                                            child: customDialog(
                                                textTheme: textTheme)),
                                      ));
                                },
                                transitionDuration:
                                    const Duration(milliseconds: 300),
                                barrierDismissible: true,
                                barrierLabel: '',
                                context: context,
                                pageBuilder: (context, animation1, animation2) {
                                  return Container();
                                });
                          } else {}
                        },
                        child: Card(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          elevation: 3,
                          child: Center(
                            child: controller.isLoading.value
                                ? JumpingText('Loading...',
                                    style: BaseTextStyle.body2(fontSize: 14))
                                : Text(
                                    controller.isDriverActive.value
                                        ? "Active"
                                        : "Inactive",
                                    style: BaseTextStyle.heading4(fontSize: 18),
                                  ),
                          ),
                        ),
                      )),
                      SizedBox(
                        height: 50,
                        child: Obx(
                          () => FloatingActionButton(
                            key: const Key("home_active_inactive_btn"),
                            backgroundColor: controller.isDriverActive.value
                                ? Colors.green
                                : Colors.black,
                            child: controller.isLoading.value
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : Image.asset(
                                    "assets/icons/on_icon.jpg",
                                    color: Colors.white,
                                    height: 20,
                                  ),
                            onPressed: () async {
                              await controller.toggleActive(context);
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          Obx(
            () => Positioned.fill(
              bottom: !controller.isAcceptedTrip.value
                  ? Get.height * 0.03
                  : Get.height * 0.35,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                alignment: Alignment.bottomRight,
                child: FloatingActionButton(
                    heroTag: "tag",
                    backgroundColor: Colors.white,
                    child: const Icon(
                      Icons.location_on,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      controller.googleMapController.animateCamera(
                          CameraUpdate.newCameraPosition(CameraPosition(
                        target: LatLng(
                            controller.currentDriverPosition.value["latitude"],
                            controller
                                .currentDriverPosition.value["longitude"]),
                        zoom: 14.44,
                      )));
                    }),
              ),
            ),
          ),
          Obx(
            () => controller.isAcceptedTrip.value &&
                    !controller.isPickupPassenger.value
                ? DraggableFloatingActionButton(
                    initialOffset: const Offset(120, 70),
                    parentKey: controller.parentKey,
                    onPressed: () async {
                      await Get.find<DashboardPageController>()
                          .openChatScreen();
                    },
                    child: Container(
                        width: 60,
                        height: 60,
                        decoration: const ShapeDecoration(
                          shape: CircleBorder(),
                          color: Color.fromARGB(255, 18, 190, 69),
                        ),
                        child: const Icon(Icons.chat_bubble)),
                  )
                : Container(),
          ),
        ],
      ),
    );
  }

  Widget customDialog({required TextTheme textTheme}) {
    const divider = Divider(
      height: 1,
      color: Colors.black,
    );
    const h_20 = SizedBox(
      height: 20,
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            height: Get.height * 0.25,
            width: Get.width,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(16)),
            child: Column(
              children: [
                Text(
                  "Active",
                  style: BaseTextStyle.heading1(),
                ),
                h_20,
                divider,
                h_20,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Automatically accept",
                        style: BaseTextStyle.heading2(fontSize: 16),
                      ),
                      CupertinoSwitch(
                        value: true,
                        onChanged: (value) {},
                      ),
                    ],
                  ),
                ),
                h_20,
                divider,
                h_20,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Credit",
                        style: BaseTextStyle.heading2(fontSize: 16),
                      ),
                      Text("thanhson232",
                          style: BaseTextStyle.heading2(fontSize: 16))
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        h_20,
        FloatingActionButton(
            backgroundColor: Colors.white,
            child: Image.asset(
              "assets/icons/x-icon.png",
              height: 50,
              width: 50,
            ),
            onPressed: () {
              Get.back();
            }),
      ],
    );
  }
}
