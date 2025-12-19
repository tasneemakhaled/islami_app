import 'package:flutter/material.dart';
import 'package:islami_app/views/zekr_details.dart';

class CustomZekr extends StatelessWidget {
  const CustomZekr({super.key, required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return ZekrDetails();
            },
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: Color(0xffE2BE7F),
        ),
        child: ListView(
          shrinkWrap: true,
          // physics: NeverScrollableScrollPhysics(),
          children: [
            Column(
              children: [
                Text(
                  text,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Text(
                    'عدد الحبات 33  ',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Text(
                    'عدد المرات الاجمالي 1  ',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
