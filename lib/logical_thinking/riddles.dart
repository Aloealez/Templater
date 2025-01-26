import 'package:brainace_pro/level_instruction.dart';
import 'package:brainace_pro/memory/memory_game1.dart';
import 'package:brainace_pro/quiz/quiz_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yaml/yaml.dart';
import 'package:flutter_quizzes/flutter_quizzes.dart';
import '../memory/memory_game2.dart';
import '../score_n_progress/progress_screen.dart';
import 'package:brainace_pro/buttons.dart';
import 'dart:async';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import '/home.dart';
import '../app_bar.dart';
import '../title_page.dart';

class RiddlesTest extends StatefulWidget {
  const RiddlesTest({
    super.key,
    this.initialTest = false,
    this.endingTest = false,
  });

  final bool initialTest;
  final bool endingTest;

  static RiddlesTest routeBuilder(
    BuildContext context, {
    required bool initialTest,
    required bool endingTest,
  }) {
    return RiddlesTest(
      initialTest: initialTest,
      endingTest: endingTest,
    );
  }

  @override
  State<RiddlesTest> createState() => _RiddlesTest();
}

class _RiddlesTest extends State<RiddlesTest> {
  double score = 0;
  int selectedOption = -1, questionIndex = 0;
  List<int> correctAnswers = [];
  List<String> questions = [];
  List<List<String>> answers = [];
  int numberOfQuestions = 0;
  int difficulty = 3;
  int passed = 0;
  late SharedPreferences prefs;
  dynamic tasks;

  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
    if ((prefs.getInt('riddles_difficulty')) != null) {
      difficulty = prefs.getInt('riddles_difficulty')!;
    }
    readData();

    numberOfQuestions = (difficulty == 3 ? 25 : (difficulty == 4 ? 25 : 23));
    questionIndex = Random().nextInt(numberOfQuestions);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  void readData() async {
    try {
      List<String> newQuestions = [];
      List<int> newCorrectAnswers = [];
      List<List<String>> newAnswers = [];
      final file = await rootBundle.loadString('assets/logical_thinking/riddles.yaml');
      tasks = loadYaml(file)["questions"]["${difficulty}points"];
      for (var i = 0; i < tasks.length; i++) {
        newQuestions.add(tasks[i]["question"]);

        newCorrectAnswers.add(tasks[i]["correct_answer"]);

        newAnswers.add([]);
        for (var answer in tasks[i]["answers"]) {
          newAnswers[newAnswers.length - 1].add(answer.toString());
        }
      }

      setState(() {
        correctAnswers = newCorrectAnswers;
        questions = newQuestions;
        answers = newAnswers;
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> write(int add) async {
    prefs = await SharedPreferences.getInstance();
    if ((prefs.getInt('riddles_streak')) == null) {
      await prefs.setInt('riddles_streak', 0);
    }
    await prefs.setInt(
      'riddles_streak',
      prefs.getInt('riddles_streak')! + add,
    );
    if ((prefs.getInt('riddles_difficulty')) == null) {
      await prefs.setInt('riddles_difficulty', 3);
    }
    if ((prefs.getInt('riddles_streak')!) >= 6 && (prefs.getInt('riddles_difficulty')!) < 5) {
      await prefs.setInt(
        'riddles_difficulty',
        prefs.getInt('riddles_difficulty')! + 1,
      );
      await prefs.setInt('riddles_streak', 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return tasks == null
        ? const Center(child: CircularProgressIndicator())
        : LevelInstruction(
        "Riddles",
        testTime: 4,
        testActivitiesDescription: "In this exercise, you will be given a series of riddles to solve. You will have 4 minutes.",
        testScoreDescription: "For each correct answer you get 5 points, and for each wrong answer you will loose 2 points.",
        nextRouteBuilder: FutureBuilder(future: () async {} (), builder:
          (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
              return QuizModel(
                "Riddles - {}",
                "Riddles",
                240,
                initialTest: widget.initialTest,
                endingTest: widget.endingTest,
                singleTextQuestion: true,
                initScore: 0,
                initMaxScore: 0,
                page: widget.initialTest
                    ? const Home()
                    : widget.endingTest
                    ? const TitlePage(
                  title: "BrainAce.pro",
                )
                    : const Home(),
                description: "Exercise 1 - Short Term Concentration",
                oldName: "long_term_concentration",
                exerciseNumber: 1,
                exerciseString: "Riddles",
                questions: {
                  for (int i = 0; i < numberOfQuestions; ++i)
                    "$i": () {
                      Map<String, String> answers = {};
                      answers = {
                        "A": tasks[i]["answers"][0].toString(),
                        "B": tasks[i]["answers"][1].toString(),
                        if (tasks[i]["answers"].length >= 3) "C": tasks[i]["answers"][2].toString(),
                        if (tasks[i]["answers"].length >= 4) "D": tasks[i]["answers"][3].toString(),
                      };
                      Map<String, bool> correct = {
                        "A": tasks[i]["correct_answer"] == 0,
                        "B": tasks[i]["correct_answer"] == 1,
                        "C": tasks[i]["correct_answer"] == 2,
                        "D": tasks[i]["correct_answer"] == 3,
                      };
                      return QuizQuestionData(
                        answers,
                        correct,
                        {
                          for (var key in answers.keys) key: 5,
                        },
                        scoreIncorrect: {
                          for (var key in answers.keys) key: -2,
                        },
                        question: "${tasks[i]["question"]}",
                      );
                    }(),
                },
              );
          },
        ),
        testRouteBuilder: MemoryGame2.routeBuilder,
    );

    Size size = MediaQuery.of(context).size;

    return questions.isEmpty & answers.isEmpty & correctAnswers.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            appBar: appBar(context, ""),
            body: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.only(
                  left: size.width / 15,
                  right: size.width / 15,
                  bottom: size.height / 20,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Align(
                            alignment: Alignment.center,
                            child: Column(
                              children: [
                                Text(
                                  "Logical",
                                  style: TextStyle(fontSize: 0.07 * size.height),
                                ),
                                Text(
                                  "Thinking",
                                  style: TextStyle(fontSize: 0.035 * size.height),
                                ),
                                SizedBox(height: 0.02 * size.height),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Exercise 2 -  Math riddles",
                                      style: TextStyle(
                                        fontSize: 0.043 * size.width,
                                      ),
                                    ),
                                    SizedBox(width: 0.05 * size.width),
                                    Icon(
                                      Icons.timer,
                                      size: 0.08 * min(size.width, size.height),
                                      color: Theme.of(context).colorScheme.primary,
                                    ),
                                    const SizedBox(width: 8),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 0.05 * size.height),
                          Text(
                            questions[questionIndex],
                            style: TextStyle(fontSize: 0.02 * size.height),
                          ),
                          SizedBox(height: 0.02 * size.height),
                        ],
                      ),
                      Column(
                        children: [
                          SizedBox(height: 0.04 * size.height),
                          SizedBox(
                            height: size.height * 0.05,
                            width: size.width * 0.75,
                            child: RedirectButton(
                              onClick: () {
                                if (selectedOption == -1) return;

                                if (selectedOption == correctAnswers[questionIndex]) {
                                  score += 5;
                                } else {
                                  score -= 2;
                                }

                                if (passed < 1 || widget.initialTest || widget.endingTest) {
                                  passed += 1;
                                  setState(() {
                                    questionIndex = Random().nextInt(numberOfQuestions);
                                    selectedOption = -1;
                                  });
                                  return;
                                }
                                write((score.toInt() == 10) ? 1 : 0);
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProgressScreen(
                                      name: "long_term_concentration",
                                      userScore: score,
                                      maxScore: 10,
                                      exercise: 'Riddles',
                                    ),
                                  ),
                                );
                              },
                              text: 'Continue',
                              width: size.width,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
