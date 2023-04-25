import 'package:driver_app/Data/models/requests/accept_trip_request.dart';
import 'package:driver_app/Data/models/requests/get_completed_trip_response.dart';
import 'package:driver_app/Data/models/requests/get_income_request.dart';
import 'package:driver_app/Data/models/requests/trip_feedback_response.dart';
import 'package:driver_app/Data/models/requests/trip_response.dart';
import 'package:driver_app/Data/providers/api_provider.dart';
import 'package:driver_app/core/exceptions/bussiness_exception.dart';
import 'package:driver_app/core/exceptions/unexpected_exception.dart';
import 'package:driver_app/core/utils/utils.dart';
import 'package:flutter/material.dart';

class TripApiService {
  Future<String> acceptTripRequest(AcceptTripRequestBody body) async {
    try {
      var identity = await APIHandlerImp.instance.getIdentity();
      body.driverId = body.driverId ?? identity;
      var response = await APIHandlerImp.instance
          .post(body.toJson(), '/Trip/Trip/AcceptRequest', useToken: true);
      if (response.data["status"]) {
        return response.data['data'];
      } else {
        return Future.error(const IBussinessException(
            "Passenger have canceled or You are Late"));
      }
    } catch (e) {
      return Future.error(UnexpectedException(
          context: "accept-trip", debugMessage: e.toString()));
    }
  }

  Future<void> cancelTrip(String tripId) async {
    try {
      var body = {'tripId': tripId};

      var response = await APIHandlerImp.instance.post(
        body,
        '/Trip/Trip/CancelTrip',
        useToken: true,
      );
      if (response.data["status"]) {
        return;
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
      var body = {'tripId': tripId};
      var response = await APIHandlerImp.instance.post(
        body,
        '/Trip/Trip/PickedPassenger',
        useToken: true,
      );
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

  Future<void> completeTrip(String tripId) async {
    try {
      var body = {'tripId': tripId};
      var response = await APIHandlerImp.instance.post(
        body,
        '/Trip/Trip/FinishTrip',
        useToken: true,
      );
      if (response.data["status"]) {
        // return response.data['data'];
        return;
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
      var body = {'tripId': tripId};
      var response = await APIHandlerImp.instance.get(
        '/Trip/Trip/GetCurrentTrip',
        body: body,
        useToken: true,
      );
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

  Future<TripFeedbackResponse> getTripFeedback(String tripId) async {
    try {
      var body = {'tripId': tripId};
      var response = await APIHandlerImp.instance.get(
        '/Trip/TripFeedback/GetTripFeedback',
        body: body,
        useToken: true,
      );
      if (response.data["status"]) {
        return TripFeedbackResponse.fromJson(response.data['data']);
      } else {
        return Future.error(response.data['message']);
      }
    } catch (e) {
      return Future.error(UnexpectedException(
          context: "get-trip-feedback", debugMessage: e.toString()));
    }
  }

  Future<List<TripResponse>> getDriverTrips() async {
    try {
      var driverId = await APIHandlerImp.instance.getIdentity();
      var body = {'driverId': driverId};

      var response = await APIHandlerImp.instance.get(
        '/Trip/Trip/GetDriverTrips',
        body: body,
        useToken: true,
      );
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
          context: "get-trips-info", debugMessage: e.toString()));
    }
  }

  Future<GetCompletedTripResponse> getDriverCompletedTrips(
      {required DateTime from, required DateTime to}) async {
    try {
      var driverId = await APIHandlerImp.instance.getIdentity();
      var body = {
        'driverId': driverId,
        "from": Utils.dateTimeToDate(from),
        "to": Utils.dateTimeToDate(to),
      };

      debugPrint(body.toString());
      var response = await APIHandlerImp.instance.get(
        '/Trip/Trip/GetCompletedTrips',
        body: body,
        useToken: true,
      );
      if (response.data["status"]) {
        return GetCompletedTripResponse.fromJson(response.data['data']);
      } else {
        return Future.error(response.data['message']);
      }
    } catch (e) {
      return Future.error(UnexpectedException(
          context: "get-trips-info", debugMessage: e.toString()));
    }
  }

  Future<void> cancelRequest({required String requestId}) async {
    try {
      var body = {"requestId": requestId};
      var response = await APIHandlerImp.instance.post(
        body,
        '/Trip/TripRequest/CancelRequest',
        useToken: true,
      );
      if (response.data["status"]) {
      } else {
        return Future.error(IBussinessException(response.data['message']));
      }
    } catch (e) {
      return Future.error(UnexpectedException(
          context: "cancel-trip-request", debugMessage: e.toString()));
    }
  }

  Future<int> getInComeRequest(
      {required GetIncomeRequestBody requestBody}) async {
    try {
      var driverId = await APIHandlerImp.instance.getIdentity();
      requestBody.driverId = driverId.toString();
      var response = await APIHandlerImp.instance.get(
        '/Trip/Trip/GetIncome',
        body: requestBody.toJson(),
        useToken: true,
      );

      if (response.data["status"]) {
        return response.data['data'];
      } else {
        return Future.error(IBussinessException(response.data['message']));
      }
    } catch (e) {
      return Future.error(UnexpectedException(
          context: "Trip-GetIncome", debugMessage: e.toString()));
    }
  }

  Future<List<TripResponse>> getDriverTripsPaging(
      {required int pageSize, required int pageNum}) async {
    try {
      var driverId = await APIHandlerImp.instance.getIdentity();
      var requestBody = {
        "driverId": driverId,
        "pageSize": pageSize,
        "pageNum": pageNum,
      };
      var response = await APIHandlerImp.instance.get(
        '/Trip/Trip/GetDriverTripPageing',
        body: requestBody,
        useToken: true,
      );
      if (response.data["status"]) {
        var listTripJson = response.data['data'] as List;
        return listTripJson
            .map((tripJson) => TripResponse.fromJson(tripJson))
            .toList();
      } else {
        return Future.error(IBussinessException(
          response.data['message'],
          place: "getDriverTripsPaging",
          debugMessage: response.data['message'],
        ));
      }
    } catch (e) {
      return Future.error(
        UnexpectedException(
            context: "getDriverTripsPaging", debugMessage: e.toString()),
      );
    }
  }

  Future<int> getDriverTripsTotalPage({required int pageSize}) async {
    try {
      var driverId = await APIHandlerImp.instance.getIdentity();
      var requestBody = {
        "driverId": driverId,
        "pageSize": pageSize,
      };
      var response = await APIHandlerImp.instance.get(
        '/Trip/Trip/GetDriverTripTotalPages',
        body: requestBody,
        useToken: true,
      );

      if (response.data["status"]) {
        return response.data['data'];
      } else {
        return Future.error(IBussinessException(
          response.data['message'],
          place: "getDriverTripsTotalPage",
          debugMessage: response.data['message'],
        ));
      }
    } catch (e) {
      return Future.error(UnexpectedException(
          context: "getDriverTripsTotalPage", debugMessage: e.toString()));
    }
  }
}
