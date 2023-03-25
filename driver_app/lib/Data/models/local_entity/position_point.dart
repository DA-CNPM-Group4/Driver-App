class PositionPoint {
  String? address;
  double? latitude;
  double? longitude;

  PositionPoint({this.address, this.latitude, this.longitude});

  PositionPoint.fromJson(Map<dynamic, dynamic> json) {
    address = json['address'];
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = <dynamic, dynamic>{};
    data['address'] = address;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    return data;
  }
}
