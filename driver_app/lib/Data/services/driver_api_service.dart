import 'package:driver_app/Data/exceptions/bussiness_exception.dart';
import 'package:driver_app/Data/exceptions/unexpected_exception.dart';
import 'package:driver_app/Data/models/requests/accept_trip_request.dart';
import 'package:driver_app/Data/models/requests/create_driver_request.dart';
import 'package:driver_app/Data/models/requests/create_vehicle_request.dart';
import 'package:driver_app/Data/models/requests/login_driver_request.dart';
import 'package:driver_app/Data/models/requests/login_response.dart';
import 'package:driver_app/Data/models/requests/register_driver_request.dart';
import 'package:driver_app/Data/models/requests/update_driver_request.dart';
import 'package:driver_app/Data/providers/api_provider.dart';

class DriverAPIService {
  static Future<void> login({required LoginDriverRequestBody body}) async {
    try {
      var response = await APIHandlerImp.instance
          .post(body.toJson(), '/Authentication/Login');

      if (response.data["status"]) {
        var body = LoginResponseBody.fromJson(response.data['data']);
        await _storeAllIdentity(body);
      } else {
        return Future.error(IBussinessException(response.data['message']));
      }
    } catch (e) {
      return Future.error(
          UnexpectedException(context: "login", debugMessage: e.toString()));
    }
  }

  static Future<void> register(RegisterDriverRequestBody body) async {
    try {
      var response = await APIHandlerImp.instance
          .post(body.toJson(), '/Authentication/Register');
      if (response.data["status"]) {
      } else {
        return Future.error(IBussinessException(response.data['message']));
      }
    } catch (e) {
      return Future.error(UnexpectedException(
          context: "register-account", debugMessage: e.toString()));
    }
  }

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

  static Future<CreateVehicleRequestBody> getVehicle() async {
    try {
      var identity = await APIHandlerImp.instance.getIdentity();
      var accountId = identity;

      var response = await APIHandlerImp.instance
          .post(accountId, '/Info/Vehicle/GetDriverVehicle');
      if (response.data["status"]) {
        return CreateVehicleRequestBody.fromJson(response.data['data']);
      } else {
        return Future.error(IBussinessException(response.data['message']));
      }
    } catch (e) {
      return Future.error(UnexpectedException(
          context: "get-vehicle", debugMessage: e.toString()));
    }
  }

  static Future<String> acceptTripRequest(
      AcceptTripRequestParams params) async {
    try {
      var identity = await APIHandlerImp.instance.getIdentity();
      params.driverId = params.driverId ?? identity;
      var response = await APIHandlerImp.instance
          .post(null, '/Trip/Trip/AcceptRequest', query: params.toJson());
      if (response.data["status"]) {
        return response.data['data'];
      } else {
        return Future.error(response.data['message']);
      }
    } catch (e) {
      return Future.error(UnexpectedException(
          context: "accept-trip", debugMessage: e.toString()));
    }
  }

  static Future<void> pickPassenger(String tripId) async {
    try {
      var query = {'tripId': tripId};
      var response = await APIHandlerImp.instance
          .get('/Trip/Trip/PickedPassenger', query: query);
      if (response.data["status"]) {
        return response.data['data'];
      } else {
        return Future.error(response.data['message']);
      }
    } catch (e) {
      return Future.error(UnexpectedException(
          context: "pick-passenger", debugMessage: e.toString()));
    }
  }

  static Future<String> completeTrip(String tripId) async {
    try {
      var query = {'tripId': tripId};
      var response = await APIHandlerImp.instance
          .post(null, '/Trip/Trip/FinishTrip', query: query);
      if (response.data["status"]) {
        return response.data['data'];
      } else {
        return Future.error(response.data['message']);
      }
    } catch (e) {
      return Future.error(UnexpectedException(
          context: "complete-trip", debugMessage: e.toString()));
    }
  }

  static Future<void> _storeAllIdentity(LoginResponseBody body) async {
    await APIHandlerImp.instance.storeIdentity(body.accountId);
    await APIHandlerImp.instance.storeRefreshToken(body.refreshToken);
    await APIHandlerImp.instance.storeAccessToken(body.accessToken);
  }
}
