import 'package:flutter/material.dart';
import 'package:islami_app/views/evening_azkar.dart';
import 'package:islami_app/views/home_view.dart';
import 'package:islami_app/views/morning_azkar.dart';
import 'package:islami_app/main.dart'; // استيراد navigatorKey

class IslamiApp extends StatelessWidget {
  const IslamiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey, // ربط المفتاح هنا ضروري جداً
      routes: {
        '/morning_azkar': (context) => const MorningAzkar(),
        '/evening_azkar': (context) => const EveningAzkar(),
      },
      debugShowCheckedModeBanner: false,
      home: const HomeView(),
    );
  }
}
