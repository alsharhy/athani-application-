import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../domain/entities/prayer_times_entity.dart';
import '../../domain/repositories/prayer_repository.dart';
import '../datasources/prayer_local_data_source.dart';
import '../datasources/prayer_remote_data_source.dart';

class PrayerRepositoryImpl implements PrayerRepository {
  final PrayerRemoteDataSource remoteDataSource;
  final PrayerLocalDataSource localDataSource;

  PrayerRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<void> cachePrayerTimes(PrayerTimesEntity prayerTimes) async {
    // We expect prayerTimes to be a PrayerTimesModel here, or we convert it.
    // Assuming the architecture is simple enough to cast.
    // In a stricter clean arch, we might map entity to model here.
    try {
      await localDataSource.cachePrayerTimes(prayerTimes as dynamic);
    } catch (e) {
      // Ignore cache failure quietly or log it
    }
  }

  @override
  Future<Either<Failure, PrayerTimesEntity>> getCachedPrayerTimes() async {
    try {
      final localPrayerTimes = await localDataSource.getCachedPrayerTimes();
      return Right(localPrayerTimes);
    } catch (e) {
      return const Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, PrayerTimesEntity>> getPrayerTimes(double latitude, double longitude, int method) async {
    try {
      final remotePrayerTimes = await remoteDataSource.getPrayerTimes(latitude, longitude, method);
      await localDataSource.cachePrayerTimes(remotePrayerTimes);
      return Right(remotePrayerTimes);
    } on ServerFailure catch (e) {
      return Left(e);
    } on NetworkFailure catch (_) {
      try {
        final localPrayerTimes = await localDataSource.getCachedPrayerTimes();
        return Right(localPrayerTimes);
      } catch (e) {
        return const Left(NetworkFailure());
      }
    } catch (e) {
      return const Left(ServerFailure());
    }
  }
}
