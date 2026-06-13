import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';

import '../../core/constants/app_constants.dart';
import '../providers/location_provider.dart';
import '../providers/prayer_times_provider.dart';
import '../providers/settings_provider.dart';
import '../widgets/prayer_card.dart';
import '../widgets/next_prayer_banner.dart';
import 'location_search_screen.dart';
import 'settings_screen.dart';

/// الصفحة الرئيسية - تعرض مواقيت الصلاة والعداد التنازلي
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  Timer? _timer;
  DateTime _now = DateTime.now();

  // ترتيب الصلوات الستة
  final List<String> _prayerOrder = [
    'Fajr',
    'Sunrise',
    'Dhuhr',
    'Asr',
    'Maghrib',
    'Isha',
  ];

  // أيقونات الصلوات
  final Map<String, IconData> _prayerIcons = {
    'Fajr': Icons.brightness_3_rounded,
    'Sunrise': Icons.wb_sunny_outlined,
    'Dhuhr': Icons.wb_sunny_rounded,
    'Asr': Icons.sunny_snowing,
    'Maghrib': Icons.nights_stay_rounded,
    'Isha': Icons.dark_mode_rounded,
  };

  @override
  void initState() {
    super.initState();
    // تحديث الساعة كل ثانية
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {
          _now = DateTime.now();
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  /// يعثر على الصلاة القادمة بناءً على الوقت الحالي
  MapEntry<String, Duration>? _getNextPrayer(Map<String, String> timings) {
    for (final key in _prayerOrder) {
      final timeStr = timings[key];
      if (timeStr == null) continue;

      final prayerTime = _parseTimeToday(timeStr);
      if (prayerTime.isAfter(_now)) {
        return MapEntry(key, prayerTime.difference(_now));
      }
    }
    // إذا فات وقت العشاء، القادمة هي فجر الغد
    final fajrStr = timings['Fajr'];
    if (fajrStr != null) {
      final fajrTomorrow =
          _parseTimeToday(fajrStr).add(const Duration(days: 1));
      return MapEntry('Fajr', fajrTomorrow.difference(_now));
    }
    return null;
  }

  /// يحدد الصلاة الحالية (التي نحن في وقتها)
  String? _getCurrentPrayer(Map<String, String> timings) {
    String? current;
    for (final key in _prayerOrder) {
      final timeStr = timings[key];
      if (timeStr == null) continue;
      final prayerTime = _parseTimeToday(timeStr);
      if (_now.isAfter(prayerTime) || _now.isAtSameMomentAs(prayerTime)) {
        current = key;
      }
    }
    return current;
  }

  DateTime _parseTimeToday(String timeStr) {
    // الصيغة المتوقعة "14:30" أو "14:30 (EET)"
    final cleaned = timeStr.replaceAll(RegExp(r'\s*\(.*\)'), '').trim();
    final parts = cleaned.split(':');
    return DateTime(
      _now.year,
      _now.month,
      _now.day,
      int.parse(parts[0]),
      int.parse(parts[1]),
    );
  }

  String _formatTime(String rawTime, bool is24) {
    final cleaned = rawTime.replaceAll(RegExp(r'\s*\(.*\)'), '').trim();
    final parts = cleaned.split(':');
    final h = int.parse(parts[0]);
    final m = int.parse(parts[1]);
    if (is24) {
      return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}';
    }
    final period = h >= 12 ? 'م' : 'ص';
    final h12 = h == 0
        ? 12
        : h > 12
            ? h - 12
            : h;
    return '$h12:${m.toString().padLeft(2, '0')} $period';
  }

  @override
  Widget build(BuildContext context) {
    final locationState = ref.watch(locationProvider);
    final prayerState = ref.watch(prayerTimesProvider);
    final settings = ref.watch(settingsProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(locationProvider.notifier).getCurrentLocation();
          await ref.read(prayerTimesProvider.notifier).fetchPrayerTimes();
        },
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            // --- AppBar مع التدرج ---
            SliverAppBar(
              expandedHeight: 280,
              pinned: true,
              stretch: true,
              backgroundColor: colorScheme.primary,
              actions: [
                IconButton(
                  icon: const Icon(Icons.search_rounded),
                  tooltip: 'تغيير المدينة',
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const LocationSearchScreen(),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.settings_rounded),
                  tooltip: 'الإعدادات',
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const SettingsScreen(),
                      ),
                    );
                  },
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        colorScheme.primary,
                        colorScheme.primary.withValues(alpha: 0.85),
                        colorScheme.primaryContainer.withValues(alpha: 0.5),
                      ],
                    ),
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 10),
                          // اسم المدينة
                          locationState.when(
                            data: (loc) => Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.location_on_rounded,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  loc?.cityName ?? 'غير محدد',
                                  style: GoogleFonts.cairo(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                if (loc?.countryName != null) ...[
                                  Text(
                                    ' - ${loc!.countryName}',
                                    style: GoogleFonts.cairo(
                                      fontSize: 14,
                                      color:
                                          Colors.white.withValues(alpha: 0.8),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            loading: () => Text(
                              'جارٍ تحديد الموقع...',
                              style: GoogleFonts.cairo(
                                color: Colors.white70,
                                fontSize: 16,
                              ),
                            ),
                            error: (e, _) => GestureDetector(
                              onTap: () => ref
                                  .read(locationProvider.notifier)
                                  .getCurrentLocation(),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.error_outline,
                                      color: Colors.white70, size: 18),
                                  const SizedBox(width: 6),
                                  Text(
                                    'اضغط لتحديد الموقع',
                                    style: GoogleFonts.cairo(
                                      color: Colors.white70,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          // التاريخ الهجري
                          Text(
                            _getHijriDate(),
                            style: GoogleFonts.cairo(
                              fontSize: 16,
                              color: Colors.white.withValues(alpha: 0.9),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          // التاريخ الميلادي
                          Text(
                            _getGregorianDate(),
                            style: GoogleFonts.cairo(
                              fontSize: 13,
                              color: Colors.white.withValues(alpha: 0.7),
                            ),
                          ),
                          const SizedBox(height: 16),
                          // شريط الصلاة القادمة والعداد التنازلي
                          prayerState.when(
                            data: (pt) {
                              if (pt == null) return const SizedBox.shrink();
                              final next = _getNextPrayer(pt.timings);
                              if (next == null) return const SizedBox.shrink();
                              return NextPrayerBanner(
                                prayerName:
                                    AppConstants.prayerNamesArabic[next.key] ??
                                        next.key,
                                remaining: next.value,
                                icon: _prayerIcons[next.key] ??
                                    Icons.access_time,
                              );
                            },
                            loading: () => const SizedBox.shrink(),
                            error: (_, __) => const SizedBox.shrink(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // --- محتوى بطاقات الصلاة ---
            prayerState.when(
              data: (pt) {
                if (pt == null) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.mosque_rounded,
                              size: 60,
                              color: colorScheme.primary.withValues(alpha: 0.4)),
                          const SizedBox(height: 16),
                          Text(
                            'لم يتم تحميل المواقيت',
                            style: GoogleFonts.cairo(
                              fontSize: 16,
                              color: colorScheme.onSurface.withValues(alpha: 0.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                final currentPrayer = _getCurrentPrayer(pt.timings);
                final nextPrayerEntry = _getNextPrayer(pt.timings);
                final nextPrayerKey = nextPrayerEntry?.key;

                return SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final key = _prayerOrder[index];
                        final timeRaw = pt.timings[key] ?? '--:--';
                        final displayTime =
                            _formatTime(timeRaw, settings.is24HourFormat);
                        final isCurrent = currentPrayer == key;
                        final isNext = nextPrayerKey == key;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: PrayerCard(
                            prayerNameAr:
                                AppConstants.prayerNamesArabic[key] ?? key,
                            time: displayTime,
                            icon: _prayerIcons[key] ?? Icons.access_time,
                            isCurrent: isCurrent,
                            isNext: isNext,
                          ),
                        );
                      },
                      childCount: _prayerOrder.length,
                    ),
                  ),
                );
              },
              loading: () => const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, _) => SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.cloud_off_rounded,
                          size: 60,
                          color: colorScheme.error.withValues(alpha: 0.6)),
                      const SizedBox(height: 16),
                      Text(
                        e.toString(),
                        style: GoogleFonts.cairo(
                          fontSize: 14,
                          color: colorScheme.error,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      FilledButton.icon(
                        onPressed: () => ref
                            .read(prayerTimesProvider.notifier)
                            .fetchPrayerTimes(),
                        icon: const Icon(Icons.refresh_rounded),
                        label: Text('إعادة المحاولة',
                            style: GoogleFonts.cairo()),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getHijriDate() {
    try {
      final hijri = HijriCalendar.now();
      return '${hijri.hDay} ${hijri.longMonthName} ${hijri.hYear} هـ';
    } catch (_) {
      return '';
    }
  }

  String _getGregorianDate() {
    return DateFormat('EEEE d MMMM yyyy', 'ar').format(DateTime.now());
  }
}
