import 'dart:math';

import 'package:brainace_pro/builders/listening_comprehension_builder.dart';
import 'package:brainace_pro/quiz/quiz_model.dart';
import 'package:brainace_pro/sats/sats_program_selection.dart';
import 'package:flutter_quizzes/flutter_quizzes.dart';
import 'package:flutter_quizzes/flutter_quizzes.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'app_bar.dart';
import 'attention/short_term_concentration.dart';
import 'home.dart';
import 'improvement_selection.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'level_test.dart';
import 'linguistic/listening_comprehension_video.dart';
import 'logical_thinking/riddles.dart';
import 'memory/learning_words/memory_words.dart';

class TimeSelection extends StatefulWidget {
  const TimeSelection({super.key});

  @override
  State<TimeSelection> createState() => _TimeSelectionState();
}

class _TimeSelectionState extends State<TimeSelection> {
  bool startedLevelTest = false;

  @override
  void initState() {
    super.initState();
  }

  startLevelTest() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String skill = prefs.getString('skill') ?? 'sats';

    var route;
    if (skill == 'sats') {
      route = SatsProgramSelection();
    } else if (skill == 'memory') {
      route = LevelTest(
        12,
        testRouteBuilder: MemoryWords.routeBuilder,
        initialTest: true,
        testActivitiesDescription:
            "The test will comprise two activities. In the first, we will assess your learning ability, and in the second, your working memory.",
        testScoreDescription:
            "We will use your score to personalize your app experience.",
      );
    } else if (skill == 'attention') {
      route = LevelTest(
        12,
        testRouteBuilder: ShortTermConcentration.routeBuilder,
        initialTest: true,
        testActivitiesDescription: "The test will comprise two activities, during which we will assess your short-term and long-term concentration abilities.",
        testScoreDescription: "We will use your score to personalize your app experience.",
      );
    } else if (skill == 'linguistic') {
      route = LevelTest(
        12,
        nextRouteBuilder: listeningComprehensionBuilder(Random().nextInt(16), true, false),
        testRouteBuilder: ListeningComprehensionVideo.routeBuilder,
        initialTest: true,
        testActivitiesDescription: "The test will comprise two activities, through which we will assess your listening and reading levels in English.",
        testScoreDescription: "We will use your score to personalize your app experience.",
      );
    } else if (skill == 'logical') {
      route = LevelTest(
        12,
        testRouteBuilder: RiddlesTest.routeBuilder,
        initialTest: true,
        testActivitiesDescription: "In this you will have 8 minutes to solve as many riddles as you can.",
        testScoreDescription: "We will use your score to personalize your app experience.",
      );
    } else if (skill == 'games') {
      route = Home();
    } else {
      route = Home();
    }
    setState(() {
      startedLevelTest = false;
    });
    Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.fade,
        child: route,
        reverseDuration: const Duration(milliseconds: 300),
        opaque: true,
      ),
    );
  }

  Widget createTimeButton(BuildContext context, int time) {
    Size size = MediaQuery.of(context).size;

    return Container(
      width: size.width * 0.6,
      height: size.height / 9,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.secondary,
          ],
          tileMode: TileMode.decal,
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow,
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(5, 5),
          ),
        ],
      ),
      child: startedLevelTest
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).colorScheme.onPrimary),
              ),
            )
          : InkWell(
              onTap: () {
                SharedPreferences.getInstance().then((prefs) {
                  prefs.setInt('training_time', time);
                });
                startLevelTest();
                setState(() {
                  startedLevelTest = true;
                });
              },
              child: Center(
                child: Text(
                  "$time minutes",
                  style: TextStyle(
                    fontSize: size.width / 16,
                    color: Colors.white,
                    shadows: <Shadow>[
                      Shadow(
                        offset: const Offset(2.0, 2.0),
                        blurRadius: 3.0,
                        color: Theme.of(context).colorScheme.shadow,
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: appBar(context, ""),
      body: Center(
        child: Container(
          margin: EdgeInsets.only(
            left: size.width / 10,
            right: size.width / 10,
            top: size.height / 69,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                "Pick Your Daily",
                style: TextStyle(
                  fontSize: size.width / 13,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                "Practice Time",
                style: TextStyle(
                  fontSize: size.width / 13,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 0.07 * size.height),
              createTimeButton(context, 10),
              SizedBox(height: 0.05 * size.height),
              createTimeButton(context, 15),
              SizedBox(height: 0.05 * size.height),
              createTimeButton(context, 20),
              SizedBox(height: 0.05 * size.height),
              createTimeButton(context, 30),
            ],
          ),
        ),
      ),
    );
  }
}
