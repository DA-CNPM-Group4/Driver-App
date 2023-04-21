import 'package:driver_app/Data/models/local_entity/driver_entity.dart';
import 'package:driver_app/Data/models/local_entity/vehicle_entity.dart';
import 'package:driver_app/Data/models/realtime_models/realtime_driver.dart';
import 'package:driver_app/Data/models/realtime_models/trip_request.dart';
import 'package:driver_app/Data/models/requests/create_driver_request.dart';
import 'package:driver_app/Data/models/requests/register_driver_request.dart';
import 'package:driver_app/Data/models/requests/register_driver_request_2.dart';
import 'package:driver_app/Data/services/driver_api_service.dart';
import 'package:driver_app/modules/utils_widget/widgets.dart';
import 'package:driver_app/routes/app_routes.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class LifeCycleController extends SuperController {
  DriverEntity? _driver;
  VehicleEntity? _vehicle;

  // born because of special problem from user page -> edit profile
  late final _rxDriver = Rxn<DriverEntity>();
  late final _rxVehicle = Rxn<VehicleEntity>();
  //////////////////////////////////////////////
  late RealtimeDriver realtimeDriver;
  RealtimeTripRequest? currentTripRequest;
  String? requestId;
  String? tripId;

  // only use before signed in app
  LoginRegisterState preLoginedState = LoginRegisterState();

  bool isloginByGoogle = false;

  // todo: refactor to enum
  bool isActiveOTP = true;

  // currently not use
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

  Future<void> logout() async {
    EasyLoading.show(status: 'Logout...');
    _resetState(isCallAPI: true);
    try {
      await DriverAPIService.authApi.logout();
    } catch (e) {
      showSnackBar("Error", e.toString());
    } finally {
      EasyLoading.dismiss();
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
    preLoginedState.reset();
    _driver = null;
    _vehicle = null;
    _rxDriver.value = null;
    _rxVehicle.value = null;
    resetDrivingState();
    if (!isCallAPI) {
      Get.offAllNamed(Routes.WELCOME);
    }
  }

  void resetDrivingState() {
    tripId = null;
    requestId = null;
    currentTripRequest = null;
  }
}

class LoginRegisterState {
  String phone = "";
  String email = "";
  String address = "";
  String name = "";
  String identityNumber = "";
  bool gender = false;

  void setField({
    String? phone,
    String? email,
    String? address,
    String? name,
    String? identityNumber,
    bool? gender,
  }) {
    this.phone = phone ?? this.phone;
    this.email = email ?? this.email;
    this.address = address ?? this.address;
    this.name = name ?? this.name;
    this.identityNumber = identityNumber ?? this.identityNumber;
    this.gender = gender ?? this.gender;
  }

  CreateDriverRequestBody toCreateDriverRequestBody() {
    return CreateDriverRequestBody(
      Address: address,
      AverageRate: 0,
      NumberOfRate: 0,
      NumberOfTrip: 0,
      Email: email,
      Gender: gender,
      IdentityNumber: identityNumber,
      Name: name,
      Phone: phone,
    );
  }

  RegisterDriverRequestBody toRegisterRequestBodyV1(String password) {
    return RegisterDriverRequestBody(
        email: email, phone: phone, password: password, name: name);
  }

  RegisterDriverRequestBodyV2 toRegisterRequestBodyV2(String password) {
    return RegisterDriverRequestBodyV2(
        email: email,
        phone: phone,
        password: password,
        name: name,
        address: address,
        gender: gender,
        identityNumber: identityNumber);
  }

  void reset() {
    phone = "";
    email = "";
    address = "";
    name = "";
    identityNumber = "";
  }
}
