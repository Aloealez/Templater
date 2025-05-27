import 'package:flutter/material.dart';
import '../../app_bar.dart';
import '../../buttons.dart';
import 'main.dart';

class PoemsInfo extends StatefulWidget {
  const PoemsInfo({super.key});

  static PoemsInfo routeBuilder(
      BuildContext context, {
        required bool initialTest,
        required bool endingTest,
      }) {
    return PoemsInfo(
    );
  }

  @override
  State<PoemsInfo> createState() => _PoemsInfo();
}

class _PoemsInfo extends State<PoemsInfo> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: appBar(context, ''),
      body: Container(
        margin: EdgeInsets.only(
          left: size.width / 15,
          right: size.width / 15,
          bottom: size.height / 10,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: Text(
                'Linguistic',
                style: TextStyle(fontSize: 0.14 * size.width),
                textAlign: TextAlign.center,
              ),
            ),
            Center(
              child: Text(
                'Intelligence',
                style: TextStyle(fontSize: 0.08 * size.width),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 0.04 * size.height),
            Text(
              ' Exercise 1 -  Poems Reading Out-Loud',
              style: TextStyle(fontSize: 0.05 * size.width),
              textAlign: TextAlign.start,
            ),
            SizedBox(height: 0.07 * size.height),
            Text(
              'Poem for today : )',
              style: TextStyle(fontSize: size.height / 30),
            ),
            const Spacer(),
            Center(
              child: SizedBox(
                height: size.height * 0.05,
                width: size.width * 0.75,
                child: RedirectButton(
                  route: const Poems(),
                  text: 'Continue',
                  width: size.width,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
