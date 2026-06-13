import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/prayer_times_entity.dart';
import '../repositories/prayer_repository.dart';

class GetPrayerTimesUseCase {
  final PrayerRepository repository;

  GetPrayerTimesUseCase(this.repository);

  Future<Either<Failure, PrayerTimesEntity>> call(double latitude, double longitude, int method) async {
    return await repository.getPrayerTimes(latitude, longitude, method);
  }
}

class GetCachedPrayerTimesUseCase {
  final PrayerRepository repository;

  GetCachedPrayerTimesUseCase(this.repository);

  Future<Either<Failure, PrayerTimesEntity>> call() async {
    return await repository.getCachedPrayerTimes();
  }
}
