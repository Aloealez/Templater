import 'dart:math';

import 'package:brainace_pro/builders/listening_comprehension_builder.dart';
import 'package:brainace_pro/quiz/quiz_model.dart';
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
  late SharedPreferences prefs;
  late Map<String, SatsQuestion> questions;
  final String category = "rw";
  late Future<void> questionsF;

  @override
  void initState() {
    super.initState();
    questionsF = () async {
      prefs = await SharedPreferences.getInstance();
      SatsQuestionBank questionBank = SatsQuestionBank();
      await questionBank.init();
      questions = {};
      questions.addAll(await questionBank.getQuestions(
        SatsQuestionSubcategoriesRW(
          ESatsQuestionSubcategoriesRW.CentralIdeasAndDetails,),
        1,
        true,
        true,
        difficulty: SatsQuestionDifficulty.difficultyEasy,),);
      questions.addAll(await questionBank.getQuestions(
        SatsQuestionSubcategoriesRW(
          ESatsQuestionSubcategoriesRW.CommandOfEvidence,),
        1,
        true,
        true,
        difficulty: SatsQuestionDifficulty.difficultyEasy,),);
      questions.addAll(await questionBank.getQuestions(
        SatsQuestionSubcategoriesRW(
          ESatsQuestionSubcategoriesRW.CrossTextConnections,),
        1,
        true,
        true,
        difficulty: SatsQuestionDifficulty.difficultyEasy,),);
      questions.addAll(await questionBank.getQuestions(
        SatsQuestionSubcategoriesRW(
          ESatsQuestionSubcategoriesRW.FormStructureAndSense,),
        1,
        true,
        true,
        difficulty: SatsQuestionDifficulty.difficultyMedium,),);
      questions.addAll(await questionBank.getQuestions(
        SatsQuestionSubcategoriesRW(ESatsQuestionSubcategoriesRW.Inferences),
        1,
        true,
        true,
        difficulty: SatsQuestionDifficulty.difficultyMedium,),);
      questions.addAll(await questionBank.getQuestions(
        SatsQuestionSubcategoriesRW(
          ESatsQuestionSubcategoriesRW.RhetoricalSynthesis,),
        1,
        true,
        true,
        difficulty: SatsQuestionDifficulty.difficultyMedium,),);
      questions.addAll(await questionBank.getQuestions(
        SatsQuestionSubcategoriesRW(
          ESatsQuestionSubcategoriesRW.TextStructureAndPurpose,),
        1,
        true,
        true,
        difficulty: SatsQuestionDifficulty.difficultyMedium,),);
      questions.addAll(await questionBank.getQuestions(
        SatsQuestionSubcategoriesRW(ESatsQuestionSubcategoriesRW.Transitions),
        1,
        true,
        true,
        difficulty: SatsQuestionDifficulty.difficultyHard,),);
      questions.addAll(await questionBank.getQuestions(
        SatsQuestionSubcategoriesRW(
          ESatsQuestionSubcategoriesRW.WordsInContext,),
        1,
        true,
        true,
        difficulty: SatsQuestionDifficulty.difficultyHard,),);
      questions.addAll(await questionBank.getQuestions(
        SatsQuestionSubcategoriesRW(ESatsQuestionSubcategoriesRW.Boundaries),
        1,
        true,
        true,
        difficulty: SatsQuestionDifficulty.difficultyHard,),);
      if (questions.length < 10) {
        questions = {};
        for (var questionSubcategoryStr
        in SatsQuestionSubcategoriesRW.typesList) {
          var questionSubcategory = SatsQuestionSubcategoriesRW.fromString(
            questionSubcategoryStr,
          );
          await questionBank.loadFromAssets(
            questionSubcategory,
            limit: 5,
          );
          // questionBank.updateQuestionsFromBackend(
          //   questionSubcategory,
          //   limit: 20,
          // );
        }
        questions.addAll(await questionBank.getQuestions(
          SatsQuestionSubcategoriesRW(
            ESatsQuestionSubcategoriesRW.CentralIdeasAndDetails,),
          1,
          true,
          true,
          difficulty: SatsQuestionDifficulty.difficultyEasy,),);
        questions.addAll(await questionBank.getQuestions(
          SatsQuestionSubcategoriesRW(
            ESatsQuestionSubcategoriesRW.CommandOfEvidence,),
          1,
          true,
          true,
          difficulty: SatsQuestionDifficulty.difficultyEasy,),);
        questions.addAll(await questionBank.getQuestions(
          SatsQuestionSubcategoriesRW(
            ESatsQuestionSubcategoriesRW.CrossTextConnections,),
          1,
          true,
          true,
          difficulty: SatsQuestionDifficulty.difficultyEasy,),);
        questions.addAll(await questionBank.getQuestions(
          SatsQuestionSubcategoriesRW(
            ESatsQuestionSubcategoriesRW.FormStructureAndSense,),
          1,
          true,
          true,
          difficulty: SatsQuestionDifficulty.difficultyMedium,),);
        questions.addAll(await questionBank.getQuestions(
          SatsQuestionSubcategoriesRW(
            ESatsQuestionSubcategoriesRW.Inferences,),
          1,
          true,
          true,
          difficulty: SatsQuestionDifficulty.difficultyMedium,),);
        questions.addAll(await questionBank.getQuestions(
          SatsQuestionSubcategoriesRW(
            ESatsQuestionSubcategoriesRW.RhetoricalSynthesis,),
          1,
          true,
          true,
          difficulty: SatsQuestionDifficulty.difficultyMedium,),);
        questions.addAll(await questionBank.getQuestions(
          SatsQuestionSubcategoriesRW(
            ESatsQuestionSubcategoriesRW.TextStructureAndPurpose,),
          1,
          true,
          true,
          difficulty: SatsQuestionDifficulty.difficultyMedium,),);
        questions.addAll(await questionBank.getQuestions(
          SatsQuestionSubcategoriesRW(
            ESatsQuestionSubcategoriesRW.Transitions,),
          1,
          true,
          true,
          difficulty: SatsQuestionDifficulty.difficultyHard,),);
        questions.addAll(await questionBank.getQuestions(
          SatsQuestionSubcategoriesRW(
            ESatsQuestionSubcategoriesRW.WordsInContext,),
          1,
          true,
          true,
          difficulty: SatsQuestionDifficulty.difficultyHard,),);
        questions.addAll(await questionBank.getQuestions(
          SatsQuestionSubcategoriesRW(
            ESatsQuestionSubcategoriesRW.Boundaries,),
          1,
          true,
          true,
          difficulty: SatsQuestionDifficulty.difficultyHard,),);
      }
    }();
  }

  startLevelTest() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String skill = prefs.getString('skill') ?? 'sats';

    var route;
    if (skill == 'sats') {
      route = LevelTest(
        10,
        testRouteBuilder: (BuildContext context, {required bool initialTest, required bool endingTest}) => FutureBuilder(
          future: questionsF,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              return QuizModel(
                "R&W - Exercise {}",
                "R&W",
                900,
                page: Home(),
                initialTest: true,
                onEnd: (Map<String, QuizQuestionData> questions, Map<String, bool> answers, bool initialTest, bool endingTest) {
                  SharedPreferences.getInstance().then((prefs) {
                    Map<String, List<String>> savedQuestionScores = {
                      for (String questionSubcategory in SatsQuestionSubcategoriesRW.typesList)
                        questionSubcategory : prefs.getStringList("scores_questions_$questionSubcategory",) ?? [],
                    };

                    List<String> savedProgressQuestionScores = prefs.getStringList("scores_questionsLast") ?? List<String>.generate(SatsQuestionSubcategoriesRW.typesList.length, (index) => "-1");

                    for (int i = 0; i < SatsQuestionSubcategoriesRW.typesList.length; i++) {
                      String questionSubcategory = SatsQuestionSubcategoriesRW.typesList.elementAt(i);
                      int score = -1;
                      for (String questionId in questions.keys) {
                        if (questions[questionId]!.subcategory?.string == questionSubcategory) {
                          if (answers[questionId] ?? false) {
                            score = score == -1 ? 1 : score + 1;
                          }
                        }
                      }
                      if (score > -1) {
                        savedQuestionScores[questionSubcategory]?.add(score.toString());
                      }
                      savedProgressQuestionScores[i] = score >= 0.0 ? score.toString() : savedProgressQuestionScores[i];

                      prefs.setStringList("scores_questions_$questionSubcategory", savedQuestionScores[questionSubcategory]!,);

                      prefs.setStringList("scores_questionsLast", savedProgressQuestionScores);

                    }
                  });
                },
                description: "The test will comprise of 10 Reading and Writing Questions.",
                exerciseNumber: 0,
                questions: () {
                  Map<String, QuizQuestionData> newQuestions = {};
                  for (int j = 0; j < questions.length; j++) {
                    String i = questions.keys.elementAt(j);
                    newQuestions[i] = QuizQuestionData(
                      {
                        "A": questions[i]!.A,
                        "B": questions[i]!.B,
                        "C": questions[i]!.C,
                        "D": questions[i]!.D,
                      },
                      {
                        "A": questions[i]!.correct == "A",
                        "B": questions[i]!.correct == "B",
                        "C": questions[i]!.correct == "C",
                        "D": questions[i]!.correct == "D",
                      },
                      {
                        "A": questions[i]!.difficulty.getScore(),
                        "B": questions[i]!.difficulty.getScore(),
                        "C": questions[i]!.difficulty.getScore(),
                        "D": questions[i]!.difficulty.getScore(),
                      },
                      introduction: questions[i]?.introduction,
                      text: questions[i]?.text,
                      text2: questions[i]?.text2,
                      question: questions[i]!.question,
                      explanation: questions[i]?.explanation,
                      subcategory: questions[i]?.subcategory,
                      difficulty: questions[i]?.difficulty,
                    );
                  }
                  return newQuestions;
                }(),
                oldName: questions.values.elementAt(0).subcategory!.string,
                exerciseString: questions.values.elementAt(0).subcategory!.string,
              );
              // return SatsQuizRw(
              //   "sat_rw",
              //   questions,
              //   900,
              //   0,
              //   initialTest: true,
              // );
            }
          },
        ),
        initialTest: true,
        testActivitiesDescription: "The test will comprise of 10 Reading and Writing Questions.",
        testScoreDescription: "We will use your score to personalize your app experience.",
      );
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
    // Navigator.pop(context);
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

                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => const ImprovementSelection(),
                //   ),
                // );
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
                  // decoration: TextDecoration.underline,
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
