import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/location_entity.dart';

abstract class LocationRepository {
  Future<Either<Failure, LocationEntity>> getCurrentLocation();
  Future<Either<Failure, List<LocationEntity>>> searchLocation(String query);
  Future<Either<Failure, LocationEntity>> getSavedLocation();
  Future<void> saveLocation(LocationEntity location);
}
