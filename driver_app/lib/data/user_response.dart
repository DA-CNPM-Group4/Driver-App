class UserResponse {
  String? createdTime;
  Destination? destination;
  int? discountId;
  DistanceAndTime? distanceAndTime;
  String? note;
  Destination? startAddress;
  User? user;
  VehicleAndPrice? vehicleAndPrice;

  UserResponse(
      {this.createdTime,
        this.destination,
        this.discountId,
        this.distanceAndTime,
        this.note,
        this.startAddress,
        this.user,
        this.vehicleAndPrice});

  UserResponse.fromJson(Map<dynamic, dynamic> json) {
    createdTime = json['createdTime'];
    destination = json['destination'] != null
        ? Destination.fromJson(json['destination'])
        : null;
    discountId = json['discountId'];
    distanceAndTime = json['distanceAndTime'] != null
        ? DistanceAndTime.fromJson(json['distanceAndTime'])
        : null;
    note = json['note'];
    startAddress = json['startAddress'] != null
        ? Destination.fromJson(json['startAddress'])
        : null;
    user = json['userInfor'] != null ? User.fromJson(json['userInfor']) : null;
    vehicleAndPrice = json['vehicleAndPrice'] != null
        ? VehicleAndPrice.fromJson(json['vehicleAndPrice'])
        : null;
  }

  Map<dynamic,dynamic> toJson() {
    final Map<dynamic,dynamic> data = Map<dynamic,dynamic>();
    data['createdTime'] = this.createdTime;
    if (this.destination != null) {
      data['destination'] = this.destination!.toJson();
    }
    data['discountId'] = this.discountId;
    if (this.distanceAndTime != null) {
      data['distanceAndTime'] = this.distanceAndTime!.toJson();
    }
    data['note'] = this.note;
    if (this.startAddress != null) {
      data['startAddress'] = this.startAddress!.toJson();
    }
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if (this.vehicleAndPrice != null) {
      data['vehicleAndPrice'] = this.vehicleAndPrice!.toJson();
    }
    return data;
  }
}

class Destination {
  String? address;
  double? latitude;
  double? longitude;

  Destination({this.address, this.latitude, this.longitude});

  Destination.fromJson(Map<dynamic,dynamic> json) {
    address = json['address'];
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<dynamic,dynamic> toJson() {
    final Map<dynamic,dynamic> data = new Map<dynamic,dynamic>();
    data['address'] = this.address;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    return data;
  }
}

class DistanceAndTime {
  dynamic distance;
  int? timeSecond;

  DistanceAndTime({this.distance, this.timeSecond});

  DistanceAndTime.fromJson(Map<dynamic,dynamic> json) {
    distance = json['distance'];
    timeSecond = json['timeSecond'];
  }

  Map<dynamic,dynamic> toJson() {
    final Map<dynamic,dynamic> data = new Map<dynamic,dynamic>();
    data['distance'] = this.distance;
    data['timeSecond'] = this.timeSecond;
    return data;
  }
}

class User {
  String? email;
  String? fullName;
  dynamic gender;
  String? homeAddress;
  int? id;
  String? phoneNumber;

  User(
      {this.email,
        this.fullName,
        this.gender,
        this.homeAddress,
        this.id,
        this.phoneNumber});

  User.fromJson(Map<dynamic,dynamic> json) {
    email = json['email'];
    fullName = json['fullName'];
    gender = json['gender'];
    homeAddress = json['homeAddress'];
    id = json['id'];
    phoneNumber = json['phoneNumber'];
  }

  Map<dynamic,dynamic> toJson() {
    final Map<dynamic,dynamic> data = new Map<dynamic,dynamic>();
    data['email'] = this.email;
    data['fullName'] = this.fullName;
    data['gender'] = this.gender;
    data['homeAddress'] = this.homeAddress;
    data['id'] = this.id;
    data['phoneNumber'] = this.phoneNumber;
    return data;
  }
}

class VehicleAndPrice {
  int? price;
  String? vehicleType;

  VehicleAndPrice({this.price, this.vehicleType});

  VehicleAndPrice.fromJson(Map<dynamic,dynamic> json) {
    price = json['price'];
    vehicleType = json['vehicleType'];
  }

  Map<dynamic,dynamic> toJson() {
    final Map<dynamic,dynamic> data = Map<dynamic,dynamic>();
    data['price'] = price;
    data['vehicleType'] = vehicleType;
    return data;
  }
}