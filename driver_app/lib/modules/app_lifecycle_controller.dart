import 'package:get/get.dart';

class LifeCycleController extends SuperController {
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
}
