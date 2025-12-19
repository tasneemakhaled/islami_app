import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ZekrDetails extends StatefulWidget {
  final String zekrText; // الذكر الذي تم اختياره
  const ZekrDetails({super.key, required this.zekrText});

  @override
  State<ZekrDetails> createState() => _ZekrDetailsState();
}

class _ZekrDetailsState extends State<ZekrDetails> {
  int _counter = 0; // العداد الحالي
  double _rotationAngle = 0; // لعمل تأثير دوران بسيط عند التسبيح

  @override
  void initState() {
    super.initState();
    _loadCounter(); // تحميل العداد عند فتح الصفحة
  }

  // تحميل القيمة من shared_preferences
  Future<void> _loadCounter() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      // نستخدم اسم الذكر كـ مفتاح (Key) لحفظ عداده الخاص
      _counter = prefs.getInt(widget.zekrText) ?? 0;
    });
  }

  // زيادة العداد وحفظه
  Future<void> _incrementCounter() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _counter++;
      _rotationAngle += 0.1; // تدوير السبحة قليلاً مع كل ضغطة
      if (_counter > 33) {
        _counter = 0; // التصفير بعد الوصول لـ 33 (أو أي رقم تحبيه)
      }
      prefs.setInt(widget.zekrText, _counter);
    });
  }

  // تصفير العداد يدوياً
  Future<void> _resetCounter() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _counter = 0;
      prefs.setInt(widget.zekrText, _counter);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fill,
            image: AssetImage('assets/images/Background (1).png'),
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 30),
            Image.asset('assets/images/Logo.png', height: 150),

            const SizedBox(height: 20),

            // جعل السبحة قابلة للضغط
            GestureDetector(
              onTap: _incrementCounter,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // تأثير الدوران للصورة
                  Transform.rotate(
                    angle: _rotationAngle,
                    child: Image.asset('assets/images/Sebha.png', height: 350),
                  ),

                  // النص والعداد فوق السبحة
                  Column(
                    // mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.zekrText, // النص المتغير حسب الاختيار
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '$_counter', // العداد المتغير
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // const Spacer(),
            SizedBox(height: 5),
            // زر التصفير
            ElevatedButton.icon(
              onPressed: _resetCounter,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE2BE7F),
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 10,
                ),
              ),
              icon: const Icon(Icons.refresh),
              label: const Text(
                "تصفير العداد",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
