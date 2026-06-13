import 'package:intl/intl.dart';
import 'package:hijri/hijri_calendar.dart';

class AppDateUtils {
  static String formatTimeTo12Hour(String time24) {
    // time24 is usually "15:30"
    final parts = time24.split(':');
    if (parts.length != 2) return time24;
    
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    
    final dateTime = DateTime(2020, 1, 1, hour, minute);
    return DateFormat('h:mm a', 'ar').format(dateTime);
  }

  static String getHijriDate() {
    var today = HijriCalendar.now();
    return today.toFormat("dd MMMM yyyy");
  }

  static String getGregorianDate() {
    var now = DateTime.now();
    return DateFormat('d MMMM yyyy', 'ar').format(now);
  }

  static DateTime parseTime(String timeStr) {
    // timeStr is usually like "14:30"
    final now = DateTime.now();
    final parts = timeStr.split(':');
    if (parts.length != 2) return now;

    return DateTime(
      now.year,
      now.month,
      now.day,
      int.parse(parts[0]),
      int.parse(parts[1]),
    );
  }
}
