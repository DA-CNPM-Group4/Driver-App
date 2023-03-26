import 'package:driver_app/Data/models/local_entity/driver_entity.dart';
import 'package:driver_app/Data/models/local_entity/vehicle_entity.dart';
import 'package:driver_app/Data/models/realtime_models/realtime_driver.dart';
import 'package:driver_app/Data/services/driver_api_service.dart';
import 'package:driver_app/core/utils/widgets.dart';
import 'package:driver_app/routes/app_routes.dart';
import 'package:get/get.dart';

class LifeCycleController extends SuperController {
  DriverEntity? _driver;
  VehicleEntity? _vehicle;

  // born because of special problem from user page -> edit profile
  late final _rxDriver = Rxn<DriverEntity>();
  late final _rxVehicle = Rxn<VehicleEntity>();
  //////////////////////////////////////////////

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
    _resetState(isCallAPI: true);
    try {
      await DriverAPIService.authApi.logout();
    } catch (e) {
      showSnackBar("Error", e.toString());
    } finally {
      Get.offAllNamed(Routes.WELCOME);
    }
  }

  Future<DriverEntity> get getDriver async {
    try {
      _driver ??= await DriverAPIService.getDriverInfo();
      return _driver!;
    } catch (e) {
      showSnackBar("Error", e.toString());
      _resetState();
    }
    // never happen
    return _driver!;
  }

  Future<Rxn<DriverEntity>> get getRXDriver async {
    try {
      _rxDriver.value ??= await getDriver;
      return _rxDriver;
    } catch (e) {
      showSnackBar("Error", e.toString());
      _resetState();
    }
    return _rxDriver;
  }

  set setDriver(DriverEntity driverEntity) {
    _driver = driverEntity;
    _rxDriver.value = _driver;
  }

  Future<VehicleEntity> get getVehicle async {
    try {
      _vehicle ??= await DriverAPIService.getVehicle();
      return _vehicle!;
    } catch (e) {
      showSnackBar("Error", e.toString());
      _resetState();
    }
    // never happen
    return _vehicle!;
  }

  Future<Rxn<VehicleEntity>> get getRXVehicle async {
    try {
      _rxVehicle.value ??= await getVehicle;
      return _rxVehicle;
    } catch (e) {
      showSnackBar("Error", e.toString());
      _resetState();
    }
    return _rxVehicle;
  }

  set setVehicle(VehicleEntity vehicleEntity) {
    _vehicle = vehicleEntity;
    _rxVehicle.value = _vehicle;
  }

  void _resetState({bool isCallAPI = false}) {
    phone = "";
    email = "";
    _driver = null;
    _vehicle = null;
    if (!isCallAPI) {
      Get.offAllNamed(Routes.WELCOME);
    }
  }
}
