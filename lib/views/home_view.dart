import 'package:flutter/material.dart';
import 'package:islami_app/widgets/custom_navbar.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(bottomNavigationBar: CustomNavbar());
  }
}
