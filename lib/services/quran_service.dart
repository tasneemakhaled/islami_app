// services/api_service.dart
import 'package:dio/dio.dart';
import 'package:islami_app/models/surah_model.dart';

class ApiService {
  final Dio dio = Dio();

  // جلب قائمة السور (بدون آيات)
  Future<List<SurahModel>> getSurahs() async {
    try {
      var res = await dio.get('http://api.alquran.cloud/v1/surah');
      // الـ API يرجع البيانات داخل مفتاح اسمه "data" وهو عبارة عن List
      List<dynamic> data = res.data['data'];
      return data.map((e) => SurahModel.fromJson(e)).toList();
    } catch (e) {
      throw Exception("Error loading surahs: $e");
    }
  }

  // جلب تفاصيل سورة معينة (مع الآيات)
  Future<SurahModel> getSurahDetails(int num) async {
    try {
      var res = await dio.get(
        'http://api.alquran.cloud/v1/surah/$num/quran-uthmani',
      );
      // الـ API يرجع البيانات داخل مفتاح اسمه "data" وهو عبارة عن Object
      return SurahModel.fromJson(res.data['data']);
    } catch (e) {
      throw Exception("Error loading surah details: $e");
    }
  }
}