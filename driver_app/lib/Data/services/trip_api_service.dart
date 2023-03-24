import 'package:driver_app/Data/models/requests/accept_trip_request.dart';
import 'package:driver_app/Data/providers/api_provider.dart';
import 'package:driver_app/core/exceptions/unexpected_exception.dart';

class TripApiService {
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

  static Future<String> cancelTrip(String tripId) async {
    try {
      var query = {'tripId': tripId};

      var response = await APIHandlerImp.instance
          .get('/Trip/Trip/CancelTrip', query: query);
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

  //  TODO: HANDLE RESPONSE
  static Future<String> getDriverTrip(String tripId) async {
    try {
      var query = {'tripId': tripId};
      var response = await APIHandlerImp.instance
          .get('/Trip/Trip/GetCurrentTrip', query: query);
      if (response.data["status"]) {
        return response.data['data'];
      } else {
        return Future.error(response.data['message']);
      }
    } catch (e) {
      return Future.error(UnexpectedException(
          context: "get-trip-info", debugMessage: e.toString()));
    }
  }

  //  TODO: HANDLE RESPONSE
  static Future<String> getDriverTrips() async {
    try {
      var driverId = await APIHandlerImp.instance.getIdentity();
      var query = {'driverId': driverId};

      var response = await APIHandlerImp.instance
          .get('/Trip/Trip/GetDriverTrips', query: query);
      if (response.data["status"]) {
        return response.data['data'];
      } else {
        return Future.error(response.data['message']);
      }
    } catch (e) {
      return Future.error(UnexpectedException(
          context: "get-trip-info", debugMessage: e.toString()));
    }
  }
}
