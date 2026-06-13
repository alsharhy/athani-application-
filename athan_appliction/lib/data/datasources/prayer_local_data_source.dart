import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_constants.dart';
import '../../core/errors/failures.dart';
import '../models/prayer_times_model.dart';

abstract class PrayerLocalDataSource {
  Future<PrayerTimesModel> getCachedPrayerTimes();
  Future<void> cachePrayerTimes(PrayerTimesModel prayerTimes);
}

class PrayerLocalDataSourceImpl implements PrayerLocalDataSource {
  final SharedPreferences sharedPreferences;

  PrayerLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<void> cachePrayerTimes(PrayerTimesModel prayerTimes) async {
    final jsonString = json.encode(prayerTimes.toJson());
    await sharedPreferences.setString(AppConstants.cachedTimingsKey, jsonString);
  }

  @override
  Future<PrayerTimesModel> getCachedPrayerTimes() async {
    final jsonString = sharedPreferences.getString(AppConstants.cachedTimingsKey);
    if (jsonString != null) {
      return PrayerTimesModel.fromJson(json.decode(jsonString));
    } else {
      throw const CacheFailure();
    }
  }
}
