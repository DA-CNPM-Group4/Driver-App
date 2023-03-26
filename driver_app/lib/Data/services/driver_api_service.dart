import 'package:driver_app/Data/models/local_entity/driver_entity.dart';
import 'package:driver_app/Data/models/local_entity/vehicle_entity.dart';
import 'package:driver_app/Data/services/general_api_service.dart';
import 'package:driver_app/Data/services/trip_api_service.dart';
import 'package:driver_app/core/exceptions/bussiness_exception.dart';
import 'package:driver_app/core/exceptions/unexpected_exception.dart';
import 'package:driver_app/Data/models/requests/accept_trip_request.dart';
import 'package:driver_app/Data/models/requests/create_driver_request.dart';
import 'package:driver_app/Data/models/requests/create_vehicle_request.dart';
import 'package:driver_app/Data/models/requests/login_response.dart';
import 'package:driver_app/Data/models/requests/register_driver_request.dart';
import 'package:driver_app/Data/models/requests/update_driver_request.dart';
import 'package:driver_app/Data/providers/api_provider.dart';

class DriverAPIService {
  static GeneralAPIService authApi = GeneralAPIService();
  static TripApiService tripApi = TripApiService();

  static Future<void> createDriverInfo(
      {required CreateDriverRequestBody body}) async {
    try {
      var identity = await APIHandlerImp.instance.getIdentity();
      body.AccountId = identity;

      var response = await APIHandlerImp.instance
          .post(body.toJson(), '/Info/Driver/AddInfo');
      if (response.data["status"]) {
        return;
      } else {
        return Future.error(IBussinessException(response.data['message']));
      }
    } catch (e) {
      return Future.error(UnexpectedException(
          context: "create-driver-info", debugMessage: e.toString()));
    }
  }

  static Future<void> updateDriver(
      {required UpdateDriverRequestBody body}) async {
    try {
      var identity = await APIHandlerImp.instance.getIdentity();
      body.AccountId = identity;

      var response = await APIHandlerImp.instance
          .post(body.toJson(), '/Info/Driver/UpdateInfo');
      if (response.data["status"]) {
        return;
      } else {
        return Future.error(IBussinessException(response.data['message']));
      }
    } catch (e) {
      return Future.error(UnexpectedException(
          context: "update-driver-info", debugMessage: e.toString()));
    }
  }

  static Future<DriverEntity> getDriverInfo() async {
    try {
      var identity = await APIHandlerImp.instance.getIdentity();
      var body = {'accountId': identity};
      var response = await APIHandlerImp.instance
          .post(body, '/Info/Driver/GetDriverInfoById');
      if (!response.data["status"]) {
        if (response.data['data'] == null) {
          return Future.error(IBussinessException(response.data['message']));
        }
        return DriverEntity.fromJson(response.data["data"]);
      } else {
        return Future.error(IBussinessException(response.data['message']));
      }
    } catch (e) {
      return Future.error(UnexpectedException(
          context: "get-driver-info", debugMessage: e.toString()));
    }
  }

  static Future<void> registerVehicle(
      {required CreateVehicleRequestBody body}) async {
    try {
      var identity = await APIHandlerImp.instance.getIdentity();
      body.DriverId = identity;
      body.VehicleId = identity;

      var response = await APIHandlerImp.instance
          .post(body.toJson(), '/Info/Vehicle/RegisterVehicle');
      if (response.data["status"]) {
        return;
      } else {
        return Future.error(IBussinessException(response.data['message']));
      }
    } catch (e) {
      return Future.error(UnexpectedException(
          context: "register-vehicle-api", debugMessage: e.toString()));
    }
  }

  static Future<VehicleEntity> getVehicle() async {
    try {
      var identity = await APIHandlerImp.instance.getIdentity();

      var body = {"accountId": identity};

      var response = await APIHandlerImp.instance
          .post(body, '/Info/Vehicle/GetDriverVehicle');
      if (response.data["status"]) {
        return VehicleEntity.fromJson(response.data['data']);
      } else {
        return Future.error(IBussinessException(response.data['message']));
      }
    } catch (e) {
      return Future.error(UnexpectedException(
          context: "get-vehicle", debugMessage: e.toString()));
    }
  }
}

Future<void> _storeAllIdentity(LoginResponseBody body) async {
  await APIHandlerImp.instance.storeIdentity(body.accountId);
  await APIHandlerImp.instance.storeRefreshToken(body.refreshToken);
  await APIHandlerImp.instance.storeAccessToken(body.accessToken);
}
