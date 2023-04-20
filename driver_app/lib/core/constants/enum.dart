import 'package:flutter/material.dart';

enum ComunicationMode {
  ClientDoLogic("1"),
  BackDoLogic("2");

  const ComunicationMode(this.value);
  final String value;
}

enum TripStatus {
  CanceledByDriver("Canceled By Driver", Colors.red),
  CanceledByPassenger("Canceled By Passenger", Colors.red),
  Finished("Finished", Colors.green),
  PickingUpCus("Pickup Passenger", Colors.orange),
  OnTheWay("On The Way", Colors.lightGreen);

  const TripStatus(this.value, this.color);
  final String value;
  final Color color;

  static TripStatus fromString(String actualValue) {
    return TripStatus.values
        .firstWhere((e) => e.toString() == 'TripStatus.$actualValue');
  }
}
