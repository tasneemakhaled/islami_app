import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MorningAzkar extends StatefulWidget {
  const MorningAzkar({super.key});

  @override
  State<MorningAzkar> createState() => _MorningAzkarState();
}

class _MorningAzkarState extends State<MorningAzkar> {
  List _azkar = [];
  Map<String, int> _savedCounts = {};
  final Color mainColor = const Color(0xFFE2BE7F); // اللون المطلوب

  @override
  void initState() {
    super.initState();
    loadAzkar();
  }

  Future<void> loadAzkar() async {
    try {
      // 1. تحميل الملف من المسار الصحيح
      final String response = await rootBundle.loadString(
        'assets/images/morning_azkar.json',
      );
      final data = await json.decode(response);
      final prefs = await SharedPreferences.getInstance();

      setState(() {
        // 2. الوصول لـ array داخل الملف
        _azkar = data['array'];

        // 3. قراءة العدادات المحفوظة لكل ذكر باستخدام الـ id
        for (var zikr in _azkar) {
          String key = "morning_${zikr['id']}";
          _savedCounts[key] = prefs.getInt(key) ?? zikr['count'];
        }
      });
    } catch (e) {
      debugPrint("Error loading JSON: $e");
    }
  }

  void decrementCounter(int id) async {
    String key = "morning_$id";
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      if (_savedCounts[key] != null && _savedCounts[key]! > 0) {
        _savedCounts[key] = _savedCounts[key]! - 1;
        prefs.setInt(key, _savedCounts[key]!);

        // إذا وصل للصفر ممكن تضيفي اهتزاز خفيف (Vibration) هنا
      }
    });
  }

  // ميزة تصفير العدادات (Reset)
  void resetCounters() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      for (var zikr in _azkar) {
        String key = "morning_${zikr['id']}";
        _savedCounts[key] = zikr['count'];
        prefs.setInt(key, zikr['count']);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text(
          "أذكار الصباح",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            onPressed: resetCounters,
            icon: const Icon(Icons.refresh, color: Colors.white),
            tooltip: "إعادة العدادات",
          ),
        ],
      ),
      body: _azkar.isEmpty
          ? Center(child: CircularProgressIndicator(color: mainColor))
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 10),
              itemCount: _azkar.length,
              itemBuilder: (context, index) {
                var zikr = _azkar[index];
                String key = "morning_${zikr['id']}";
                int currentCount = _savedCounts[key] ?? zikr['count'];

                return GestureDetector(
                  onTap: () => decrementCounter(zikr['id']),
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 8,
                    ),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E1E),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: currentCount == 0
                            ? Colors.green
                            : mainColor.withOpacity(0.3),
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      children: [
                        Directionality(
                          textDirection: TextDirection.rtl,
                          child: Text(
                            zikr['text'], // استخدمنا text كما في ملفك
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              height: 1.6,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // زر العداد
                        Container(
                          width: double.infinity,
                          height: 50,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: currentCount == 0 ? Colors.green : mainColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            currentCount.toString(),
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
