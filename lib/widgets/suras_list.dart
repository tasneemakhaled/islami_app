// widgets/suras_list.dart
import 'package:flutter/material.dart';
import 'package:islami_app/models/surah_model.dart';
// استيراد السيرفس
import 'package:islami_app/services/quran_service.dart';
import 'package:islami_app/views/sura_details.dart';
import 'package:islami_app/widgets/surah_item.dart';

class SurasList extends StatefulWidget {
  const SurasList({super.key});

  @override
  State<SurasList> createState() => _SurasListState();
}

class _SurasListState extends State<SurasList> {
  // تعريف متغير لتخزين الـ Future حتى لا يتم استدعاء الـ API مع كل تحديث للشاشة
  late Future<List<SurahModel>> surahsFuture;
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    surahsFuture = apiService.getSurahs();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<SurahModel>>(
      future: surahsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error: ${snapshot.error}',
              style: TextStyle(color: Colors.white),
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text(
              'No Surahs found',
              style: TextStyle(color: Colors.white),
            ),
          );
        }

        var surahs = snapshot.data!;

        return ListView.builder(
          itemCount: surahs.length,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemBuilder: (context, index) {
            return Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          // نمرر رقم السورة واسمها للشاشة التالية
                          return SuraDetails(
                            surahId: surahs[index].number,
                            surahName: surahs[index].name,
                          );
                        },
                      ),
                    );
                  },
                  child: SurahItem(
                    surah: surahs[index],
                  ), // تمرير السورة الحالية
                ),
                const Divider(
                  height: 30,
                  indent: 50,
                  endIndent: 50,
                  color: Colors.grey,
                ),
              ],
            );
          },
        );
      },
    );
  }
}
