import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/prayer_times_entity.dart';
import 'di_provider.dart';
import 'location_provider.dart';
import 'settings_provider.dart';

final prayerTimesProvider = StateNotifierProvider<PrayerTimesNotifier, AsyncValue<PrayerTimesEntity?>>((ref) {
  return PrayerTimesNotifier(ref);
});

class PrayerTimesNotifier extends StateNotifier<AsyncValue<PrayerTimesEntity?>> {
  final Ref ref;

  PrayerTimesNotifier(this.ref) : super(const AsyncValue.loading()) {
    // Listen to location changes
    ref.listen(locationProvider, (previous, next) {
      if (next is AsyncData && next.value != null) {
        fetchPrayerTimes();
      }
    });

    // Listen to settings changes (calculation method)
    ref.listen(settingsProvider, (previous, next) {
      if (previous?.calculationMethod != next.calculationMethod) {
        fetchPrayerTimes();
      }
    });
  }

  Future<void> fetchPrayerTimes() async {
    final locationState = ref.read(locationProvider);
    final settingsState = ref.read(settingsProvider);

    if (locationState is! AsyncData || locationState.value == null) {
      return;
    }

    state = const AsyncValue.loading();
    final location = locationState.value!;
    
    final getPrayerTimes = ref.read(getPrayerTimesUseCaseProvider);
    final result = await getPrayerTimes(
      location.latitude,
      location.longitude,
      settingsState.calculationMethod,
    );

    result.fold(
      (failure) {
        state = AsyncValue.error(failure.message, StackTrace.current);
      },
      (prayerTimes) {
        state = AsyncValue.data(prayerTimes);
      }
    );
  }
}
