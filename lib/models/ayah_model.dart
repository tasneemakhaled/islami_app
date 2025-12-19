// models/ayah_model.dart
class AyahModel {
  final String text;
  final int ayahNum;

  AyahModel({required this.text, required this.ayahNum});

  factory AyahModel.fromJson(Map<String, dynamic> json) {
    return AyahModel(
      text: json['text'], 
      ayahNum: json['numberInSurah']
    );
  }
}