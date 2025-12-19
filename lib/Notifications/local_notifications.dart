import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:workmanager/workmanager.dart';

class LocalNotifications {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // قائمة الأذكار
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

  static onTap(NotificationResponse notificationResponse) {
    // هنا تقدري تحددي يحصل إيه لما يضغط على الإشعار
  }

  // تهيئة الإشعارات
  static Future init() async {
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

  // إشعار عادي (مرة واحدة)
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

  // إشعار يتكرر (نفس النص) كل دقيقة أو ساعة
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
      RepeatInterval.everyMinute, // أو hourly
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  // تشغيل مهمة الأذكار المتغيرة (كل ساعة)
  static void startHourlyAzkar() {
    Workmanager().registerPeriodicTask(
      "zikr_task_id", // معرف فريد للمهمة
      "hourlyAzkarTask",
      frequency: const Duration(
        hours: 1,
      ), // التكرار كل ساعة (أقل شيء مسموح به 15 دقيقة)
      constraints: Constraints(networkType: NetworkType.notRequired),
    );
  }

  // لإيقاف الأذكار تماماً
  static void stopAzkar() {
    Workmanager().cancelByUniqueName("zikr_task_id");
  }

  // ميثود للتجربة الفورية (بتشتغل مرة واحدة بعد ثواني)
  static void testImmediately() {
    Workmanager().registerOneOffTask("test_unique_id", "testTask");
  }
}
