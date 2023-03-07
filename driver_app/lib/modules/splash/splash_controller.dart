import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SplashController extends GetxController {
  bool isFirstTimeOpenApp = true;
  @override
  void onInit() async{
    super.onInit();
    var box = await Hive.openBox("bootstrap");
    isFirstTimeOpenApp = await box.get("notFirstTime", defaultValue: true);
  }
}
