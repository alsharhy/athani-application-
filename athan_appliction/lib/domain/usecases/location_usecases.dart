import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/location_entity.dart';
import '../repositories/location_repository.dart';

class GetCurrentLocationUseCase {
  final LocationRepository repository;

  GetCurrentLocationUseCase(this.repository);

  Future<Either<Failure, LocationEntity>> call() async {
    return await repository.getCurrentLocation();
  }
}

class SearchLocationUseCase {
  final LocationRepository repository;

  SearchLocationUseCase(this.repository);

  Future<Either<Failure, List<LocationEntity>>> call(String query) async {
    return await repository.searchLocation(query);
  }
}

class GetSavedLocationUseCase {
  final LocationRepository repository;

  GetSavedLocationUseCase(this.repository);

  Future<Either<Failure, LocationEntity>> call() async {
    return await repository.getSavedLocation();
  }
}

class SaveLocationUseCase {
  final LocationRepository repository;

  SaveLocationUseCase(this.repository);

  Future<void> call(LocationEntity location) async {
    return await repository.saveLocation(location);
  }
}
