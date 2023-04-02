import 'package:driver_app/Data/models/realtime_models/realtime_passenger.dart';
import 'package:driver_app/data/vehicle.dart';

class CommonObject {
  static const String emptyUUID = "00000000-0000-0000-0000-000000000000";
  static const String test_passenger_id =
      "5686df08-cdc0-45a0-a45a-08db257d53cf";

  static List<Vehicle> vehicles = [
    Vehicle(
        name: "Bike driver",
        type: "Motorbike",
        description: "Get orders for ride, food, and send.",
        img: "assets/icons/bike.png"),
    Vehicle(
        name: "Car4S",
        type: "Car4S",
        description: "Get orders for Cars4S",
        img: "assets/icons/car.png"),
    Vehicle(
        name: "Car7S",
        type: "Car7S",
        description: "Get orders for Cars7S",
        img: "assets/icons/car.png"),
  ];

  static RealtimePassengerInfo callcenterPassenger =
      RealtimePassengerInfo(name: "Outside User", phone: "xxxxxxxxxx");
}
