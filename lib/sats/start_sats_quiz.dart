import 'package:flutter_quizzes/flutter_quizzes.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math' as math;
import '../home.dart';
import '../quiz/math_quiz_model.dart';

class StartSatsQuiz extends StatefulWidget {
  final SatsQuestionSubcategories subcategory;

  const StartSatsQuiz({
    required this.subcategory,
    super.key,
  });

  @override
  State<StartSatsQuiz> createState() => _StartSatsQuiz();
}

class _StartSatsQuiz extends State<StartSatsQuiz> {
  late Map<String, SatsQuestion> questions;
  bool _isVisible = false;
  late SharedPreferences prefs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    Future<void> questionsF = () async {
      prefs = await SharedPreferences.getInstance();
      double minScore = 69;
      for (var subcategory in SatsQuestionSubcategories.typesList) {
        List<String> savedScores = prefs.getStringList(
              "${subcategory}_scores",
            ) ??
            <String>[];
        [];
        double lastScore =
            savedScores.isNotEmpty ? double.parse(savedScores.last) : 0;
        minScore = math.min(minScore, lastScore);
      }
      SatsQuestionDifficulty difficulty = minScore < 4
          ? SatsQuestionDifficulty.difficultyEasy
          : minScore < 9
              ? SatsQuestionDifficulty.difficultyMedium
              : SatsQuestionDifficulty.difficultyHard;
      SatsQuestionBank questionBank = SatsQuestionBank();
      await questionBank.init();
      questionBank.updateQuestions(widget.subcategory, limit: 5);
      questions = await questionBank.getQuestions(
          widget.subcategory, 5, true, true,
          difficulty: difficulty,);

      // Navigate after fetching questions
      if (mounted) {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MathQuizModel(
              "Exercise",
              "R&W",
              300,
              htmlFormat: 0,
              page: Home(),
              onEnd: (Map<String, QuizQuestionData> questions,
                  Map<String, bool> answers,
                  bool initialTest,
                  bool endingTest,) {
                SharedPreferences.getInstance().then((prefs) {
                  Map<String, List<String>> savedQuestionScores = {
                    for (String questionSubcategory
                        in SatsQuestionSubcategories.typesList)
                      questionSubcategory: prefs.getStringList(
                            "scores_questions_$questionSubcategory",
                          ) ??
                          [],
                  };

                  List<String> savedProgressQuestionScores =
                      prefs.getStringList("scores_questionsLast") ??
                          List<String>.generate(
                            SatsQuestionSubcategories.typesList.length,
                            (index) => "-1",
                          );

                  for (int i = 0;
                      i < SatsQuestionSubcategories.typesList.length;
                      i++) {
                    String questionSubcategory =
                        SatsQuestionSubcategories.typesList.elementAt(i);
                    int score = -1;
                    for (String questionId in questions.keys) {
                      if (questions[questionId]!.subcategory?.string ==
                          questionSubcategory) {
                        if (answers[questionId] ?? false) {
                          score = score == -1 ? 1 : score + 1;
                        }
                      }
                    }
                    if (score > -1) {
                      savedQuestionScores[questionSubcategory]
                          ?.add(score.toString());
                    }
                    savedProgressQuestionScores[i] = score >= 0.0
                        ? score.toString()
                        : savedProgressQuestionScores[i];

                    prefs.setStringList(
                      "scores_questions_$questionSubcategory",
                      savedQuestionScores[questionSubcategory]!,
                    );

                    prefs.setStringList(
                        "scores_questionsLast", savedProgressQuestionScores,);
                  }
                });
              },
              description:
                  "The test will comprise of 10 Reading and Writing Questions.",
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
            ),
          ),
        );
      }
    }();

    Future.delayed(Duration(milliseconds: 170), () {
      setState(() {
        _isVisible = true;
      });
    });
  }
}
