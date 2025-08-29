import 'package:brainace_pro/activities/math_activities.dart';
import 'package:brainace_pro/quiz/question_bank.dart';
import 'package:flutter_quizzes/flutter_quizzes.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math' as math;
import '../quiz/math_quiz_model.dart';

class StartSatsMath extends StatefulWidget {
  final SatsQuestionSubcategories subcategory;

  const StartSatsMath({
    required this.subcategory,
    super.key,
  });

  @override
  State<StartSatsMath> createState() => _StartSatsMathState();
}

class _StartSatsMathState extends State<StartSatsMath> {
  late Map<String, QuizQuestionData> questions;
  final bool _isVisible = false;
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      prefs = await SharedPreferences.getInstance();
      double minScore = 69;
      for (var subcategory in SatsQuestionSubcategories.typesList) {
        List<String> savedScores = prefs.getStringList(
              '${subcategory}_scores',
            ) ??
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
      QuestionBank questionBank = QuestionBank();
      await questionBank.init();
      questionBank.updateQuestions(widget.subcategory.string, limit: 4);
      questions = await questionBank.getQuestions(
          widget.subcategory.string, 4, true, true,
          difficulty: difficulty,);
      for (int i = 0; i < questions.length; i++) {
        questions[questions.keys.elementAt(i)]!.subcategory =
            widget.subcategory;
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MathQuizModel(
            'Exercise 1 - Math', // Title
            'Math', // Exercise Name
            300, // Time in seconds
            page: MathActivities(),
            onEnd: (Map<String, QuizQuestionData> questions,
                Map<String, bool> answers, bool initialTest, bool endingTest,) {
              SharedPreferences.getInstance().then((prefs) {
                Map<String, List<String>> savedQuestionScores = {
                  for (String questionSubcategory
                      in SatsQuestionSubcategories.typesList)
                    questionSubcategory: prefs.getStringList(
                          'scores_questions_$questionSubcategory',
                        ) ??
                        [],
                };

                List<String> savedProgressQuestionScores = prefs.getStringList(
                      'scores_questionsLast',
                    ) ??
                    List<String>.generate(
                      SatsQuestionSubcategories.typesList.length,
                      (index) => '-1',
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
                    'scores_questions_$questionSubcategory',
                    savedQuestionScores[questionSubcategory]!,
                  );

                  prefs.setStringList(
                      'scores_questionsLast', savedProgressQuestionScores,);
                }
              });
            },
            description:
                'The test will comprise of 10 Reading and Writing Questions.',
            exerciseNumber: 0,
            questions: questions,
            oldName: questions.values.elementAt(0).subcategoryStr!,
            exerciseString: questions.values.elementAt(0).subcategoryStr!,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
