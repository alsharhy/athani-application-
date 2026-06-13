import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/prayer_times_entity.dart';

abstract class PrayerRepository {
  Future<Either<Failure, PrayerTimesEntity>> getPrayerTimes(
    double latitude,
    double longitude,
    int method,
  );
  
  Future<Either<Failure, PrayerTimesEntity>> getCachedPrayerTimes();
  
  Future<void> cachePrayerTimes(PrayerTimesEntity prayerTimes);
}
