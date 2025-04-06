import 'package:brainace_pro/attention/reading/reading_streak.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import '../../activities/activity_button.dart';
import '../../app_bar.dart';
import 'classic.dart';
import 'business.dart';
import 'personal_development.dart';
import 'package:page_transition/page_transition.dart';

class Reading extends StatefulWidget {
  const Reading({super.key});
  @override
  State<Reading> createState() => _Reading();
}

class _Reading extends State<Reading> {
  bool ticked = false;
  int day = 0;

  late SharedPreferences prefs;

  Future<void> saveStreak(bool ticked) async {
    late SharedPreferences prefs;

    prefs = await SharedPreferences.getInstance();
    prefs.setInt('readingDay$day', ticked ? 1 : 0);
  }

  Future<void> calcDay() async {
    DateTime firstDay = DateTime.now();
    DateTime today = DateTime.now();
    prefs = await SharedPreferences.getInstance();
    if (prefs.getString('beginning_date') != null) {
      firstDay = DateTime.parse(prefs.getString('beginning_date')!);
    }

    setState(() {
      day = today.difference(firstDay).inDays + 1;
    });
  }

  Future<void> checkIfTicked() async {
    late SharedPreferences prefs;
    prefs = await SharedPreferences.getInstance();

    setState(() {
      ticked = prefs.getInt('readingDay$day')?.toInt() == 1 ? true : false;
    });
  }

  @override
  void initState() {
    super.initState();
    calcDay();
    checkIfTicked();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: appBar(context, ""),
      body: Container(
        margin: EdgeInsets.only(
          left: size.width / 10,
          right: size.width / 10,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: Text(
                "Attention",
                style: TextStyle(
                  fontSize: size.width / 8,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Center(
              child: Text(
                "Book Reading Out Loud",
                style: TextStyle(fontSize: size.width / 18),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 0.02 * size.height),
            Text(
              "We won’t check if you read books, but you will be able to put a tick each day you do 😉",
              style: TextStyle(fontSize: size.width / 25),
            ),
            SizedBox(height: 0.02 * size.height),
            Row(
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      ticked = !ticked;
                    });
                    saveStreak(ticked);
                  },
                  child: Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      Container(
                        width: 0.08 * min(size.width, size.height),
                        height: 0.08 * min(size.width, size.height),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: (ticked)
                              ? Colors.green
                              : const Color.fromARGB(255, 182, 223, 255),
                        ),
                      ),
                      Icon(
                        ticked ? Icons.done_all_rounded : Icons.done,
                        color: Colors.white,
                        size: 0.07 * min(size.width, size.height),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 0.03 * size.width),
                Text(
                  "Today I Read a Book",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 0.025 * size.height,
                  ),
                ),
              ],
            ),
            SizedBox(height: 0.02 * size.height),
            OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.fade,
                    child: const ReadingStreak(),
                    reverseDuration: const Duration(milliseconds: 100),
                    opaque: true,
                  ),
                );
              },
              child: Text(
                'Check Your Streak',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 0.02 * size.height,
                ),
              ),
            ),
            SizedBox(height: 0.03 * size.height),
            Text(
              'Book Recommendations:',
              style: TextStyle(
                fontSize: 0.025 * size.height,
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 0.015 * size.height),
            Expanded(
              child: ListView(
                children: [
                  Column(
                    children: [
                      ActivityButton(
                        context,
                        img: "attention/reading/classic",
                        text1: "Classic",
                        text2: "Novels",
                        fontSize: 0.021 * size.height,
                        onTapRoute: const Classic(),
                        textWidth: 0.35,
                      ),
                      ActivityButton(
                        context,
                        img: "attention/reading/business",
                        text1: "Business and",
                        text2: "Money",
                        fontSize: 0.021 * size.height,
                        onTapRoute: const Business(),
                        leftColorGradient: const Color.fromARGB(255, 143, 0, 226),
                        rightColorGradient: const Color.fromARGB(255, 101, 0, 184),
                        textWidth: 0.35,
                      ),
                      ActivityButton(
                        context,
                        img: "attention/reading/personal_development",
                        text1: "Personal",
                        text2: "Development",
                        fontSize: 0.021 * size.height,
                        onTapRoute: const PersonalDevelopment(),
                        leftColorGradient: const Color.fromARGB(255, 221, 65, 221),
                        rightColorGradient: const Color.fromARGB(255, 137, 39, 176),
                        textWidth: 0.35,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
