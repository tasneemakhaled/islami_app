import 'ayah_model.dart';

class SurahModel {
  final int number;
  final String name;
  final String englishName;
  final int numberOfAyahs;
  final List<AyahModel> ayahList;

  SurahModel({
    required this.number,
    required this.name,
    required this.englishName,
    required this.numberOfAyahs,
    required this.ayahList,
  });

  factory SurahModel.fromJson(Map<String, dynamic> json) {
    return SurahModel(
      number: json['number'],
      name: json['name'],
      englishName: json['englishName'],
      numberOfAyahs: json['numberOfAyahs'],
      // نتأكد هل الآيات موجودة أم لا (لأن قائمة السور لا تحتوي على آيات)
      ayahList: json['ayahs'] != null
          ? (json['ayahs'] as List).map((e) => AyahModel.fromJson(e)).toList()
          : [],
    );
  }
}
