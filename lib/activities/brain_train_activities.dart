import 'package:brainace_pro/activities/activity_button.dart';
import 'package:brainace_pro/activities/start_activity.dart';
import 'package:brainace_pro/attention/find_the_number.dart';
import 'package:brainace_pro/builders/grammar_mcq_builder.dart';
import 'package:brainace_pro/builders/idioms_builder.dart';
import 'package:brainace_pro/builders/listening_comprehension_builder.dart';
import 'package:brainace_pro/builders/riddle_of_the_day_builder.dart';
import 'package:brainace_pro/builders/spelling_mistakes_builder.dart';
import 'package:brainace_pro/builders/strong_concentration_builder.dart';
import 'package:brainace_pro/builders/vocabulary_builder.dart';
import 'package:brainace_pro/level_instruction.dart';
import 'package:brainace_pro/linguistic/reading_comprehension.dart';
import 'package:brainace_pro/well_being/meditation/meditation_minutes.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../builders/correct_a_word_builder.dart';
import '../builders/long_term_concentration_builder.dart';
import '../linguistic/poems_reading/main.dart';
import '../margins.dart';
import '../memory/learning_words/memory_words.dart';
import '../memory/memory_game2.dart';
import '../navbar.dart';
import '../well_being/self_reflection.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../well_being/sport.dart';
import '../well_being/yoga.dart';
import '../memory/faces.dart';
import '../attention/long_term_concentration_video.dart';
import '../attention/short_term_concentration.dart';
import '../attention/reading/reading.dart';
import '../logical_thinking/sudoku.dart';
import '../linguistic/wordly.dart';
import '../linguistic/hangman.dart';
import '../logical_thinking/riddles.dart';
import '../memory/working_memory.dart';
import '../linguistic/scrabble.dart';
import '../logical_thinking/2048/game_2048.dart';
import '../well_being/memes.dart';
import 'package:flutter_quizzes/flutter_quizzes.dart';
import 'package:brainace_pro/activities_for_each_section.dart';
import 'package:icon_decoration/icon_decoration.dart';
import 'dart:math' as math;

class BrainTrainActivities extends StatefulWidget {
  const BrainTrainActivities({super.key});

  @override
  State<BrainTrainActivities> createState() => _BrainTrainActivities();
}

class _BrainTrainActivities extends State<BrainTrainActivities> {
  List<String> plan = [];

  Widget createActivity2(
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

    if (skillAllLists[skill] != null &&
        skillAllLists[skill]!.contains(activityName)) {
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
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 0.015 * size.height),
            Expanded(
              child: ListView(
                padding: EdgeInsets.only(
                  top: 0.02 *
                      size.height, // space between "Do Today" and activities list
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
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 0.03 * size.height),
                        createActivity2(
                          context,
                          "learning_words",
                          "Learning",
                          "Words",
                          "Memory",
                        ),
                        createActivity2(
                          context,
                          "working_memory",
                          "Working",
                          "Memory",
                          "WorkingMemory",
                        ),
                        createActivity2(
                          context,
                          "find_the_number",
                          "Find the",
                          "Number",
                          "FindTheNumber",
                        ),
                        createActivity2(
                          context,
                          "listening",
                          "Listening",
                          "Comprehension",
                          "ListeningComprehensionVideo",
                        ),
                        createActivity2(
                          context,
                          "reading",
                          "Reading",
                          "Comprehension",
                          "ReadingComprehension",
                        ),
                        createActivity2(
                          context,
                          "poems",
                          "Poems",
                          "Reading",
                          // const PoemsInfo(),
                          "PoemsInfo",
                        ),
                        createActivity2(
                          context,
                          "spelling",
                          "Spelling",
                          "Mistakes",
                          "SpellingMistakes",
                        ),
                        createActivity2(
                          context,
                          "riddles",
                          "Riddles",
                          "",
                          "Riddles",
                          zero: 0,
                        ),
                        createActivity2(
                          context,
                          "riddle_of_the_day",
                          "Riddle Of The Day",
                          "",
                          "RiddleOfTheDay",
                          zero: 0,
                        ),
                        createActivity2(
                          context,
                          "sudoku",
                          "Sudoku",
                          "",
                          "SudokuGame",
                          zero: 0,
                        ),
                        createActivity2(
                          context,
                          "short_term_concentration",
                          "Short-Term",
                          "Concentration",
                          "ShortTermConcentration",
                        ),
                        createActivity2(
                          context,
                          "long_term_concentration",
                          "Long-Term",
                          "Concentration",
                          "LongTermConcentrationVideo",
                        ),
                        createActivity2(
                          context,
                          "strong_concentration",
                          "Strong",
                          "Concentration",
                          "StrongConcentrationDesc",
                        ),
                        createActivity2(
                          context,
                          "reading_out_loud",
                          "Reading",
                          "Out-loud",
                          "Reading",
                        ),
                        createActivity2(
                          context,
                          "hangman",
                          "Hangman",
                          "",
                          "Hangman",
                          zero: 0,
                        ),
                        createActivity2(
                          context,
                          "wordly",
                          "Wordly",
                          "",
                          "Wordly",
                          zero: 0,
                        ),
                        createActivity2(
                          context,
                          "2048",
                          "2048",
                          "",
                          "Game2048",
                          zero: 0,
                        ),
                        createActivity2(
                          context,
                          "scrabble",
                          "Like",
                          "Scrabble",
                          "Scrabble",
                        ),
                        createActivity2(
                          context,
                          "faces_memory",
                          "Faces",
                          "Memory",
                          "Faces",
                        ),
                        createActivity2(
                          context,
                          "correct_a_word",
                          "Correct a word",
                          "",
                          "CorrectAWord",
                          zero: 0,
                        ),
                        createActivity2(
                          (context),
                          "investing",
                          "Investing",
                          "Course",
                          "InvestingMenu",
                        ),
                        createActivity2(
                          context,
                          "grammar",
                          "Grammar",
                          "",
                          "Grammar",
                          zero: 0,
                        ),
                        createActivity2(
                          context,
                          "vocabulary",
                          "Vocabulary",
                          "",
                          // const ChooseBestWord(),
                          "Vocabulary",
                        ),
                        createActivity2(
                          context,
                          "idioms",
                          "Idioms, Expressions, and Phrasal Verbs",
                          "",
                          "Idioms",
                          zero: 0,
                        ),
                        createActivity2(
                          context,
                          "memory_game",
                          "Memory",
                          "Game",
                          "MemoryGame1",
                        ),
                        createActivity2(
                          context,
                          "sport",
                          "Sport",
                          "Optional",
                          "Sport",
                        ),
                        createActivity2(
                          context,
                          "yoga",
                          "Yoga",
                          "",
                          "Yoga",
                          zero: 0,
                        ),
                        createActivity2(
                          context,
                          "self_reflection",
                          "Self",
                          "Reflection",
                          "SelfReflection",
                        ),
                        createActivity2(
                          context,
                          "meditation",
                          "Meditation",
                          "",
                          "Meditation",
                          zero: 0,
                        ),
                        createActivity2(
                          context,
                          "memes",
                          "Memes",
                          "",
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
