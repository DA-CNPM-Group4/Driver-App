import 'package:driver_app/Data/models/local_entity/driver_entity.dart';
import 'package:driver_app/Data/models/local_entity/vehicle_entity.dart';
import 'package:driver_app/Data/models/realtime_models/realtime_driver.dart';
import 'package:driver_app/Data/services/driver_api_service.dart';
import 'package:driver_app/core/utils/widgets.dart';
import 'package:driver_app/routes/app_routes.dart';
import 'package:get/get.dart';

class LifeCycleController extends SuperController {
  late DriverEntity? driver;
  late VehicleEntity? vehicle;
  late RealtimeDriver realtimeDriver;

  String phone = "";
  String email = "";

  RxBool isActive = false.obs;
  RxDouble latitud = 0.0.obs;
  RxDouble longitud = 0.0.obs;

  @override
  void onDetached() {}

  @override
  void onInactive() {}

  @override
  void onPaused() {}

  @override
  void onResumed() {}

  void setAuthFieldInfo(String phone, String email) {
    this.phone = phone;
    this.email = email;
  }

  Future<void> logout() async {
    phone = "";
    email = "";
    driver = null;
    vehicle = null;
    try {
      await DriverAPIService.authApi.logout();
    } catch (e) {
      showSnackBar("Error", e.toString());
    } finally {
      Get.offAllNamed(Routes.WELCOME);
    }
  }
}
