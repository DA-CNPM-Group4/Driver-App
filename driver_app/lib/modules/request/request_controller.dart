import 'dart:async';

import 'package:get/get.dart';
import 'package:driver_app/data/api_handler.dart';
import 'package:driver_app/modules/home/controllers/home_controller.dart';

class RequestController extends GetxController {
  //TODO: Implement RequestController

  var homeController = Get.find<HomeController>();
  final count = 10.obs;
  var data = {};
  var isLoading = false.obs;
  APIHandlerImp apiHandlerImp = APIHandlerImp();

  Future<void> handleAccept() async {
    var id = data["requestId"].toString();
    Get.log(id);
    var response = await apiHandlerImp.get("driver/acceptBooking/$id", {});
    if(response.data["status"]){
      Get.back(result: {"answer": true, "path": response.data["data"], "id": data["requestId"].toString()});
    } else {
      Get.snackbar("Failed", "Failed");
      Get.back();
    }
  }

  @override
  void onInit() async{
    super.onInit();
    isLoading.value = true;
    data = await Get.arguments["key"];
    isLoading.value = false;
  }

  @override
  void onReady() async {
    super.onReady();

    while (true) {
      if (count.value == 0) {
        Get.back();
      }
      await Future.delayed(const Duration(seconds: 1)).then((_) {
        count.value -= 1;
      });
    }

  }

  @override
  void onClose() {
    super.onClose();
  }
}
