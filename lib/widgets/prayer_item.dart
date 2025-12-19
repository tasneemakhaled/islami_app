import 'package:flutter/material.dart';

class PrayerItem extends StatelessWidget {
  final String prayerName;
  final String prayerTime;

  const PrayerItem({
    super.key,
    required this.prayerName,
    required this.prayerTime,
  });

  @override
  Widget build(BuildContext context) {
    // دالة بسيطة لتقسيم الوقت واستخراج الـ AM/PM
    // الوقت جاي من الـ API بالشكل ده "14:39"
    String formatTime(String time) {
      List<String> parts = time.split(':');
      int hour = int.parse(parts[0]);
      String minute = parts[1].split(" ")[0]; // لإزالة أي نصوص زائدة لو وجدت
      String period = hour >= 12 ? 'PM' : 'AM';
      
      hour = hour > 12 ? hour - 12 : hour;
      hour = hour == 0 ? 12 : hour; // حالة الساعة 12 بالليل
      
      return "$hour:$minute $period"; 
    }

    String formattedTime = formatTime(prayerTime); // النتيجة مثلا "02:39 PM"
    List<String> timeParts = formattedTime.split(' '); // ["02:39", "PM"]

    return Container(
      width: 100, // زودت العرض شوية عشان يكفي
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xff34312A), Color(0xff99835C)],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(prayerName, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          SizedBox(height: 4),
          Text(timeParts[0], style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          Text(timeParts[1], style: TextStyle(color: Colors.white, fontSize: 12)),
        ],
      ),
    );
  }
}