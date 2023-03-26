import 'package:driver_app/data/vehicle.dart';

class CommonObject {
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
}