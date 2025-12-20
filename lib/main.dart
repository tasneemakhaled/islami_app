import 'dart:math';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:workmanager/workmanager.dart';
import 'package:islami_app/Notifications/local_notifications.dart';
import 'package:islami_app/app.dart';

// 1. تعريف المفتاح العالمي للملاحة للوصول للصفحات من أي مكان
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    await LocalNotifications.init();

    final random = Random();
    String randomZikr = LocalNotifications
        .azkarList[random.nextInt(LocalNotifications.azkarList.length)];

    NotificationDetails notificationDetails = const NotificationDetails(
      android: AndroidNotificationDetails(
        'zikr_channel_dynamic',
        'أذكار متغيرة',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
      ),
    );

    await LocalNotifications.flutterLocalNotificationsPlugin.show(
      99,
      'اذكر الله',
      randomZikr,
      notificationDetails,
    );

    return Future.value(true);
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // تهيئة الإشعارات
  await LocalNotifications.init();

   var flutterNotifications = LocalNotifications.flutterLocalNotificationsPlugin;
  if (Platform.isAndroid) {
    final androidPlugin = LocalNotifications.flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    
    // 1. طلب إذن الإشعارات العام
    await androidPlugin?.requestNotificationsPermission();
    // 2. طلب إذن المنبهات الدقيقة (مهم جداً للجدولة)
    await androidPlugin?.requestExactAlarmsPermission();
  await flutterNotifications
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.requestNotificationsPermission();
 // طلب إذن المنبه الدقيق (ضروري جداً لـ zonedSchedule)
  await flutterNotifications
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.requestExactAlarmsPermission();
  // طلب إذن المنبه الدقيق (ضروري جداً لـ zonedSchedule)
  await flutterNotifications
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.requestExactAlarmsPermission();
  // تهيئة الورك مانجر
  await Workmanager().initialize(callbackDispatcher, isInDebugMode: false);

  // تسجيل المهام
  LocalNotifications.startHourlyAzkar();

  // جدولة أذكار الصباح والمساء
  await LocalNotifications.scheduleDailyAzkar();
  LocalNotifications.testImmediately();

  // ب- اختبار الملاحة (سيظهر إشعار بعد 10 ثوانٍ لتجربة الضغط عليه)
  await LocalNotifications.testNavigationNow();

  runApp(IslamiApp());
}
}