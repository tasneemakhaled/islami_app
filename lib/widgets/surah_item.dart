// widgets/surah_item.dart
import 'package:flutter/material.dart';
import 'package:islami_app/models/surah_model.dart';

class SurahItem extends StatelessWidget {
  final SurahModel surah; // استقبال الموديل

  const SurahItem({super.key, required this.surah});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Image.asset('assets/images/Vector.png'), // تأكد من المسار
            Text(
              '${surah.number}',
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              surah.englishName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${surah.numberOfAyahs} verses',
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ],
        ),
        Text(
          surah.name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
