import 'package:flutter/material.dart';
import 'package:islami_app/widgets/suras_list.dart';

class QuranView extends StatelessWidget {
  const QuranView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height - 60,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage('assets/images/Background.png'),
          ),
        ),
        child: Column(children: [Image.asset('assets/images/Logo.png'), Expanded(child: SurasList())]),
      ),
    );
  }
}
