import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

/// خدمة الإشعارات المحلية - جدولة إشعارات الصلاة
class NotificationService {
  static final NotificationService _instance = NotificationService._();
  factory NotificationService() => _instance;
  NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;

    tz.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _plugin.initialize(
      settings,
      onDidReceiveNotificationResponse: (response) {
        // التعامل مع الضغط على الإشعار
      },
    );

    // طلب إذن Android 13+
    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    _initialized = true;
  }

  /// جدولة إشعار لصلاة محددة
  Future<void> schedulePrayerNotification({
    required int id,
    required String prayerName,
    required DateTime scheduledTime,
  }) async {
    if (scheduledTime.isBefore(DateTime.now())) return;

    final tzTime = tz.TZDateTime.from(scheduledTime, tz.local);

    const androidDetails = AndroidNotificationDetails(
      'prayer_times_channel',
      'مواقيت الصلاة',
      channelDescription: 'إشعارات أوقات الصلاة',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      icon: '@mipmap/ic_launcher',
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    await _plugin.zonedSchedule(
      id,
      'حان وقت صلاة $prayerName',
      'حان الآن موعد صلاة $prayerName',
      tzTime,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  /// جدولة إشعارات جميع الصلوات لليوم
  Future<void> scheduleAllPrayers(Map<String, String> timings) async {
    await cancelAll();

    final prayersToNotify = {
      'Fajr': 'الفجر',
      'Dhuhr': 'الظهر',
      'Asr': 'العصر',
      'Maghrib': 'المغرب',
      'Isha': 'العشاء',
    };

    int notificationId = 0;
    final now = DateTime.now();

    for (final entry in prayersToNotify.entries) {
      final timeStr = timings[entry.key];
      if (timeStr == null) continue;

      final cleaned = timeStr.replaceAll(RegExp(r'\s*\(.*\)'), '').trim();
      final parts = cleaned.split(':');
      if (parts.length != 2) continue;

      final scheduledTime = DateTime(
        now.year,
        now.month,
        now.day,
        int.parse(parts[0]),
        int.parse(parts[1]),
      );

      await schedulePrayerNotification(
        id: notificationId++,
        prayerName: entry.value,
        scheduledTime: scheduledTime,
      );
    }
  }

  /// إلغاء جميع الإشعارات المجدولة
  Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }

  /// عرض إشعار فوري (للتجربة)
  Future<void> showInstantNotification(String title, String body) async {
    const androidDetails = AndroidNotificationDetails(
      'prayer_times_channel',
      'مواقيت الصلاة',
      channelDescription: 'إشعارات أوقات الصلاة',
      importance: Importance.high,
      priority: Priority.high,
    );

    const details = NotificationDetails(android: androidDetails);
    await _plugin.show(999, title, body, details);
  }
}
