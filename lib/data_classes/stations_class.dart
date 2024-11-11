class Station {
  int stationId;
  String name;
  double latitude;
  double longitude;
  String address;
  String description;
  int imageCount;

  Station({
    required this.stationId,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.description,
    required this.imageCount,
  });

  factory Station.fromJson(Map<String, dynamic> json) {
    return Station(
      stationId: json['station_id'],
      name: json['name'],
      latitude: double.parse(json['latitiude']), // Corrected key here
      longitude: double.parse(json['longitude']),
      address: json['address'],
      description: json['description'],
      imageCount: json['imageCount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'station_id': stationId,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'description': description,
      'imageCount': imageCount,
    };
  }
}
