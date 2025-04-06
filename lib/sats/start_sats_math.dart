import 'package:brainace_pro/quiz/question_bank.dart';
import 'package:flutter_quizzes/flutter_quizzes.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../app_bar.dart';
import 'dart:math' as math;
import '../home.dart';
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
  bool _isVisible = false;
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 170), () {
      setState(() {
        _isVisible = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Future<void> questionsF = () async {
      prefs = await SharedPreferences.getInstance();
      double minScore = 69;
      for (var subcategory in SatsQuestionSubcategories.typesList) {
        List<String> savedScores = prefs.getStringList("${subcategory}_scores",) ?? [];
        double lastScore = savedScores.isNotEmpty ? double.parse(savedScores.last) : 0;
        minScore = math.min(minScore, lastScore);
      }
      SatsQuestionDifficulty difficulty = minScore < 4 ? SatsQuestionDifficulty.difficultyEasy : minScore < 9 ? SatsQuestionDifficulty.difficultyMedium : SatsQuestionDifficulty.difficultyHard;
      QuestionBank questionBank = QuestionBank();
      await questionBank.init();
      questionBank.updateQuestions(widget.subcategory.string, limit: 4);
      questions = await questionBank.getQuestions(widget.subcategory.string, 4, true, true, difficulty: difficulty);
      for (int i = 0; i < questions.length; i++) {
        questions[questions.keys.elementAt(i)]!.subcategory = widget.subcategory;
      }
      print("got questions: ${questions.length}");
    }();

    return Scaffold(
      appBar: appBar(context, ""),
      body: Container(
        margin: EdgeInsets.only(
          left: size.width / 10,
          right: size.width / 10,
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment(0, -0.85),
              child: AnimatedOpacity(
                opacity: _isVisible ? 1.0 : 0.0,
                duration: Duration(milliseconds: 370),
                child: Padding(
                  padding: EdgeInsets.only(
                    left: size.width / 10,
                    right: size.width / 10,
                  ),
                  child: Text(
                    widget.subcategory.getName(),
                    style: TextStyle(fontSize: 0.039 * size.height),
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment(0, -0.1),
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FutureBuilder(
                        future: questionsF,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else {
                            return MathQuizModel(
                              "Exercise 1 - Math",  // 1) tytuł
                              "Math",               // 2) exerciseName
                              300,                  // 3) czas w sekundach
                              page: Home(),
                              onEnd: (Map<String, QuizQuestionData> questions, Map<String, bool> answers, bool initialTest, bool endingTest) {
                                SharedPreferences.getInstance().then((prefs) {
                                  Map<String, List<String>> savedQuestionScores = {
                                    for (String questionSubcategory in SatsQuestionSubcategories.typesList)
                                      questionSubcategory : prefs.getStringList("scores_questions_$questionSubcategory",) ?? [],
                                  };

                                  List<String> savedProgressQuestionScores = prefs.getStringList("scores_questionsLast") ?? List<String>.generate(SatsQuestionSubcategories.typesList.length, (index) => "-1");

                                  for (int i = 0; i < SatsQuestionSubcategories.typesList.length; i++) {
                                    String questionSubcategory = SatsQuestionSubcategories.typesList.elementAt(i);
                                    int score = -1;
                                    for (String questionId in questions.keys) {
                                      print("question subcategory: ${questions[questionId]!.subcategory?.string}   $questionSubcategory");
                                      if (questions[questionId]!.subcategory?.string == questionSubcategory) {
                                        print("Answers: $answers");
                                        if (answers[questionId] ?? false) {
                                          score = score == -1 ? 1 : score + 1;
                                          print("Score: $score");
                                        }
                                      }
                                    }
                                    if (score > -1) {
                                      savedQuestionScores[questionSubcategory]?.add(score.toString());
                                    }
                                    print("Before: $questionSubcategory, $score");
                                    savedProgressQuestionScores[i] = score >= 0.0 ? score.toString() : savedProgressQuestionScores[i];
                                    print("After: $questionSubcategory, ${savedProgressQuestionScores[i]}");

                                    prefs.setStringList("scores_questions_$questionSubcategory", savedQuestionScores[questionSubcategory]!,);

                                    prefs.setStringList("scores_questionsLast", savedProgressQuestionScores);
                                  }
                                });
                              },
                              description: "The test will comprise of 10 Reading and Writing Questions.",
                              exerciseNumber: 0,
                              questions: questions,
                              oldName: questions.values.elementAt(0).subcategoryStr!,
                              exerciseString: questions.values.elementAt(0).subcategoryStr!,
                            );
                          }
                        },
                      ),
                    ),
                  );
                },
                child: Image.asset(
                  width: size.width * 0.7,
                  'assets/sats/start_images/${widget.subcategory.string}.png',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
