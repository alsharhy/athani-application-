import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../../core/errors/failures.dart';
import '../models/location_model.dart';

abstract class LocationRemoteDataSource {
  Future<LocationModel> getCurrentLocation();
  Future<List<LocationModel>> searchLocation(String query);
}

class LocationRemoteDataSourceImpl implements LocationRemoteDataSource {
  @override
  Future<LocationModel> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw const LocationFailure('خدمات الموقع غير مفعلة.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw const LocationFailure('تم رفض صلاحية الموقع.');
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      throw const LocationFailure('صلاحية الموقع مرفوضة دائماً.');
    } 

    try {
      Position position = await Geolocator.getCurrentPosition();
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      
      String? city;
      String? country;
      
      if (placemarks.isNotEmpty) {
        city = placemarks[0].locality ?? placemarks[0].subAdministrativeArea;
        country = placemarks[0].country;
      }

      return LocationModel(
        latitude: position.latitude,
        longitude: position.longitude,
        cityName: city,
        countryName: country,
      );
    } catch (e) {
      throw const LocationFailure();
    }
  }

  @override
  Future<List<LocationModel>> searchLocation(String query) async {
    try {
      List<Location> locations = await locationFromAddress(query);
      List<LocationModel> results = [];
      
      for (var loc in locations) {
        List<Placemark> placemarks = await placemarkFromCoordinates(loc.latitude, loc.longitude);
        if (placemarks.isNotEmpty) {
          results.add(LocationModel(
            latitude: loc.latitude,
            longitude: loc.longitude,
            cityName: placemarks[0].locality ?? placemarks[0].subAdministrativeArea ?? query,
            countryName: placemarks[0].country,
          ));
        }
      }
      return results;
    } catch (e) {
      throw const LocationFailure('لم يتم العثور على نتائج للبحث.');
    }
  }
}
