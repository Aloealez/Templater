import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'sport.dart';
import '../app_bar.dart';

class Yoga extends StatefulWidget {
  const Yoga({super.key});

  @override
  State<Yoga> createState() => _Yoga();
}

class _Yoga extends State<Yoga> {
  Future<void> launchURL(String url) async {
    await launchUrl(Uri.parse(url));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: appBar(context, ""),
      body: Container(
        margin: EdgeInsets.only(
          left: size.width / 20,
          right: size.width / 20,
          //top: size.height / 30,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: Text(
                    "Yoga",
                    style: TextStyle(
                      fontSize: size.width / 8,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Center(
                  child: Text(
                    "10 DAY PLAN",
                    style: TextStyle(fontSize: size.width / 17),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            SizedBox(height: 0.03 * size.height),
            Expanded(
              child: ListView(
                children: [
                  SizedBox(height: 0.02 * size.height),
                  createDay(
                    context,
                    1,
                    ' - 10 min morning Yoga',
                    'SvPKFsCiMsw',
                  ),
                  createDay(
                    context,
                    2,
                    ' - After work Yoga',
                    'A0pkEgZiRG4',
                  ),
                  createDay(
                    context,
                    3,
                    ' - Bedtime Yoga',
                    '4TQsfBYCyKQ',
                  ),
                  createDay(
                    context,
                    4,
                    ' - Bedtime Yoga',
                    '4TQsfBYCyKQ',
                  ),
                  createDay(
                    context,
                    5,
                    ' - 12 min body Strech',
                    '5Ju3XvZ6S1Q',
                  ),
                  createDay(
                    context,
                    6,
                    ' - Back and Hip Strech',
                    'W2hRlGrgoUQ',
                  ),
                  createDay(
                    context,
                    7,
                    ' - Relaxing Yoga',
                    '8TuRYV71Rgo',
                  ),
                  createDay(
                    context,
                    8,
                    ' - 15 min Strech',
                    'TDTR9iNWW_0',
                  ),
                  createDay(
                    context,
                    9,
                    ' - 10 min Morning Yoga',
                    'mEX76-SBuB0',
                  ),
                  createDay(
                    context,
                    10,
                    ' - 15 min Yoga',
                    'ehUQNsyTKCc',
                  ),
                  SizedBox(height: 0.1 * size.height),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
