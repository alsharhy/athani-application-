import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../domain/entities/location_entity.dart';
import '../../domain/repositories/location_repository.dart';
import '../datasources/location_local_data_source.dart';
import '../datasources/location_remote_data_source.dart';

class LocationRepositoryImpl implements LocationRepository {
  final LocationRemoteDataSource remoteDataSource;
  final LocationLocalDataSource localDataSource;

  LocationRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, LocationEntity>> getCurrentLocation() async {
    try {
      final location = await remoteDataSource.getCurrentLocation();
      await localDataSource.saveLocation(location);
      return Right(location);
    } on LocationFailure catch (e) {
      return Left(e);
    } catch (e) {
      return const Left(LocationFailure());
    }
  }

  @override
  Future<Either<Failure, LocationEntity>> getSavedLocation() async {
    try {
      final location = await localDataSource.getSavedLocation();
      return Right(location);
    } catch (e) {
      return const Left(CacheFailure());
    }
  }

  @override
  Future<void> saveLocation(LocationEntity location) async {
    try {
      await localDataSource.saveLocation(location as dynamic);
    } catch (e) {
      // Ignore cache fail
    }
  }

  @override
  Future<Either<Failure, List<LocationEntity>>> searchLocation(String query) async {
    try {
      final locations = await remoteDataSource.searchLocation(query);
      return Right(locations);
    } on LocationFailure catch (e) {
      return Left(e);
    } catch (e) {
      return const Left(LocationFailure());
    }
  }
}
