import 'package:brainace_pro/activities/activity_button.dart';
import 'package:flutter_quizzes/flutter_quizzes.dart';
import 'package:brainace_pro/sats/start_sats_quiz.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:brainace_pro/navbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:icon_decoration/icon_decoration.dart';
import 'dart:math' as math;

import '../margins.dart';

class MathActivities extends StatefulWidget {
  const MathActivities({super.key});

  @override
  State<MathActivities> createState() => _MathActivitiesState();
}

class _MathActivitiesState extends State<MathActivities> {
  List<String> plan = [];

  Future<void> getPlan() async {
    prefs = await SharedPreferences.getInstance();
    List<String> newPlan = prefs.getStringList("basePlanDay$day") ?? [];
    if (newPlan.isNotEmpty) {
      setState(() {
        plan = newPlan;
      });
      return;
    }
  }

  int day = 1;
  late SharedPreferences prefs;
  String skill = "attention";

  Future<void> getSkill() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      if (prefs.getString('skill') != null) {
        skill = prefs.getString('skill')!;
      } else {
        skill = "attention";
      }
    });
  }

  Future<void> calcDay() async {
    DateTime firstDay = DateTime.now();
    DateTime today = DateTime.now();
    prefs = await SharedPreferences.getInstance();
    String beginningDate = prefs.getString('beginning_date')!;
    firstDay = DateTime.parse(beginningDate);

    setState(() {
      day = today.difference(firstDay).inDays + 1;
    });
  }

  @override
  void initState() {
    super.initState();
    getSkill();
    calcDay();
    getPlan();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    DateTime now = DateTime.now();
    var formatter = DateFormat('E. dd MMM');
    String formattedDate = formatter.format(now);

    return Scaffold(
      body: Container(
        margin: activitiesMargins(size),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 0.005 * size.height),
            Center(
              child: Text(
                "Your Activities",
                style: TextStyle(
                  fontSize: size.width / 12,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Center(
              child: Text(
                "Day $day - ${formattedDate.toString()}",
                style: TextStyle(fontSize: size.width / 17),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 0.015 * size.height),
            Expanded(
              child: ListView(
                padding: EdgeInsets.only(
                  top: 0.02 * size.height, // space between "Do Today" and activities list
                ),
                children: [
                  Container(
                    margin: EdgeInsets.only(
                      left: size.width / 20,
                      right: size.width / 20,
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Transform.rotate(
                              angle: math.pi / 0.07,
                              child: DecoratedIcon(
                                icon: Icon(
                                  Icons.star,
                                  color: const Color.fromARGB(255, 255, 208, 0),
                                  size: 0.03 * size.height,
                                ),
                                decoration: const IconDecoration(border: IconBorder()),
                              ),
                            ),
                            SizedBox(width: 0.02 * size.width),
                            Text(
                              "Do Today",
                              style: TextStyle(
                                fontSize: 0.02 * size.height,
                                color: Theme.of(context).colorScheme.onSurface,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 0.03 * size.height),
                        for (String questionSubcategory in SatsQuestionSubcategories.typesList.sublist(10))
                          ActivityButton(
                            context,
                            img: "activities/$questionSubcategory",
                            text1: SatsQuestionSubcategories.fromString(questionSubcategory).getName(),
                            text2: "",
                            fontSize: 0.023 * size.height * 1,
                            // onTapRoute: StartSatsQuiz(subcategory: SatsQuestionSubcategories.fromString(questionSubcategory)),
                            zero: 1,
                            blocked: false,
                            textWidth: 0.45,
                            title: false,
                            star: true,
                            exerciseName: questionSubcategory,
                            skill: skill,
                            plan: plan,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const MyBottomNavigationBar(),
    );
  }
}
