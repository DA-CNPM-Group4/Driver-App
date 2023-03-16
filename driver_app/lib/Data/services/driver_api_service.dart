import 'package:driver_app/Data/models/requests/accept_trip_request.dart';
import 'package:driver_app/Data/models/requests/create_driver_request.dart';
import 'package:driver_app/Data/models/requests/create_vehicle_request.dart';
import 'package:driver_app/Data/models/requests/login_driver_request.dart';
import 'package:driver_app/Data/models/requests/register_driver_request.dart';
import 'package:driver_app/Data/models/requests/update_driver_request.dart';
import 'package:driver_app/Data/providers/api_provider.dart';

class DriverAPIService {
  static Future<void> login({required LoginDriverRequestBody body}) async {
    var response = await APIHandlerImp.instance
        .post(body.toJson(), '/Authentication/Login');

    if (response.data["status"]) {
      var identity = response.data["data"]['accountId'];
      print(identity);
      await APIHandlerImp.instance.storeIdentity(identity);
    } else {
      return Future.error(response.data['message']);
    }
  }

  static Future<void> register(RegisterDriverRequestBody body) async {
    var response = await APIHandlerImp.instance
        .post(body.toJson(), '/Authentication/Register');
    if (response.data["status"]) {
      var identity = response.data["data"]['accountId'];

      await APIHandlerImp.instance.storeIdentity(identity);
    } else {
      return Future.error(response.data['message']);
    }
  }

  static Future<void> createDriver(
      {required CreateDriverRequestBody body}) async {
    var identity = await APIHandlerImp.instance.getIdentity();
    body.AccountId = identity;

    var response = await APIHandlerImp.instance
        .post(body.toJson(), '/Info/Driver/AddInfo');
    if (response.data["status"]) {
      return;
    } else {
      return Future.error(response.data['message']);
    }
  }

  static Future<void> updateDriver(
      {required UpdateDriverRequestBody body}) async {
    var identity = await APIHandlerImp.instance.getIdentity();
    body.AccountId = identity;

    var response = await APIHandlerImp.instance
        .post(body.toJson(), '/Info/Driver/UpdateInfo');
    if (response.data["status"]) {
      return;
    } else {
      return Future.error(response.data['message']);
    }
  }

  static Future<void> registerVehicle(
      {required CreateVehicleRequestBody body}) async {
    var identity = await APIHandlerImp.instance.getIdentity();
    body.DriverId = identity;
    body.VehicleId = identity;

    var response = await APIHandlerImp.instance
        .post(body.toJson(), '/Info/Vehicle/RegisterVehicle');
    if (response.data["status"]) {
      return;
    } else {
      return Future.error(response.data['message']);
    }
  }

  static Future<CreateVehicleRequestBody> getVehicle() async {
    var identity = await APIHandlerImp.instance.getIdentity();
    var AccountId = identity;

    var body = {'AccountId': AccountId};
    var response = await APIHandlerImp.instance
        .post(body, '/Info/Vehicle/GetDriverVehicle');
    if (response.data["status"]) {
      return CreateVehicleRequestBody.fromJson(response.data['data']);
    } else {
      return Future.error(response.data['message']);
    }
  }

  static Future<String> acceptTripRequest(
      AcceptTripRequestParams params) async {
    var identity = await APIHandlerImp.instance.getIdentity();
    params.driverId = params.driverId ?? identity;
    var response = await APIHandlerImp.instance
        .post(null, '/Trip/Trip/AcceptRequest', query: params.toJson());
    if (response.data["status"]) {
      return response.data['data'];
    } else {
      return Future.error(response.data['message']);
    }
  }

  static Future<String> completeTrip(String tripId) async {
    var query = {'tripId': tripId};
    var response = await APIHandlerImp.instance
        .post(null, '/Trip/Trip/FinishTrip', query: query);
    if (response.data["status"]) {
      return response.data['data'];
    } else {
      return Future.error(response.data['message']);
    }
  }
}
