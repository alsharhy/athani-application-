class AppConstants {
  static const String baseUrl = 'https://api.aladhan.com/v1/timings';
  
  // Shared Preferences Keys
  static const String cachedTimingsKey = 'CACHED_TIMINGS';
  static const String selectedCityKey = 'SELECTED_CITY';
  static const String calculationMethodKey = 'CALCULATION_METHOD';
  static const String timeFormatKey = 'TIME_FORMAT';
  static const String isDarkModeKey = 'IS_DARK_MODE';
  
  // Prayer Names Arabic
  static const Map<String, String> prayerNamesArabic = {
    'Fajr': 'الفجر',
    'Sunrise': 'الشروق',
    'Dhuhr': 'الظهر',
    'Asr': 'العصر',
    'Maghrib': 'المغرب',
    'Isha': 'العشاء',
  };
}
