class PrayerData {
  final PrayerTimings timings;
  final HijriDate hijri;
  final String readableDate;
  final String timezone;

  PrayerData({
    required this.timings,
    required this.hijri,
    required this.readableDate,
    required this.timezone,
  });

  factory PrayerData.fromJson(Map<String, dynamic> json) {
    return PrayerData(
      timings: PrayerTimings.fromJson(json['data']['timings']),

      hijri: HijriDate.fromJson(json['data']['date']['hijri']),

      readableDate: json['data']['date']['readable'],

      timezone: json['data']['meta']['timezone'],
    );
  }
}

// ---------------------------------------------------------

class PrayerTimings {
  final String fajr;
  final String sunrise; // الشروق (مهم للعرض)
  final String dhuhr;
  final String asr;
  final String maghrib;
  final String isha;

  PrayerTimings({
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
  });

  factory PrayerTimings.fromJson(Map<String, dynamic> json) {
    return PrayerTimings(
      fajr: json['Fajr'],
      sunrise: json['Sunrise'],
      dhuhr: json['Dhuhr'],
      asr: json['Asr'],
      maghrib: json['Maghrib'],
      isha: json['Isha'],
    );
  }
}

// ---------------------------------------------------------

class HijriDate {
  final String date; // التاريخ بالأرقام (25-06-1447)
  final String dayNameAr; // اسم اليوم (الثلاثاء)
  final String monthNameAr; // اسم الشهر (جمادى الآخرة)
  final String year; // السنة (1447)

  HijriDate({
    required this.date,
    required this.dayNameAr,
    required this.monthNameAr,
    required this.year,
  });

  factory HijriDate.fromJson(Map<String, dynamic> json) {
    return HijriDate(
      date: json['date'],
      // هنا بنخش جوه weekday عشان نجيب الـ ar
      dayNameAr: json['weekday']['ar'],
      // وهنا بنخش جوه month عشان نجيب الـ ar
      monthNameAr: json['month']['ar'],
      year: json['year'],
    );
  }
}
