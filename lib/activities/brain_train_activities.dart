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
import '../investing/menu.dart';
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
                  top: 0.02 *
                      size.height, // space between "Do Today" and activities list
                ),
                children: [
                  Container(
                    margin: EdgeInsets.only(
                      left: size.width / 20,
                      right: size.width / 30,
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
                                decoration: const IconDecoration(
                                  border: IconBorder(),
                                ),
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
                        createActivity2(
                          context,
                          "learning_words",
                          "Learning",
                          "Words",
                          activityMemory(context),
                          "Memory",
                        ),
                        createActivity2(
                          context,
                          "working_memory",
                          "Working",
                          "Memory",
                          LevelInstruction(
                            "Working Memory",
                            testTime: "3 minutes",
                            exercise: "WorkingMemory",
                            testRouteBuilder: WorkingMemory.routeBuilder,
                            testActivitiesDescription: "In this activity, we will test your short-term memory.",
                            testScoreDescription: "You will need a piece of paper and something to write with.",
                          ),
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
                          LevelInstruction(
                            "Listening Comprehension",
                            testTime: "6 minute",
                            exercise: "ListeningComprehensionVideo",
                            nextRouteBuilder: listeningComprehensionBuilder(math.Random().nextInt(16), false, false),
                            testRouteBuilder: (
                                BuildContext context, {
                                  required bool initialTest,
                                  required bool endingTest,
                                }) {return MemoryWords.routeBuilder(context, initialTest: initialTest, endingTest: endingTest);},
                            testActivitiesDescription: "In this activity you will watch a 4-5 minutes video, which will be followed by a MCQ quiz.",
                            testScoreDescription: "You will have no possibility to rewatch the video so we recommend you make notes.",
                          ),
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
                          "Poems",
                          "Reading",
                          LevelInstruction(
                            "Poems Reading",
                            testTime: "1 minute",
                            testRouteBuilder: Poems.routeBuilder,
                            testActivitiesDescription:
                                "In this activity, you can listen to a poem, read it aloud, and have your pronunciation checked 🙂.",
                            testScoreDescription:
                                "There is only one poem per day.",
                          ),
                          // const PoemsInfo(),
                          "PoemsInfo",
                        ),
                        createActivity2(
                          context,
                          "spelling",
                          "Spelling",
                          "Mistakes",
                          LevelInstruction(
                            "Spelling Mistakes",
                            testTime: "1 minute",
                            exercise: "SpellingMistakes",
                            nextRouteBuilder: spellingMistakesBuilder(
                              context,
                              initialTest: false,
                              endingTest: false,
                            ),
                            testRouteBuilder: ShortTermConcentration.routeBuilder,
                            testActivitiesDescription: "In this activity, you are supposed to select the correct spelling of the word.",
                            testScoreDescription: "The questions will match the level you picked at the beginning.",
                          ),
                          "SpellingMistakes",
                        ),
                        createActivity2(
                          context,
                          "riddles",
                          "Riddles",
                          "",
                          const RiddlesTest(),
                          "Riddles",
                          zero: 0,
                        ),
                        createActivity2(
                          context,
                          "riddle_of_the_day",
                          "Riddle Of The Day",
                          "",
                          LevelInstruction(
                            "Riddle Of The Day",
                            testTime: "3 minutes",
                            exercise: "RiddleOfTheDay",
                            nextRouteBuilder: riddleOfTheDayBuilder(context, initialTest: false, endingTest: false),
                            testRouteBuilder: RiddlesTest.routeBuilder,
                            testActivitiesDescription: "In this section you will receive one harder riddle.",
                            testScoreDescription: "You will have 3 minutes to solve it.",
                          ),
                          // const RiddlesTest(),
                          "RiddleOfTheDay",
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
                          LevelInstruction(
                            "Attention",
                              testTime: "5 minutes",
                            exercise: "ShortTermConcentration",
                            testRouteBuilder: ShortTermConcentration.routeBuilder,
                            testActivitiesDescription: "In this activity, we will test your short-term memory.",
                            testScoreDescription: "You will need a piece of paper and something to write with.",
                          ),
                          "ShortTermConcentration",
                        ),
                        createActivity2(
                          context,
                          "long_term_concentration",
                          "Long-Term",
                          "Concentration",
                          LevelInstruction(
                            "Attention",
                            testTime: "5 minutes",
                            exercise: "LongTermConcentrationVideo",
                            nextRouteBuilder: longTermConcentrationBuilder(math.Random().nextInt(13), false, false),
                            testRouteBuilder: LongTermConcentrationVideo.routeBuilder,
                            testActivitiesDescription: "In this activity you will watch a 4-5 minutes video, which will be followed by a MCQ quiz.",
                            testScoreDescription: "You will have no possibility to rewatch the video so we recommend you make notes.",
                          ),
                          "LongTermConcentrationVideo",
                        ),
                        createActivity2(
                          context,
                          "strong_concentration",
                          "Strong",
                          "Concentration",
                          LevelInstruction(
                            "Strong Concentration",
                            testTime: "2 minutes",
                            exercise: "StrongConcentrationDesc",
                            nextRouteBuilder: strongConcentrationBuilder(initialTest: false, endingTest: false),
                            testRouteBuilder: LongTermConcentrationVideo.routeBuilder,
                            testActivitiesDescription:
                                "In this exercise, you will have 2 minutes to solve as many math equations as possible while listening to music.",
                            testScoreDescription:
                                "You cannot use the calculator.",
                          ),
                          "StrongConcentrationDesc",
                        ),
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
                        createActivity2(
                          context,
                          "correct_a_word",
                          "Correct a word",
                          "",
                          LevelInstruction(
                            "Correct A Word",
                            testTime: "2 minutes",
                            exercise: "SpellingMistakes",
                            nextRouteBuilder: correctAWordBuilder(
                              context,
                              initialTest: false,
                              endingTest: false,
                            ),
                            testRouteBuilder: MemoryGame2.routeBuilder,
                            testActivitiesDescription: "In this activity you will be presented with different texts and your task will be to find one word which is misspelled and correct it.",
                            testScoreDescription: "If you believe all the words are correct, leave the field empty.",
                          ),
                          "CorrectAWord",
                          zero: 0,
                        ),
                        createActivity2(
                          (context),
                          "investing",
                          "Investing",
                          "Course",
                          activityInvestingMenu(context),
                          "InvestingMenu",
                        ),
                        createActivity2(
                          context,
                          "grammar",
                          "Grammar",
                          "",
                          activityGrammar(context),
                          "Grammar",
                          zero: 0,
                        ),
                        createActivity2(
                          context,
                          "vocabulary",
                          "Vocabulary",
                          "",
                          activityVocabulary(context),
                          // const ChooseBestWord(),
                          "Vocabulary",
                        ),
                        createActivity2(
                          context,
                          "idioms",
                          "Idioms, Expressions, and Phrasal Verbs",
                          "",
                          activityIdioms(context),
                          "Idioms",
                          zero: 0,
                        ),
                        createActivity2(
                          context,
                          "memory_game",
                          "Memory",
                          "Game",
                          activityMemoryGame(context),
                          "MemoryGame1",
                        ),
                        createActivity2(
                          context,
                          "sport",
                          "Sport",
                          "Optional",
                          activitySport(context),
                          // LevelInstruction(
                          //   "Sport",
                          //   nextRouteBuilder: FutureBuilder(future: () async {} (),
                          //       builder: (context, snapshot) {
                          //         if (snapshot.connectionState == ConnectionState.waiting) {
                          //           return const Center(child: CircularProgressIndicator());
                          //         }
                          //         return const Sport();
                          //       },),
                          //   testRouteBuilder: MemoryGame2.routeBuilder,
                          //   testActivitiesDescription: "Here is an example plan we created for you 🙂",
                          //   testScoreDescription: "Next update will introduce different plan choices.",
                          // ),
                          "Sport",
                        ),
                        createActivity2(
                          context,
                          "yoga",
                          "Yoga",
                          "",
                          activityYoga(context),
                          "Yoga",
                          zero: 0,
                        ),
                        createActivity2(
                          context,
                          "self_reflection",
                          "Self",
                          "Reflection",
                          activitySelfReflection(context),
                          "SelfReflection",
                        ),
                        createActivity2(
                          context,
                          "meditation",
                          "Meditation",
                          "",
                          activityMeditation(context),
                          "Meditation",
                          zero: 0,
                        ),
                        createActivity2(
                          context,
                          "memes",
                          "Memes",
                          "",
                          activityMeme(context),
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
