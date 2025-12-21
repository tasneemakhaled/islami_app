import 'package:adhan/adhan.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:workmanager/workmanager.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:islami_app/main.dart'; // لاستيراد navigatorKey

class LocalNotifications {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static List<String> azkarList = [
    "سبحان الله وبحمده",
    "الحمد لله رب العالمين",
    "لا إله إلا الله وحده لا شريك له",
    "الله أكبر كبيراً",
    "لاحول ولا قوة إلا بالله",
    "أستغفر الله وأتوب إليه",
    "اللهم صل وسلم على نبينا محمد",
    "سبحان الله العظيم",
    "لا إله إلا أنت سبحانك إني كنت من الظالمين",
  ];

  // تعديل الـ onTap لفتح الصفحات
  static void onTap(NotificationResponse notificationResponse) {
    String? payload = notificationResponse.payload;

    if (payload == 'morning') {
      navigatorKey.currentState?.pushNamed('/morning_azkar');
    } else if (payload == 'evening') {
      navigatorKey.currentState?.pushNamed('/evening_azkar');
    }
  }

  static Future init() async {
    tz.initializeTimeZones();
    InitializationSettings settings = const InitializationSettings(
      android: AndroidInitializationSettings("@mipmap/ic_launcher"),
      iOS: DarwinInitializationSettings(),
    );

    await flutterLocalNotificationsPlugin.initialize(
      settings,
      onDidReceiveNotificationResponse: onTap,
      onDidReceiveBackgroundNotificationResponse: onTap,
    );
  }

  static void showBasicNotification() async {
    NotificationDetails notificationDetails = const NotificationDetails(
      android: AndroidNotificationDetails(
        'basic_channel',
        'Basic Notifications',
        importance: Importance.max,
        priority: Priority.high,
      ),
    );
    await flutterLocalNotificationsPlugin.show(
      0,
      'إسلامي',
      'مرحباً بك في تطبيق إسلامي',
      notificationDetails,
    );
  }

  static void showRepeatedNotification() async {
    NotificationDetails notificationDetails = const NotificationDetails(
      android: AndroidNotificationDetails(
        'repeated_channel',
        'Repeated Notifications',
        importance: Importance.max,
        priority: Priority.high,
      ),
    );
    await flutterLocalNotificationsPlugin.periodicallyShow(
      1,
      'ذكر الله',
      'سبحان الله',
      RepeatInterval.everyMinute,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  static void startHourlyAzkar() {
    Workmanager().registerPeriodicTask(
      "zikr_task_id",
      "hourlyAzkarTask",
      frequency: const Duration(minutes: 15), // أقل وقت مسموح 15 دقيقة
      existingWorkPolicy: ExistingPeriodicWorkPolicy.keep,
      constraints: Constraints(networkType: NetworkType.notRequired),
    );
  }

  static void stopAzkar() {
    Workmanager().cancelByUniqueName("zikr_task_id");
  }

  static void testImmediately() {
    Workmanager().registerOneOffTask("test_unique_id", "testTask");
  }

  static tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
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

  static Future<void> scheduleDailyAzkar() async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'daily_azkar_channel',
          'Daily Azkar',
          importance: Importance.max,
          priority: Priority.high,
        );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    // أذكار الصباح
    await flutterLocalNotificationsPlugin.zonedSchedule(
      10,
      'أذكار الصباح☀️',
      'حان الآن موعد أذكار الصباح، نور بها يومك',
      _nextInstanceOfTime(5, 0),
      notificationDetails,
      payload: 'morning', // مهم جداً للتنقل
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      // uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );

    // أذكار المساء
    await flutterLocalNotificationsPlugin.zonedSchedule(
      11,
      'أذكار المساء🌙',
      'حان الآن موعد أذكار المساء، استعن بها على ليلك',
      _nextInstanceOfTime(15, 0),
      notificationDetails,
      payload: 'evening', // مهم جداً للتنقل
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,

      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  // --- دالة جدولة الأذان (بتوقيت القاهرة) ---
  static Future<void> schedulePrayerNotifications() async {
    // إحداثيات القاهرة
    final coordinates = Coordinates(30.0444, 31.2357);
    // طريقة الحساب المصرية
    final params = CalculationMethod.egyptian.getParameters();
    params.madhab = Madhab.shafi;

    final prayerTimes = PrayerTimes.today(coordinates, params);

    Map<String, DateTime> prayers = {
      'الفجر': prayerTimes.fajr,
      'الظهر': prayerTimes.dhuhr,
      'العصر': prayerTimes.asr,
      'المغرب': prayerTimes.maghrib,
      'العشاء': prayerTimes.isha,
    };

    const androidDetails = AndroidNotificationDetails(
      'prayer_channel',
      'إشعارات الأذان',
      importance: Importance.max,
      priority: Priority.high,
      // sound: RawResourceAndroidNotificationSound('azan'), // تأكدي من وجود ملف azan في res/raw
      audioAttributesUsage: AudioAttributesUsage.notificationRingtone,
    );

    for (var entry in prayers.entries) {
      if (entry.value.isAfter(DateTime.now())) {
        await flutterLocalNotificationsPlugin.zonedSchedule(
          entry.key.hashCode,
          'حان الآن موعد الأذان',
          'حي على الصلاة.. موعد أذان ${entry.key}',
          tz.TZDateTime.from(entry.value, tz.local),
          const NotificationDetails(android: androidDetails),
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        );
      }
    }
  }

  static Future<void> testNavigationNow() async {
    print(
      "جاري جدولة إشعار الاختبار بعد 10 ثوانٍ...",
    ); // للتأكد إن الدالة استدعيت

    try {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        2025,
        'تجربة التنقل ',
        'اضغط هنا وسيفتح لك صفحة أذكار الصباح فوراً',
        tz.TZDateTime.now(tz.local).add(const Duration(seconds: 10)),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'test_nav_channel_unique', // غيري الـ ID عشان نضمن إنه قناة جديدة
            'Test Navigation Channel',
            importance: Importance.max,
            priority: Priority.high,
            fullScreenIntent: true, // بيساعد في ظهور الإشعار بوضوح
          ),
        ),
        payload: 'morning',
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
      print("تمت الجدولة بنجاح!");
    } catch (e) {
      print("خطأ في الجدولة: $e");
    }
  }
}
