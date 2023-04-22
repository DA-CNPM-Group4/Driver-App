import 'package:driver_app/modules/chat/chat_controller.dart';
import 'package:driver_app/modules/home/controllers/home_controller.dart';
import 'package:driver_app/modules/income/income_controller.dart';
import 'package:driver_app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardPageController extends GetxController {
  late final IncomeController incomeController;
  late final ChatController chatController;
  late final HomeController homeController;

  RxInt newMessage = 0.obs;

  @override
  void onInit() {
    super.onInit();
    incomeController = Get.find<IncomeController>();
    homeController = Get.find<HomeController>();
    chatController = Get.find<ChatController>();

    Get.routing.obs.listen((route) {
      debugPrint(route.current);
    });
  }

  Future<void> openChatScreen() async {
    homeController.overlayEntry?.remove();
    await Get.toNamed(Routes.CHAT)?.then((value) {
      if (homeController.overlayEntry != null) {
        homeController.overlayState?.insert(homeController.overlayEntry!);
      }
    });
  }

  Future<void> initChat(String passengerId, String tripid) async {
    await chatController.initChat(passengerId, tripid);
  }

  Future<void> resetState() async {
    newMessage.value = 0;
    homeController.resetState();
    chatController.resetState();
  }

  var tabIndex = 0.obs;
  void changeTabIndex(int index) {
    tabIndex.value = index;
  }
}
