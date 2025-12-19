import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:islami_app/Notifications/local_notifications.dart';
import 'package:islami_app/views/home_view.dart';
import 'package:islami_app/views/prayer_times.dart';
import 'package:islami_app/views/zekr.dart';

class CustomNavbar extends StatefulWidget {
  const CustomNavbar({super.key});

  @override
  State<CustomNavbar> createState() => _CustomNavbarState();
}

class _CustomNavbarState extends State<CustomNavbar> {
  int selectedIndex = 0;
  List views = [HomeView(), ZekrView(), PrayerTimes()];
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
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
    );
  }
}
