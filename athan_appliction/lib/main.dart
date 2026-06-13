import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/services/notification_service.dart';
import 'core/theme/app_theme.dart';
import 'presentation/providers/di_provider.dart';
import 'presentation/providers/settings_provider.dart';
import 'presentation/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // تهيئة التنسيق المحلي للتواريخ العربية
  await initializeDateFormatting('ar', null);

  // تهيئة SharedPreferences
  final sharedPrefs = await SharedPreferences.getInstance();

  // تهيئة خدمة الإشعارات
  await NotificationService().initialize();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPrefs),
      ],
      child: const PrayerTimesApp(),
    ),
  );
}

/// التطبيق الرئيسي
class PrayerTimesApp extends ConsumerWidget {
  const PrayerTimesApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return MaterialApp(
      title: 'مواقيت الصلاة',
      debugShowCheckedModeBanner: false,
      // اتجاه النص من اليمين لليسار
      locale: const Locale('ar', 'SA'),
      // ثيم ديناميكي
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: settings.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child!,
        );
      },
      home: const SplashScreen(),
    );
  }
}
