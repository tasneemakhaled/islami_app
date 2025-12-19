//http://api.aladhan.com/v1/timingsByCity?city=Cairo&country=Egypt&method=5
import 'package:islami_app/models/prayer_timing_model.dart';
import 'package:dio/dio.dart';

Dio dio = Dio();
Future<PrayerData> getPrayerData() async {
  var res = await dio.get(
    'https://api.aladhan.com/v1/timingsByCity?city=Cairo&country=Egypt&method=5',
  );
   // عشان نتأكد إن الداتا وصلت صح (اختياري للتجربة)
  print(res.data); 
  
  // هنا لازم نحول الـ Map لـ Object باستخدام الموديل اللي عملتيه
  return PrayerData.fromJson(res.data);
}
