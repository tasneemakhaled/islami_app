import 'package:flutter/material.dart';
import 'package:islami_app/views/zekr_details.dart';
import 'package:islami_app/widgets/custom_zekr.dart';

class ZekrView extends StatelessWidget {
  const ZekrView({super.key});
  static const List<String> zekr = [
    'سبحان الله',
    'الحمد لله',
    'لا اله الا الله',
    'الله اكبر',
    'لا حول ولا قوة الا بالله',
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // appBar: AppBar(
        //   title: Text(
        //     'المسبحة الالكترونية',
        //     style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        //   ),
        // ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/Background (1).png'),
              fit: BoxFit.cover,
            ),
          ),

          // child: Column(
          //   children: [
          //     CustomZekr(text: 'سبحان الله'),
          //     CustomZekr(text: 'الحمد لله'),
          //     CustomZekr(text: 'لا اله الا الله'),
          //     CustomZekr(text: 'الله اكبر'),
          //     CustomZekr(text: 'لا حول ولا قوة الا بالله'),
          //   ],
          // ),
          child: ListView.builder(
            // shrinkWrap: true,
            // physics: NeverScrollableScrollPhysics(),
            itemCount: zekr.length,
           // داخل ListView.builder في صفحة ZekrView
itemBuilder: (context, index) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ZekrDetails(zekrText: zekr[index]),
          ),
        );
      },
      child: CustomZekr(text: zekr[index]),
    ),
  );
},
          ),
        ),
      ),
    );
  }
}
