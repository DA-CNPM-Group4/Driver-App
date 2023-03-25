import 'package:driver_app/Data/models/local_entity/driver_entity.dart';
import 'package:get/get.dart';

class LifeCycleController extends SuperController {
  late DriverEntity driver;
  String phone = "";
  String email = "";

  RxBool isActive = false.obs;
  final RxDouble _latitud = 0.0.obs;
  final RxDouble _longitud = 0.0.obs;
  RxDouble getLatitude() => _latitud;
  RxDouble getlongitude() => _longitud;

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
}
