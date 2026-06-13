import '../../domain/entities/location_entity.dart';

class LocationModel extends LocationEntity {
  const LocationModel({
    required super.latitude,
    required super.longitude,
    super.cityName,
    super.countryName,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      latitude: json['latitude'],
      longitude: json['longitude'],
      cityName: json['cityName'],
      countryName: json['countryName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'cityName': cityName,
      'countryName': countryName,
    };
  }
}
