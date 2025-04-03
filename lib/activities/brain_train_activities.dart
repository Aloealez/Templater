import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math' as math;

import '../activities/activity_button.dart';
import '../navbar.dart';
import '../margins.dart';

class BrainTrainActivities extends StatefulWidget {
  const BrainTrainActivities({super.key});

  @override
  State<BrainTrainActivities> createState() => _BrainTrainActivitiesState();
}

class _BrainTrainActivitiesState extends State<BrainTrainActivities> {
  List<String> plan = [];
  int day = 1;
  late SharedPreferences prefs;
  String skill = "attention";

  @override
  void initState() {
    super.initState();
    getSkill();
    calcDay();
    getPlan();
  }

  Future<void> getSkill() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      skill = prefs.getString('skill') ?? "attention";
    });
  }

  Future<void> calcDay() async {
    DateTime today = DateTime.now();
    prefs = await SharedPreferences.getInstance();
    String? beginningDate = prefs.getString('beginning_date');
    if (beginningDate != null) {
      DateTime firstDay = DateTime.parse(beginningDate);
      setState(() {
        day = today.difference(firstDay).inDays + 1;
      });
    }
  }

  Future<void> getPlan() async {
    prefs = await SharedPreferences.getInstance();
    List<String> dayPlan = prefs.getStringList("basePlanDay$day") ?? [];
    if (dayPlan.isNotEmpty) {
      setState(() {
        plan = dayPlan;
      });
    }
  }

  Widget createActivity(
    BuildContext context,
    String img,
    String txt1,
    String txt2,
    String activityName, {
    Widget? route,
    double fontSize = 1,
    double zero = 1,
  }) {
    Size size = MediaQuery.of(context).size;
    if (plan.contains(activityName)) {
      return ActivityButton(
        context,
        img: "activities/$img",
        text1: txt1,
        text2: txt2,
        fontSize: 0.023 * size.height * fontSize,
        onTapRoute: route,
        zero: zero,
        blocked: false,
        exerciseName: activityName,
        skill: skill,
        plan: plan,
      );
    }
    return const SizedBox();
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
          children: <Widget>[
            SizedBox(height: 0.02 * size.height),
            Center(
              child: Text(
                "Your Activities",
                style: TextStyle(
                  fontSize: size.width / 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Center(
              child: Text(
                "Day $day - $formattedDate",
                style: TextStyle(fontSize: size.width / 18),
              ),
            ),
            SizedBox(height: 0.03 * size.height),
            Expanded(
              child: ListView(
                children: [
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Transform.rotate(
                          angle: math.pi / 7,
                          child: Icon(
                            Icons.star,
                            color: const Color.fromARGB(255, 255, 208, 0),
                            size: 0.04 * size.height,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          "Do Today",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 0.03 * size.height),
                  createActivity(context, "learning_words", "Learning", "Words", "MemoryGame"),
                  createActivity(context, "spelling", "Spelling", "Mistakes", "SpellingMistakes"),
                  createActivity(context, "sudoku", "Sudoku", "", "SudokuGame"),
                  createActivity(context, "riddles", "Riddles", "", "Riddles"),
                  createActivity(context, "scrabble", "Like", "Scrabble", "Scrabble"),
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
