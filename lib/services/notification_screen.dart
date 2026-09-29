import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;

class NotificationService {
  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  // Dipanggil sekali saat aplikasi pertama kali dibuka,
  // menyiapkan "mesin" notifikasi supaya siap dipakai
  Future<void> init() async {
    // Menyiapkan database zona waktu (dibutuhkan untuk penjadwalan)
    tz_data.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidSettings);

    await _notifications.initialize(initSettings);

    // Minta izin notifikasi ke user (wajib di Android 13+)
    await _notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    await _notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestExactAlarmsPermission();
  }

  // Menjadwalkan notifikasi harian yang berulang tiap hari di jam yang sama
  Future<void> scheduleDailyNotification({
    required int id, // ID unik untuk tiap jenis pengingat
    required String title,
    required String body,
    required int hour,
    required int minute,
  }) async {
    await _notifications.zonedSchedule(
      id,
      title,
      body,
      _nextInstanceOfTime(hour, minute),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_reminder_channel', // ID channel
          'Pengingat Harian', // Nama channel yang terlihat di settings HP
          channelDescription: 'Pengingat olahraga dan makan harian',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time, // ulang tiap hari di jam yang sama
    );
  }

  // Menghitung waktu terdekat untuk jam:menit yang diminta
  // Kalau jam segitu di hari ini sudah lewat, otomatis dijadwalkan besok
  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    return scheduledDate;
  }

  // Untuk membatalkan satu jadwal notifikasi tertentu
  Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
  }
}