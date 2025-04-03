import 'package:brainace_pro/activities/math_activities.dart';
import 'package:brainace_pro/activities/reading_writing_activities.dart';
import 'package:brainace_pro/activities/brain_train_activities.dart';
import 'package:brainace_pro/quiz/math_coming_soon.dart';
import 'package:brainace_pro/sats/start_sats_math.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:brainace_pro/navbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:brainace_pro/activities_for_each_section.dart';
import 'package:icon_decoration/icon_decoration.dart';
import 'dart:math' as math;
import 'package:flutter_quizzes/src/sats/sats_question_types_rw.dart';
import 'package:brainace_pro/quiz/math_coming_soon.dart';

import '../margins.dart';
import 'activity_button.dart';

class Activities extends StatefulWidget {
  const Activities({super.key});

  @override
  State<Activities> createState() => _Activities();
}

class _Activities extends State<Activities> {
  List<String> plan = [];

  Widget createActivity2(
      BuildContext context,
      String img,
      String txt1,
      String txt2,
      Widget route,
      String activityName, {
        double fontSize = 1,
        double zero = 1,
      }) {
    Size size = MediaQuery.of(context).size;

    if (skillAllLists[skill] != null && skillAllLists[skill]!.contains(activityName)) {
      return ActivityButton(
        context,
        img: "activities/$img",
        text1: txt1,
        text2: txt2,
        fontSize: 0.023 * size.height * fontSize,
        onTapRoute: route,
        zero: zero,
        blocked: false,
        textWidth: 0.45,
        title: false,
        star: true,
        exerciseName: activityName,
        skill: skill,
        plan: plan,
      );
    }

    return const SizedBox();
  }

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
                  fontSize: size.width / 9,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
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
                            Icon(
                              Icons.star_rounded,
                              color: const Color.fromARGB(255, 255, 208, 0),
                              size: 0.036 * size.height,
                            ),
                            SizedBox(width: 0.02 * size.width),
                            Text(
                              "Do Today",
                              style: TextStyle(
                                fontSize: 0.023 * size.height,
                                color: Theme.of(context).colorScheme.onSurface,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 0.06 * size.height),
                        ActivityButton(
                          context,
                          img: "activities/maths_section",
                          text1: "Mathematics",
                          text2: "Section",
                          fontSize: 0.03 * size.height * 1,
                          onTapRoute: const MathActivities(),
                          // onTapRoute: StartSatsMath(
                          //   subcategory: SatsQuestionSubcategories(ESatsQuestionSubcategories.NonlinearFunctions),
                          // ),
                          forceStar: false,
                        ),
                        // SizedBox(height: 0.02 * size.height),
                        ActivityButton(
                          context,
                          img: "activities/reading_writing_section",
                          text1: "Reading &",
                          text2: "Writing Section",
                          fontSize: 0.03 * size.height * 1,
                          onTapRoute: const ReadingWritingActivities(),
                          forceStar: true,
                        ),
                        // SizedBox(height: 0.01 * size.height),
                        ActivityButton(
                          context,
                          img: "activities/brain_train_section",
                          text1: "Brain Train",
                          text2: "Section",
                          fontSize: 0.03 * size.height * 1,
                          onTapRoute: const BrainTrainActivities(),
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

