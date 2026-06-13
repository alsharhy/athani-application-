import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/location_entity.dart';
import 'di_provider.dart';

final locationProvider = StateNotifierProvider<LocationNotifier, AsyncValue<LocationEntity?>>((ref) {
  return LocationNotifier(ref);
});

class LocationNotifier extends StateNotifier<AsyncValue<LocationEntity?>> {
  final Ref ref;

  LocationNotifier(this.ref) : super(const AsyncValue.loading()) {
    _initLocation();
  }

  Future<void> _initLocation() async {
    final getSaved = ref.read(getSavedLocationUseCaseProvider);
    final result = await getSaved();
    
    result.fold(
      (failure) async {
        // No saved location, try getting current location
        await getCurrentLocation();
      },
      (location) {
        state = AsyncValue.data(location);
      }
    );
  }

  Future<void> getCurrentLocation() async {
    state = const AsyncValue.loading();
    final getLoc = ref.read(getCurrentLocationUseCaseProvider);
    final result = await getLoc();
    
    result.fold(
      (failure) {
        state = AsyncValue.error(failure.message, StackTrace.current);
      },
      (location) {
        state = AsyncValue.data(location);
      }
    );
  }

  Future<void> setLocation(LocationEntity location) async {
    state = const AsyncValue.loading();
    final saveLoc = ref.read(saveLocationUseCaseProvider);
    await saveLoc(location);
    state = AsyncValue.data(location);
  }

  Future<List<LocationEntity>> searchLocations(String query) async {
    final searchLoc = ref.read(searchLocationUseCaseProvider);
    final result = await searchLoc(query);
    return result.fold(
      (failure) => [],
      (locations) => locations,
    );
  }
}
