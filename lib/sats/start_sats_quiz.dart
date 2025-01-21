import 'package:flutter_quizzes/flutter_quizzes.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../app_bar.dart';
import 'dart:math' as math;
import '../home.dart';
import '../quiz/quiz_model.dart';

class StartSatsQuiz extends StatefulWidget {
  final SatsQuestionSubcategoriesRW subcategory;

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
      for (var subcategory in SatsQuestionSubcategoriesRW.typesList) {
        List<String> savedScores = prefs.getStringList("${subcategory}_scores",) ?? [];
        double lastScore = savedScores.isNotEmpty ? double.parse(savedScores.last) : 0;
        print("Sats start quiz last score: $lastScore");
        minScore = math.min(minScore, lastScore);
      }
      print("Sats start quiz min score: $minScore");
      SatsQuestionDifficulty difficulty = minScore < 4 ? SatsQuestionDifficulty.difficultyEasy : minScore < 9 ? SatsQuestionDifficulty.difficultyMedium : SatsQuestionDifficulty.difficultyHard;
      SatsQuestionBank questionBank = SatsQuestionBank();
      await questionBank.init();
      questionBank.updateQuestions(widget.subcategory, limit: 5);
      // questionBank.loadFromAssets(widget.subcategory, limit: 5);
      // questionBank.updateQuestionsFromBackend(widget.subcategory, limit: 20);
      questions = await questionBank.getQuestions(widget.subcategory, 5, true, true, difficulty: difficulty);
      print("Updated questions: $questions");
    }();

    return Scaffold(
      appBar: appBar(context, ""),
      body: Container(
        margin: EdgeInsets.only(
          left: size.width / 10,
          right: size.width / 10,
        ),
        child: Stack(
          // mainAxisAlignment: MainAxisAlignment.start,
          // crossAxisAlignment: CrossAxisAlignment.center,
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
                            print("Questions: $questions");
                            return QuizModel(
                              "Exercise",
                              "R&W",
                              900,
                              page: Home(),
                              onEnd: (Map<String, QuizQuestionData> questions, Map<String, bool> answers, bool initialTest, bool endingTest) {
                                SharedPreferences.getInstance().then((prefs) {
                                  Map<String, List<String>> savedQuestionScores = {
                                    for (String questionSubcategory in SatsQuestionSubcategoriesRW.typesList)
                                      questionSubcategory : prefs.getStringList("scores_questions_$questionSubcategory",) ?? [],
                                  };

                                  List<String> savedProgressQuestionScores = prefs.getStringList("scores_questionsLast") ?? List<String>.generate(SatsQuestionSubcategoriesRW.typesList.length, (index) => "-1");
                                  print("previous savedProgressQuestionScores: $savedProgressQuestionScores");

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
                                    print("questionSubcategory: $questionSubcategory ${score >= 0.0 ? "true" : "false"}");
                                    savedProgressQuestionScores[i] = score >= 0.0 ? score.toString() : savedProgressQuestionScores[i];

                                    prefs.setStringList("scores_questions_$questionSubcategory", savedQuestionScores[questionSubcategory]!,);

                                    print("saving savedProgressQuestionScores: $savedProgressQuestionScores");
                                    prefs.setStringList("scores_questionsLast", savedProgressQuestionScores);

                                    print("previous question scores: $savedQuestionScores");
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
                            //   widget.subcategory.string,
                            //   questions,
                            //   300,
                            //   0,
                            // );
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
