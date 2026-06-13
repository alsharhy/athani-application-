import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/datasources/location_local_data_source.dart';
import '../../data/datasources/location_remote_data_source.dart';
import '../../data/datasources/prayer_local_data_source.dart';
import '../../data/datasources/prayer_remote_data_source.dart';
import '../../data/repositories_impl/location_repository_impl.dart';
import '../../data/repositories_impl/prayer_repository_impl.dart';
import '../../domain/repositories/location_repository.dart';
import '../../domain/repositories/prayer_repository.dart';
import '../../domain/usecases/location_usecases.dart';
import '../../domain/usecases/prayer_usecases.dart';

// --- External ---
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});

final dioProvider = Provider<Dio>((ref) => Dio());

// --- Data Sources ---
final prayerRemoteDataSourceProvider = Provider<PrayerRemoteDataSource>((ref) {
  return PrayerRemoteDataSourceImpl(ref.read(dioProvider));
});

final prayerLocalDataSourceProvider = Provider<PrayerLocalDataSource>((ref) {
  return PrayerLocalDataSourceImpl(ref.read(sharedPreferencesProvider));
});

final locationRemoteDataSourceProvider = Provider<LocationRemoteDataSource>((ref) {
  return LocationRemoteDataSourceImpl();
});

final locationLocalDataSourceProvider = Provider<LocationLocalDataSource>((ref) {
  return LocationLocalDataSourceImpl(ref.read(sharedPreferencesProvider));
});

// --- Repositories ---
final prayerRepositoryProvider = Provider<PrayerRepository>((ref) {
  return PrayerRepositoryImpl(
    remoteDataSource: ref.read(prayerRemoteDataSourceProvider),
    localDataSource: ref.read(prayerLocalDataSourceProvider),
  );
});

final locationRepositoryProvider = Provider<LocationRepository>((ref) {
  return LocationRepositoryImpl(
    remoteDataSource: ref.read(locationRemoteDataSourceProvider),
    localDataSource: ref.read(locationLocalDataSourceProvider),
  );
});

// --- Use Cases ---
final getPrayerTimesUseCaseProvider = Provider<GetPrayerTimesUseCase>((ref) {
  return GetPrayerTimesUseCase(ref.read(prayerRepositoryProvider));
});

final getCachedPrayerTimesUseCaseProvider = Provider<GetCachedPrayerTimesUseCase>((ref) {
  return GetCachedPrayerTimesUseCase(ref.read(prayerRepositoryProvider));
});

final getCurrentLocationUseCaseProvider = Provider<GetCurrentLocationUseCase>((ref) {
  return GetCurrentLocationUseCase(ref.read(locationRepositoryProvider));
});

final searchLocationUseCaseProvider = Provider<SearchLocationUseCase>((ref) {
  return SearchLocationUseCase(ref.read(locationRepositoryProvider));
});

final getSavedLocationUseCaseProvider = Provider<GetSavedLocationUseCase>((ref) {
  return GetSavedLocationUseCase(ref.read(locationRepositoryProvider));
});

final saveLocationUseCaseProvider = Provider<SaveLocationUseCase>((ref) {
  return SaveLocationUseCase(ref.read(locationRepositoryProvider));
});
