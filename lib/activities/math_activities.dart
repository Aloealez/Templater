import 'package:brainace_pro/activities/activity_button.dart';
import 'package:brainace_pro/attention/find_the_number.dart';
import 'package:brainace_pro/linguistic/reading_comprehension.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../navbar.dart';
import '../well_being/self_reflection.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../well_being/sport.dart';
import '../well_being/yoga.dart';
import '../memory/memory_game1.dart';
import '../memory/learning_words/memory.dart';
import '../memory/faces.dart';
import '../attention/long_term_concentration_video.dart';
import '../attention/short_term_concentration.dart';
import '../attention/reading/reading.dart';
import '../logical_thinking/sudoku.dart';
import '../linguistic/wordly.dart';
import '../linguistic/hangman.dart';
import '../logical_thinking/riddles.dart';
import '../linguistic/listening_comprehension_video.dart';
import '../memory/working_memory.dart';
import '../linguistic/scrabble.dart';
import '../logical_thinking/2048/game_2048.dart';
import '../well_being/memes.dart';
import '../investing/menu.dart';
import '../linguistic/poems_reading/poems_info.dart';
import 'package:brainace_pro/activities_for_each_section.dart';
import 'package:icon_decoration/icon_decoration.dart';
import 'dart:math' as math;

class MathActivities extends StatefulWidget {
  const MathActivities({super.key});
  @override
  State<MathActivities> createState() => _MathActivities();
}

class _MathActivities extends State<MathActivities> {
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

    if (skillAllLists[skill] != null &&
        skillAllLists[skill]!.contains(activityName)) {
      return ActivityButton(
        context,
        img: "activities/$img",
        text1: txt1,
        text2: txt2,
        fontSize: 0.023 * size.height * fontSize,
        onTapRoute: route,
        color1: Theme.of(context).colorScheme.primary,
        color2: Theme.of(context).colorScheme.secondary,
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
        margin: EdgeInsets.only(
          left: size.width / 15,
          right: size.width / 15,
          top: size.height / 10,
        ),
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
                                decoration:
                                    const IconDecoration(border: IconBorder()),
                              ),
                            ),
                            SizedBox(width: 0.02 * size.width),
                            Text(
                              "Do Today",
                              style: TextStyle(
                                fontSize: 0.02 * size.height,
                                color:
                                    Theme.of(context).colorScheme.onSurface,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 0.02 * size.height),
                        createActivity2(
                          context,
                          "learning_words",
                          "Learning",
                          "Words",
                          const Memory(),
                          "Memory",
                        ),
                        createActivity2(
                          context,
                          "working_memory",
                          "Working",
                          "Memory",
                          const WorkingMemory(),
                          "WorkingMemory",
                        ),
                        createActivity2(
                          context,
                          "find_the_number",
                          "Find the",
                          "Number",
                          const FindTheNumber(),
                          "FindTheNumber",
                        ),
                        createActivity2(
                          context,
                          "listening",
                          "Listening",
                          "Comprehension",
                          const ListeningComprehensionVideo(),
                          "ListeningComprehensionVideo",
                        ),
                        createActivity2(
                          context,
                          "reading",
                          "Reading",
                          "Comprehension",
                          const ReadingComprehension(),
                          "ReadingComprehension",
                        ),
                        createActivity2(
                          context,
                          "poems",
                          "POEMS",
                          "Reading",
                          const PoemsInfo(),
                          "PoemsInfo",
                        ),
                        // createActivity2(
                        //   context,
                        //   "spelling",
                        //   "SPELLING",
                        //   "Mistakes",
                        //   const SpellingMistakes(
                        //     exerciseId: 0,
                        //   ),
                        //   "SpellingMistakes",
                        // ),
                        createActivity2(
                          context,
                          "riddles",
                          "RIDDLES",
                          "",
                          const RiddlesTest(),
                          "Riddles",
                          zero: 0,
                        ),
                        createActivity2(
                          context,
                          "sudoku",
                          "Sudoku",
                          "",
                          const SudokuGame(),
                          "SudokuGame",
                          zero: 0,
                        ),
                        createActivity2(
                          context,
                          "short_term_concentration",
                          "Short-Term",
                          "Concentration",
                          const ShortTermConcentration(),
                          "ShortTermConcentration",
                        ),
                        createActivity2(
                          context,
                          "long_term_concentration",
                          "Long-Term",
                          "Concentration",
                          const LongTermConcentrationVideo(),
                          "LongTermConcentrationVideo",
                        ),
                        // createActivity2(
                        //   context,
                        //   "strong_concentration",
                        //   "Strong",
                        //   "Concentration",
                        //   const StrongConcentrationDesc(),
                        //   "StrongConcentrationDesc",
                        // ),
                        createActivity2(
                          context,
                          "reading_out_loud",
                          "Reading",
                          "Out-loud",
                          const Reading(),
                          "Reading",
                        ),
                        createActivity2(
                          context,
                          "hangman",
                          "Hangman",
                          "",
                          const Hangman(),
                          "Hangman",
                          zero: 0,
                        ),
                        createActivity2(
                          context,
                          "wordly",
                          "Wordly",
                          "",
                          const Wordly(),
                          "Wordly",
                          zero: 0,
                        ),
                        createActivity2(
                          context,
                          "2048",
                          "2048",
                          "",
                          const Game2048(),
                          "Game2048",
                          zero: 0,
                        ),
                        createActivity2(
                          context,
                          "scrabble",
                          "Like",
                          "Scrabble",
                          const Scrabble(
                            iteration: 1,
                            allPoints: 0,
                          ),
                          "Scrabble",
                        ),
                        createActivity2(
                          context,
                          "faces_memory",
                          "Faces",
                          "Memory",
                          const Faces(),
                          "Faces",
                        ),
                        // createActivity2(
                        //   context,
                        //   "correct_a_word",
                        //   "Correct a word",
                        //   "",
                        //   const CorrectAWord(),
                        //   "CorrectAWord",
                        //   zero: 0,
                        // ),
                        createActivity2(
                          (context),
                          "investing",
                          "Investing",
                          "Course",
                          const InvestingMenu(),
                          "InvestingMenu",
                        ),
                        // createActivity2(
                        //   context,
                        //   "grammar",
                        //   "Grammar",
                        //   "",
                        //   const Grammar(
                        //     exerciseId: 0,
                        //   ),
                        //   "Grammar",
                        //   zero: 0,
                        // ),
                        // createActivity2(
                        //   context,
                        //   "choose_best_word",
                        //   "Vocabulary",
                        //   "",
                        //   const ChooseBestWord(),
                        //   "Vocabulary",
                        // ),
                        // createActivity2(
                        //   context,
                        //   "idioms",
                        //   "Idioms, expressions and phrasal verbs",
                        //   "",
                        //   const Idioms(),
                        //   "Idioms",
                        //   zero: 0,
                        // ),
                        createActivity2(
                          context,
                          "memory_game",
                          "Memory",
                          "Game",
                          const MemoryGame1(),
                          "MemoryGame1",
                        ),
                        createActivity2(
                          context,
                          "sport",
                          "Sport",
                          "Optional",
                          const Sport(),
                          "Sport",
                        ),
                        createActivity2(
                          context,
                          "yoga",
                          "Yoga",
                          "",
                          const Yoga(),
                          "Yoga",
                          zero: 0,
                        ),
                        createActivity2(
                          context,
                          "self_reflection",
                          "Self",
                          "Reflection",
                          const SelfReflection(),
                          "SelfReflection",
                        ),
                        // createActivity2(
                        //   context,
                        //   "meditation",
                        //   "Meditation",
                        //   "",
                        //   LevelInstruction(
                        //     "Meditation",
                        //     5,
                        //     MeditationMinutes.routeBuilder,
                        //     testTimeDescription: "Meditation offers a path to inner peace, reduced stress, increased focus, and enhanced emotional balance.",
                        //     testActivitiesDescription: "Before you begin, find a quiet place and get comfortable. When you are ready to start.",
                        //     testScoreDescription: "You can sit on a cushion or chair, or even lie down if that's more comfortable for you.",
                        //   ),
                        //   "Meditation",
                        //   zero: 0,
                        // ),
                        createActivity2(
                          context,
                          "memes",
                          "Memes",
                          "",
                          const Meme(),
                          "Meme",
                          zero: 0,
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
