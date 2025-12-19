import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:workmanager/workmanager.dart';

import 'package:islami_app/Notifications/local_notifications.dart';
import 'package:islami_app/app.dart';

// دالة الخلفية - لازم تكون بره أي كلاس
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    // 1. تهيئة الإشعارات داخل الخلفية
    await LocalNotifications.init();

    // 2. اختيار ذكر عشوائي
    final random = Random();
    String randomZikr = LocalNotifications
        .azkarList[random.nextInt(LocalNotifications.azkarList.length)];

    // 3. إعداد تفاصيل الإشعار
    NotificationDetails notificationDetails = const NotificationDetails(
      android: AndroidNotificationDetails(
        'zikr_channel_dynamic',
        'أذكار متغيرة',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
      ),
    );

    // 4. إظهار الإشعار
    await LocalNotifications.flutterLocalNotificationsPlugin.show(
      99, // ID ثابت عشان الإشعار يتجدد
      'اذكر الله',
      randomZikr,
      notificationDetails,
    );

    return Future.value(true);
  });
}

void main() async {
  // التأكد من تهيئة كل شيء قبل تشغيل التطبيق
  WidgetsFlutterBinding.ensureInitialized();

  // 1. تهيئة اللوكال نوتيفيكيشن
  await LocalNotifications.init();

  // 2. طلب إذن الإشعارات (لأندرويد 13 فما فوق)
  await LocalNotifications.flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >()
      ?.requestNotificationsPermission();

  // 3. تهيئة الورك مانجر
  await Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode:
        false, // خليها true لو عاوزة تشوفي Notifications من الـ Workmanager نفسه للتجربة
  );

  // 4. تسجيل مهمة الأذكار لتبدأ العمل
  LocalNotifications.startHourlyAzkar();
  LocalNotifications.testImmediately();

  runApp(const IslamiApp());
}
