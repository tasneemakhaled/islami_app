// widgets/sura_details.dart
import 'package:flutter/material.dart';
import 'package:islami_app/models/surah_model.dart';
import 'package:islami_app/services/quran_service.dart'; // تأكدي من المسار الصحيح

class SuraDetails extends StatefulWidget {
  final int surahId;
  final String surahName;

  const SuraDetails({
    super.key,
    required this.surahId,
    required this.surahName,
  });

  @override
  State<SuraDetails> createState() => _SuraDetailsState();
}

class _SuraDetailsState extends State<SuraDetails> {
  late Future<SurahModel> surahDetailsFuture;
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    surahDetailsFuture = apiService.getSurahDetails(widget.surahId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff202020),
      appBar: AppBar(
        backgroundColor: const Color(0xff202020),
        title: Text(
          widget.surahName,
          style: const TextStyle(color: Color(0xffE2BE7F)),
        ),
        iconTheme: const IconThemeData(color: Color(0xffE2BE7F)),
        centerTitle: true,
      ),
      body: FutureBuilder<SurahModel>(
        future: surahDetailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xffE2BE7F)),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Check internet connection',
                style: const TextStyle(color: Colors.white),
              ),
            );
          } else if (!snapshot.hasData) {
            return const Center(
              child: Text(
                'No details found',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          var surah = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 16.0,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // الزخرفة العلوية (اختياري)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset('assets/left.png'),
                      // يمكن إضافة "بسم الله" هنا كصورة أو نص إذا لم تكن جزءاً من الآيات
                      // const Text(
                      //    "بسم الله الرحمن الرحيم",
                      //    style: TextStyle(color: Color(0xffE2BE7F), fontSize: 20, fontWeight: FontWeight.bold),
                      // ),
                      Image.asset('assets/right.png'),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // --- الجزء الأهم: عرض الآيات متصلة ---
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: Text.rich(
                      TextSpan(
                        children: surah.ayahList.map((ayah) {
                          return TextSpan(
                            text: "${ayah.text} ﴿${ayah.ayahNum}﴾ ",
                            style: const TextStyle(
                              color: Color(0xffE2BE7F),
                              fontSize: 22, // تكبير الخط قليلاً للقراءة
                              height: 2.0, // مسافة بين الأسطر
                              fontFamily: 'Amiri', // يفضل استخدام خط عربي
                            ),
                          );
                        }).toList(),
                      ),
                      textAlign: TextAlign.justify, // محاذاة النص من الجانبين
                      textDirection: TextDirection.rtl, // اتجاه عربي
                    ),
                  ),

                  // -------------------------------------
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
