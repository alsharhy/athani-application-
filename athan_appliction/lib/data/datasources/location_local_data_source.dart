import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_constants.dart';
import '../../core/errors/failures.dart';
import '../models/location_model.dart';

abstract class LocationLocalDataSource {
  Future<LocationModel> getSavedLocation();
  Future<void> saveLocation(LocationModel location);
}

class LocationLocalDataSourceImpl implements LocationLocalDataSource {
  final SharedPreferences sharedPreferences;

  LocationLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<LocationModel> getSavedLocation() async {
    final jsonString = sharedPreferences.getString(AppConstants.selectedCityKey);
    if (jsonString != null) {
      return LocationModel.fromJson(json.decode(jsonString));
    } else {
      throw const CacheFailure();
    }
  }

  @override
  Future<void> saveLocation(LocationModel location) async {
    final jsonString = json.encode(location.toJson());
    await sharedPreferences.setString(AppConstants.selectedCityKey, jsonString);
  }
}
