import 'package:flutter/material.dart';
import 'package:islami_app/services/prayer_timing_service.dart';
import 'package:islami_app/views/evening_azkar.dart';
import 'package:islami_app/views/morning_azkar.dart';
import 'package:islami_app/widgets/prayer_item.dart';

class PrayerTimes extends StatelessWidget {
  const PrayerTimes({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage('assets/images/Background.png'),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          // الخطوة الأهم: تغليف المحتوى بـ FutureBuilder
          child: FutureBuilder(
            future: getPrayerData(), // الدالة اللي بتجيب الداتا
            builder: (context, snapshot) {
              // 1. حالة التحميل
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(color: Color(0xffE2BE7F)),
                );
              }
              // 2. حالة وجود خطأ
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    "Error loading data",
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }
              // 3. حالة وصول البيانات
              var data = snapshot.data;
              if (data == null) return Text("No Data");

              // تحويل الـ Timings لـ List عشان نعرف نعرضها في الـ ListView
              List<Map<String, String>> prayersList = [
                {'name': 'Fajr', 'time': data.timings.fajr},
                {'name': 'Sunrise', 'time': data.timings.sunrise},
                {'name': 'Dhuhr', 'time': data.timings.dhuhr},
                {'name': 'Asr', 'time': data.timings.asr},
                {'name': 'Maghrib', 'time': data.timings.maghrib},
                {'name': 'Isha', 'time': data.timings.isha},
              ];

              return SingleChildScrollView(
                child: Column(
                  children: [
                    Image.asset('assets/images/Logo.png'),
                    Container(
                      height: 170,
                      width: 370,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        color: Color(0xffE2BE7F),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // عرض التاريخ الميلادي من الـ API
                                Text(data.readableDate),
                                Column(
                                  children: [
                                    Text('Pray Time'),
                                    Text(data.hijri.dayNameAr),
                                  ], // اسم اليوم بالعربي
                                ),
                                // عرض التاريخ الهجري
                                Text(
                                  '${data.hijri.dayNameAr} ${data.hijri.monthNameAr} ${data.hijri.year}',
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: prayersList.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  // تمرير البيانات للـ Item
                                  child: PrayerItem(
                                    prayerName: prayersList[index]['name']!,
                                    prayerTime: prayersList[index]['time']!,
                                  ),
                                );
                              },
                            ),
                          ),
                          SizedBox(height: 10),
                          // ممكن تحسبي الصلاة القادمة لوجيك، بس حالياً هنسيبها ثابتة أو نعرض الوقت الحالي
                          // Padding(
                          //   padding: const EdgeInsets.only(bottom: 8.0),
                          //   child: Text('Timezone: ${data.timezone}'),
                          // ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    // ... باقي كود الأذكار زي ما هو
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Azkar',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) {
                                  return MorningAzkar();
                                },
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Color(0xffE2BE7F)),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              children: [
                                Image.asset(
                                  'assets/images/morning.png',
                                  width: 150,
                                  height: 150,
                                ),
                                Text(
                                  'Morning Azkar',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) {
                                  return EveningAzkar();
                                },
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Color(0xffE2BE7F)),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              children: [
                                Image.asset(
                                  'assets/images/evening.png',
                                  width: 150,
                                  height: 150,
                                ),
                                Text(
                                  'Evening Azkar',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
