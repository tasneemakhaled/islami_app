import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:islami_app/views/prayer_times.dart';
import 'package:islami_app/views/quran_view.dart';
import 'package:islami_app/views/zekr.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int selectedIndex = 0;
  List views = [QuranView(), ZekrView(), PrayerTimes()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black,
        backgroundColor: Color(0xffE2BE7F),
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(FlutterIslamicIcons.quran),
            label: 'قران',
          ),
          BottomNavigationBarItem(
            icon: Icon(FlutterIslamicIcons.tasbih3),
            label: 'مسبحة',
          ),

          BottomNavigationBarItem(
            icon: Icon(FlutterIslamicIcons.prayer),
            label: 'مواقيت الصلاة',
          ),
        ],
      ),
      body: views[selectedIndex],
    );
  }
}
