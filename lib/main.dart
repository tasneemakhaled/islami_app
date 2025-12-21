import 'dart:math';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:workmanager/workmanager.dart';
import 'package:islami_app/Notifications/local_notifications.dart';
import 'package:islami_app/app.dart';

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

  await LocalNotifications.init();

  var flutterNotifications = LocalNotifications.flutterLocalNotificationsPlugin;
  if (Platform.isAndroid) {
    final androidPlugin = LocalNotifications.flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    await androidPlugin?.requestNotificationsPermission();

    await androidPlugin?.requestExactAlarmsPermission();
    await flutterNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();

    await flutterNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestExactAlarmsPermission();

    await flutterNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestExactAlarmsPermission();

    await Workmanager().initialize(callbackDispatcher, isInDebugMode: false);

    LocalNotifications.startHourlyAzkar();

    await LocalNotifications.scheduleDailyAzkar();
    LocalNotifications.testImmediately();

    await LocalNotifications.testNavigationNow();
    await LocalNotifications.schedulePrayerNotifications();
    runApp(IslamiApp());
  }
}
