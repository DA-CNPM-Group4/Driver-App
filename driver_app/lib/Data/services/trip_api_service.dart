import 'package:driver_app/Data/models/realtime_models/trip_request.dart';
import 'package:driver_app/Data/models/requests/accept_trip_request.dart';
import 'package:driver_app/Data/models/requests/trip_response.dart';
import 'package:driver_app/Data/providers/api_provider.dart';
import 'package:driver_app/core/exceptions/unexpected_exception.dart';

class TripApiService {
  Future<String> acceptTripRequest(AcceptTripRequestBody body) async {
    try {
      var identity = await APIHandlerImp.instance.getIdentity();
      body.driverId = body.driverId ?? identity;
      var response = await APIHandlerImp.instance
          .post(body.toJson(), '/Trip/Trip/AcceptRequest');
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

  Future<String> cancelTrip(String tripId) async {
    try {
      var query = {'tripId': tripId};

      var response = await APIHandlerImp.instance
          .post(null, '/Trip/Trip/CancelTrip', query: query);
      if (response.data["status"]) {
        return response.data['data'];
      } else {
        return Future.error(response.data['message']);
      }
    } catch (e) {
      return Future.error(UnexpectedException(
          context: "cancel-trip", debugMessage: e.toString()));
    }
  }

  Future<void> pickPassenger(String tripId) async {
    try {
      var query = {'tripId': tripId};
      var response = await APIHandlerImp.instance
          .post(null, '/Trip/Trip/PickedPassenger', query: query);
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

  Future<String> completeTrip(String tripId) async {
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

  Future<TripResponse> getTrip(String tripId) async {
    try {
      var query = {'tripId': tripId};
      var response = await APIHandlerImp.instance
          .get('/Trip/Trip/GetCurrentTrip', query: query);
      if (response.data["status"]) {
        return TripResponse.fromJson(response.data['data']);
      } else {
        return Future.error(response.data['message']);
      }
    } catch (e) {
      return Future.error(UnexpectedException(
          context: "get-trip-info", debugMessage: e.toString()));
    }
  }

  Future<List<TripResponse>> getDriverTrips() async {
    try {
      var driverId = await APIHandlerImp.instance.getIdentity();
      var query = {'driverId': driverId};

      var response = await APIHandlerImp.instance
          .get('/Trip/Trip/GetDriverTrips', query: query);
      if (response.data["status"]) {
        var listTripJson = response.data['data'] as List;
        return listTripJson
            .map((tripJson) => TripResponse.fromJson(tripJson))
            .toList();
      } else {
        return Future.error(response.data['message']);
      }
    } catch (e) {
      return Future.error(UnexpectedException(
          context: "get-trip-info", debugMessage: e.toString()));
    }
  }
}
