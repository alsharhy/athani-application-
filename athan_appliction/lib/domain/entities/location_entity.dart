import 'package:equatable/equatable.dart';

class LocationEntity extends Equatable {
  final double latitude;
  final double longitude;
  final String? cityName;
  final String? countryName;

  const LocationEntity({
    required this.latitude,
    required this.longitude,
    this.cityName,
    this.countryName,
  });

  @override
  List<Object?> get props => [latitude, longitude, cityName, countryName];
}
