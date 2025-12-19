// ملاحظة: صفحة المساء ستكون مطابقة تماماً لصفحة الصباح
// فقط غيري العناوين والمفاتيح (Keys)

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EveningAzkar extends StatefulWidget {
  const EveningAzkar({super.key});

  @override
  State<EveningAzkar> createState() => _EveningAzkarState();
}

class _EveningAzkarState extends State<EveningAzkar> {
  List _azkar = [];
  Map<String, int> _savedCounts = {};
  final Color mainColor = const Color(0xFFE2BE7F);

  @override
  void initState() {
    super.initState();
    loadAzkar();
  }

  Future<void> loadAzkar() async {
    final String response = await rootBundle.loadString(
      'assets/images/evening_azkar.json',
    );
    final data = await json.decode(response);
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      _azkar = data['array'];
      for (var zikr in _azkar) {
        String key = "evening_${zikr['id']}"; // مفتاح مختلف للمساء
        _savedCounts[key] = prefs.getInt(key) ?? zikr['count'];
      }
    });
  }

  void decrementCounter(int id) async {
    String key = "evening_$id";
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      if (_savedCounts[key] != null && _savedCounts[key]! > 0) {
        _savedCounts[key] = _savedCounts[key]! - 1;
        prefs.setInt(key, _savedCounts[key]!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text(
          "أذكار المساء",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _azkar.isEmpty
          ? Center(child: CircularProgressIndicator(color: mainColor))
          : ListView.builder(
              itemCount: _azkar.length,
              itemBuilder: (context, index) {
                var zikr = _azkar[index];
                String key = "evening_${zikr['id']}";
                int currentCount = _savedCounts[key] ?? zikr['count'];

                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 8,
                  ),
                  child: GestureDetector(
                    onTap: () => decrementCounter(zikr['id']),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E1E1E),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: currentCount == 0
                              ? Colors.green
                              : mainColor.withOpacity(0.3),
                        ),
                      ),
                      child: Column(
                        children: [
                          Directionality(
                            textDirection: TextDirection.rtl,
                            child: Text(
                              zikr['text'],
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                height: 1.6,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: currentCount == 0
                                  ? Colors.green
                                  : mainColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              currentCount.toString(),
                              textAlign: TextAlign.center,
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
                  ),
                );
              },
            ),
    );
  }
}
