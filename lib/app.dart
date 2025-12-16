import 'package:flutter/material.dart';
import 'package:islami_app/views/home_view.dart';

class IslamiApp extends StatelessWidget {
  const IslamiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HomeView());
  }
}
