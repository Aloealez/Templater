import 'package:brainace_pro/quiz/math_quiz_model.dart';
import 'package:brainace_pro/quiz/question_bank.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quizzes/flutter_quizzes.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../app_bar.dart';
import '../home.dart';
import '../level_test.dart';
import '../quiz/quiz_model.dart';

class SatsProgramButton extends StatefulWidget {
  final String text;
  final double height;
  final Color color;
  final String name;
  final Function onTap;

  const SatsProgramButton({
    super.key,
    required this.text,
    required this.height,
    required this.name,
    required this.color,
    required this.onTap,
  });

  @override
  State<SatsProgramButton> createState() => _SatsProgramButtonState();
}

class _SatsProgramButtonState extends State<SatsProgramButton> {
  bool hovered = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    late SharedPreferences prefs;
    return SizedBox(
      height: widget.height,
      width: size.width * 0.9,
      child: InkWell(
        onHover: (value) {
          setState(() {
            hovered = value;
          });
        },
        onTap: () {
          widget.onTap();

          Future<void> initMemory() async {
            prefs = await SharedPreferences.getInstance();
            prefs.setString(
              'skill_sats',
              widget.name,
            );
          }

          initMemory();
          // Navigator.push(
          //   context,
          //   PageTransition(
          //     type: PageTransitionType.fade,
          //     child: LanguageLevelSelection(),
          //     reverseDuration: const Duration(milliseconds: 100),
          //     opaque: true,
          //   ),
          // );
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: widget.color,
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.shadow,
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(5, 5),
              ),
            ],
          ),
          child: Center(
            child: Text(
              widget.text,
              style: TextStyle(
                fontSize: size.width / 20,
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
      ),
    );
  }
}

class SatsProgramSelection extends StatefulWidget {
  const SatsProgramSelection({super.key});

  @override
  State<SatsProgramSelection> createState() => _SatsProgramSelectionState();
}

class _SatsProgramSelectionState extends State<SatsProgramSelection> {
  bool startedLevelTest = false;
  late SharedPreferences prefs;
  final String category = "rw";
  Future<void>? questionsF;
  late Map<String, QuizQuestionData> questions;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: appBar(context, ""),
      body: Center(
        child: startedLevelTest
            ? Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              )
            : Container(
                margin: EdgeInsets.only(
                  left: size.width / 10,
                  right: size.width / 10,
                  top: size.height / 35,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: size.width * 0.085,
                          decoration: TextDecoration.none,
                          fontWeight: FontWeight.w700,
                        ),
                        children: [
                          TextSpan(text: 'Choose Sections\nTo Prepare For'),
                        ],
                      ),
                    ),
                    SizedBox(height: size.height * 0.08),
                    SatsProgramButton(
                      text: "Both Sections",
                      height: size.height * 0.07,
                      color: Theme.of(context).colorScheme.tertiary,
                      name: "both",
                      onTap: () {
                        setState(() {
                          startedLevelTest = true;
                        });
                        questionsF = () async {
                          prefs = await SharedPreferences.getInstance();
                          QuestionBank questionBank = QuestionBank();
                          await questionBank.init();
                          questions = {};
                          for (var questionSubcategoryStr
                              in SatsQuestionSubcategories.typesList
                                  .sublist(10)) {
                            var questionSubcategory =
                                SatsQuestionSubcategories.fromString(
                              questionSubcategoryStr,
                            );
                            await questionBank.loadFromAssets(
                              questionSubcategory.string,
                              limit: 4,
                            );
                          }
                          questions.addAll(
                            await questionBank.getQuestions(
                              SatsQuestionSubcategories(
                                ESatsQuestionSubcategories
                                    .NonlinearEquationsInOneVariableAndSystemsOfEquationsInTwoVariables,
                              ).string,
                              1,
                              true,
                              true,
                              difficulty: SatsQuestionDifficulty.difficultyEasy,
                            ),
                          );
                          questions.addAll(
                            await questionBank.getQuestions(
                              SatsQuestionSubcategories(
                                ESatsQuestionSubcategories.Percentages,
                              ).string,
                              1,
                              true,
                              true,
                              difficulty: SatsQuestionDifficulty.difficultyEasy,
                            ),
                          );
                          questions.addAll(
                            await questionBank.getQuestions(
                              SatsQuestionSubcategories(
                                ESatsQuestionSubcategories.Circles,
                              ).string,
                              1,
                              true,
                              true,
                              difficulty: SatsQuestionDifficulty.difficultyEasy,
                            ),
                          );
                          questions.addAll(
                            await questionBank.getQuestions(
                              SatsQuestionSubcategories(
                                ESatsQuestionSubcategories
                                    .RightTrianglesAndTrigonometry,
                              ).string,
                              1,
                              true,
                              true,
                              difficulty:
                                  SatsQuestionDifficulty.difficultyMedium,
                            ),
                          );
                          questions.addAll(
                            await questionBank.getQuestions(
                              SatsQuestionSubcategories(
                                ESatsQuestionSubcategories.AreaAndVolume,
                              ).string,
                              1,
                              true,
                              true,
                              difficulty:
                                  SatsQuestionDifficulty.difficultyMedium,
                            ),
                          );

                          Map<String, SatsQuestion> tempQuestions = {};
                          SatsQuestionBank satsQuestionBank =
                              SatsQuestionBank();
                          await satsQuestionBank.init();
                          for (var questionSubcategoryStr
                              in SatsQuestionSubcategories.typesList
                                  .sublist(0, 10)) {
                            var questionSubcategory =
                                SatsQuestionSubcategories.fromString(
                              questionSubcategoryStr,
                            );
                            await satsQuestionBank.loadFromAssets(
                              questionSubcategory,
                              limit: 5,
                            );
                          }
                          tempQuestions.addAll(
                            await satsQuestionBank.getQuestions(
                              SatsQuestionSubcategories(
                                ESatsQuestionSubcategories
                                    .CentralIdeasAndDetails,
                              ),
                              1,
                              true,
                              true,
                              difficulty: SatsQuestionDifficulty.difficultyEasy,
                            ),
                          );
                          tempQuestions.addAll(
                            await satsQuestionBank.getQuestions(
                              SatsQuestionSubcategories(
                                ESatsQuestionSubcategories.CrossTextConnections,
                              ),
                              1,
                              true,
                              true,
                              difficulty: SatsQuestionDifficulty.difficultyEasy,
                            ),
                          );
                          tempQuestions.addAll(
                            await satsQuestionBank.getQuestions(
                              SatsQuestionSubcategories(
                                ESatsQuestionSubcategories
                                    .TextStructureAndPurpose,
                              ),
                              1,
                              true,
                              true,
                              difficulty:
                                  SatsQuestionDifficulty.difficultyMedium,
                            ),
                          );
                          tempQuestions.addAll(
                            await satsQuestionBank.getQuestions(
                              SatsQuestionSubcategories(
                                ESatsQuestionSubcategories.Transitions,
                              ),
                              1,
                              true,
                              true,
                              difficulty: SatsQuestionDifficulty.difficultyHard,
                            ),
                          );
                          tempQuestions.addAll(
                            await satsQuestionBank.getQuestions(
                              SatsQuestionSubcategories(
                                ESatsQuestionSubcategories.WordsInContext,
                              ),
                              1,
                              true,
                              true,
                              difficulty: SatsQuestionDifficulty.difficultyHard,
                            ),
                          );
                          print("mixed questions rw: ${tempQuestions.length}");
                          for (int j = 0; j < tempQuestions.length; j++) {
                            String i = tempQuestions.keys.elementAt(j);
                            questions[i] = QuizQuestionData(
                              {
                                "A": tempQuestions[i]!.A,
                                "B": tempQuestions[i]!.B,
                                "C": tempQuestions[i]!.C,
                                "D": tempQuestions[i]!.D,
                              },
                              {
                                "A": tempQuestions[i]!.correct == "A",
                                "B": tempQuestions[i]!.correct == "B",
                                "C": tempQuestions[i]!.correct == "C",
                                "D": tempQuestions[i]!.correct == "D",
                              },
                              {
                                "A": tempQuestions[i]!.difficulty.getScore(),
                                "B": tempQuestions[i]!.difficulty.getScore(),
                                "C": tempQuestions[i]!.difficulty.getScore(),
                                "D": tempQuestions[i]!.difficulty.getScore(),
                              },
                              introduction: tempQuestions[i]?.introduction,
                              text: tempQuestions[i]?.text,
                              text2: tempQuestions[i]?.text2,
                              question: tempQuestions[i]!.question,
                              explanation: tempQuestions[i]?.explanation,
                              subcategory: tempQuestions[i]?.subcategory,
                              difficulty: tempQuestions[i]?.difficulty,
                            );
                          }
                        }();
                        Navigator.of(context).push(
                          PageTransition(
                            type: PageTransitionType.fade,
                            child: LevelTest(
                              15,
                              testRouteBuilder: (BuildContext context,
                                      {required bool initialTest,
                                      required bool endingTest,}) =>
                                  FutureBuilder(
                                future: questionsF,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  } else {
                                    return MathQuizModel(
                                      "Sats - Exercise {}",
                                      "Sats",
                                      900,
                                      page: Home(),
                                      initialTest: true,
                                      onEnd: (Map<String, QuizQuestionData>
                                              questions,
                                          Map<String, bool> answers,
                                          bool initialTest,
                                          bool endingTest,) {
                                        SharedPreferences.getInstance()
                                            .then((prefs) {
                                          Map<String, List<String>>
                                              savedQuestionScores = {
                                            for (String questionSubcategory
                                                in SatsQuestionSubcategories
                                                    .typesList)
                                              questionSubcategory:
                                                  prefs.getStringList(
                                                        "scores_questions_$questionSubcategory",
                                                      ) ??
                                                      [],
                                          };

                                          List<String>
                                              savedProgressQuestionScores =
                                              prefs.getStringList(
                                                      "scores_questionsLast",) ??
                                                  List<String>.generate(
                                                      SatsQuestionSubcategories
                                                          .typesList.length,
                                                      (index) => "-1",);

                                          for (int i = 0;
                                              i <
                                                  SatsQuestionSubcategories
                                                      .typesList.length;
                                              i++) {
                                            String questionSubcategory =
                                                SatsQuestionSubcategories
                                                    .typesList
                                                    .elementAt(i);
                                            int score = -1;
                                            for (String questionId
                                                in questions.keys) {
                                              if (questions[questionId]!
                                                      .subcategory
                                                      ?.string ==
                                                  questionSubcategory) {
                                                if (answers[questionId] ??
                                                    false) {
                                                  score = score == -1
                                                      ? 1
                                                      : score + 1;
                                                }
                                              }
                                            }
                                            if (score > -1) {
                                              savedQuestionScores[
                                                      questionSubcategory]
                                                  ?.add(score.toString());
                                            }
                                            savedProgressQuestionScores[
                                                i] = score >=
                                                    0.0
                                                ? score.toString()
                                                : savedProgressQuestionScores[
                                                    i];

                                            prefs.setStringList(
                                              "scores_questions_$questionSubcategory",
                                              savedQuestionScores[
                                                  questionSubcategory]!,
                                            );

                                            prefs.setStringList(
                                                "scores_questionsLast",
                                                savedProgressQuestionScores,);
                                          }
                                        });
                                      },
                                      htmlFormat: 5,
                                      description:
                                          "The test will comprise of 5 Math, and 5 Reading and Writing Questions.",
                                      exerciseNumber: 0,
                                      questions: questions,
                                      oldName: questions.values
                                          .elementAt(0)
                                          .subcategoryStr!,
                                      exerciseString: questions.values
                                          .elementAt(0)
                                          .subcategoryStr!,
                                    );
                                  }
                                },
                              ),
                              initialTest: true,
                              testActivitiesDescription:
                                  "The test will comprise of 5 Reading and Writing Questions, and 5 Math Questions.\n\nYou can use the graphic calculator.",
                              testScoreDescription:
                                  "We will use your score to personalize your app experience.",
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: size.height / 30),
                    SatsProgramButton(
                      text: "Only Reading &\nWriting Section",
                      height: size.height * 0.1,
                      color: Theme.of(context).colorScheme.secondary,
                      name: "rw",
                      onTap: () {
                        setState(() {
                          startedLevelTest = true;
                        });
                        Map<String, SatsQuestion> tempQuestions = {};
                        questionsF = () async {
                          prefs = await SharedPreferences.getInstance();
                          SatsQuestionBank questionBank = SatsQuestionBank();
                          await questionBank.init();
                          questions = {};
                          for (var questionSubcategoryStr
                              in SatsQuestionSubcategories.typesList
                                  .sublist(0, 10)) {
                            var questionSubcategory =
                                SatsQuestionSubcategories.fromString(
                              questionSubcategoryStr,
                            );
                            await questionBank.loadFromAssets(
                              questionSubcategory,
                              limit: 5,
                            );
                          }
                          tempQuestions.addAll(
                            await questionBank.getQuestions(
                              SatsQuestionSubcategories(
                                ESatsQuestionSubcategories
                                    .CentralIdeasAndDetails,
                              ),
                              1,
                              true,
                              true,
                              difficulty: SatsQuestionDifficulty.difficultyEasy,
                            ),
                          );
                          tempQuestions.addAll(
                            await questionBank.getQuestions(
                              SatsQuestionSubcategories(
                                ESatsQuestionSubcategories.CommandOfEvidence,
                              ),
                              1,
                              true,
                              true,
                              difficulty: SatsQuestionDifficulty.difficultyEasy,
                            ),
                          );
                          tempQuestions.addAll(
                            await questionBank.getQuestions(
                              SatsQuestionSubcategories(
                                ESatsQuestionSubcategories.CrossTextConnections,
                              ),
                              1,
                              true,
                              true,
                              difficulty: SatsQuestionDifficulty.difficultyEasy,
                            ),
                          );
                          tempQuestions.addAll(
                            await questionBank.getQuestions(
                              SatsQuestionSubcategories(
                                ESatsQuestionSubcategories
                                    .FormStructureAndSense,
                              ),
                              1,
                              true,
                              true,
                              difficulty:
                                  SatsQuestionDifficulty.difficultyMedium,
                            ),
                          );
                          tempQuestions.addAll(
                            await questionBank.getQuestions(
                              SatsQuestionSubcategories(
                                ESatsQuestionSubcategories.Inferences,
                              ),
                              1,
                              true,
                              true,
                              difficulty:
                                  SatsQuestionDifficulty.difficultyMedium,
                            ),
                          );
                          tempQuestions.addAll(
                            await questionBank.getQuestions(
                              SatsQuestionSubcategories(
                                ESatsQuestionSubcategories.RhetoricalSynthesis,
                              ),
                              1,
                              true,
                              true,
                              difficulty:
                                  SatsQuestionDifficulty.difficultyMedium,
                            ),
                          );
                          tempQuestions.addAll(
                            await questionBank.getQuestions(
                              SatsQuestionSubcategories(
                                ESatsQuestionSubcategories
                                    .TextStructureAndPurpose,
                              ),
                              1,
                              true,
                              true,
                              difficulty:
                                  SatsQuestionDifficulty.difficultyMedium,
                            ),
                          );
                          tempQuestions.addAll(
                            await questionBank.getQuestions(
                              SatsQuestionSubcategories(
                                ESatsQuestionSubcategories.Transitions,
                              ),
                              1,
                              true,
                              true,
                              difficulty: SatsQuestionDifficulty.difficultyHard,
                            ),
                          );
                          tempQuestions.addAll(
                            await questionBank.getQuestions(
                              SatsQuestionSubcategories(
                                ESatsQuestionSubcategories.WordsInContext,
                              ),
                              1,
                              true,
                              true,
                              difficulty: SatsQuestionDifficulty.difficultyHard,
                            ),
                          );
                          tempQuestions.addAll(
                            await questionBank.getQuestions(
                              SatsQuestionSubcategories(
                                ESatsQuestionSubcategories.Boundaries,
                              ),
                              1,
                              true,
                              true,
                              difficulty: SatsQuestionDifficulty.difficultyHard,
                            ),
                          );
                          for (int j = 0; j < tempQuestions.length; j++) {
                            String i = tempQuestions.keys.elementAt(j);
                            questions[i] = QuizQuestionData(
                              {
                                "A": tempQuestions[i]!.A,
                                "B": tempQuestions[i]!.B,
                                "C": tempQuestions[i]!.C,
                                "D": tempQuestions[i]!.D,
                              },
                              {
                                "A": tempQuestions[i]!.correct == "A",
                                "B": tempQuestions[i]!.correct == "B",
                                "C": tempQuestions[i]!.correct == "C",
                                "D": tempQuestions[i]!.correct == "D",
                              },
                              {
                                "A": tempQuestions[i]!.difficulty.getScore(),
                                "B": tempQuestions[i]!.difficulty.getScore(),
                                "C": tempQuestions[i]!.difficulty.getScore(),
                                "D": tempQuestions[i]!.difficulty.getScore(),
                              },
                              introduction: tempQuestions[i]?.introduction,
                              text: tempQuestions[i]?.text,
                              text2: tempQuestions[i]?.text2,
                              question: tempQuestions[i]!.question,
                              explanation: tempQuestions[i]?.explanation,
                              subcategory: tempQuestions[i]?.subcategory,
                              difficulty: tempQuestions[i]?.difficulty,
                            );
                          }
                        }();
                        Navigator.of(context).push(
                          PageTransition(
                            type: PageTransitionType.fade,
                            child: LevelTest(
                              15,
                              testRouteBuilder: (BuildContext context,
                                      {required bool initialTest,
                                      required bool endingTest,}) =>
                                  FutureBuilder(
                                future: questionsF,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                        child: CircularProgressIndicator(),);
                                  } else {
                                    return QuizModel(
                                      "R&W - Exercise {}",
                                      "R&W",
                                      900,
                                      page: Home(),
                                      initialTest: true,
                                      onEnd: (Map<String, QuizQuestionData>
                                              questions,
                                          Map<String, bool> answers,
                                          bool initialTest,
                                          bool endingTest,) {
                                        SharedPreferences.getInstance()
                                            .then((prefs) {
                                          Map<String, List<String>>
                                              savedQuestionScores = {
                                            for (String questionSubcategory
                                                in SatsQuestionSubcategories
                                                    .typesList)
                                              questionSubcategory:
                                                  prefs.getStringList(
                                                        "scores_questions_$questionSubcategory",
                                                      ) ??
                                                      [],
                                          };

                                          List<String>
                                              savedProgressQuestionScores =
                                              prefs.getStringList(
                                                      "scores_questionsLast",) ??
                                                  List<String>.generate(
                                                      SatsQuestionSubcategories
                                                          .typesList.length,
                                                      (index) => "-1",);

                                          for (int i = 0;
                                              i <
                                                  SatsQuestionSubcategories
                                                      .typesList.length;
                                              i++) {
                                            String questionSubcategory =
                                                SatsQuestionSubcategories
                                                    .typesList
                                                    .elementAt(i);
                                            int score = -1;
                                            for (String questionId
                                                in questions.keys) {
                                              if (questions[questionId]!
                                                      .subcategory
                                                      ?.string ==
                                                  questionSubcategory) {
                                                if (answers[questionId] ??
                                                    false) {
                                                  score = score == -1
                                                      ? 1
                                                      : score + 1;
                                                }
                                              }
                                            }
                                            if (score > -1) {
                                              savedQuestionScores[
                                                      questionSubcategory]
                                                  ?.add(score.toString());
                                            }
                                            savedProgressQuestionScores[
                                                i] = score >=
                                                    0.0
                                                ? score.toString()
                                                : savedProgressQuestionScores[
                                                    i];

                                            prefs.setStringList(
                                              "scores_questions_$questionSubcategory",
                                              savedQuestionScores[
                                                  questionSubcategory]!,
                                            );

                                            prefs.setStringList(
                                                "scores_questionsLast",
                                                savedProgressQuestionScores,);
                                          }
                                        });
                                      },
                                      description:
                                          "The test will comprise of 10 Reading and Writing Questions.",
                                      exerciseNumber: 0,
                                      questions: questions,
                                      oldName: questions.values
                                          .elementAt(0)
                                          .subcategory!
                                          .string,
                                      exerciseString: questions.values
                                          .elementAt(0)
                                          .subcategory!
                                          .string,
                                    );
                                  }
                                },
                              ),
                              initialTest: true,
                              testActivitiesDescription:
                                  "The test will comprise of 10 Reading and Writing Questions.",
                              testScoreDescription:
                                  "We will use your score to personalize your app experience.",
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: size.height / 30),
                    SatsProgramButton(
                      text: "Only Math Section",
                      height: size.height * 0.07,
                      color: Theme.of(context).colorScheme.secondary,
                      name: "math",
                      onTap: () {
                        setState(() {
                          startedLevelTest = true;
                        });
                        questionsF = () async {
                          prefs = await SharedPreferences.getInstance();
                          QuestionBank questionBank = QuestionBank();
                          await questionBank.init();
                          questions = {};
                          for (var questionSubcategoryStr
                              in SatsQuestionSubcategories.typesList
                                  .sublist(10)) {
                            var questionSubcategory =
                                SatsQuestionSubcategories.fromString(
                              questionSubcategoryStr,
                            );
                            await questionBank.loadFromAssets(
                              questionSubcategory.string,
                              limit: 4,
                            );
                          }
                          questions.addAll(
                            await questionBank.getQuestions(
                              SatsQuestionSubcategories(
                                ESatsQuestionSubcategories
                                    .NonlinearEquationsInOneVariableAndSystemsOfEquationsInTwoVariables,
                              ).string,
                              1,
                              true,
                              true,
                              difficulty: SatsQuestionDifficulty.difficultyEasy,
                            ),
                          );
                          questions.addAll(
                            await questionBank.getQuestions(
                              SatsQuestionSubcategories(
                                ESatsQuestionSubcategories.Percentages,
                              ).string,
                              1,
                              true,
                              true,
                              difficulty: SatsQuestionDifficulty.difficultyEasy,
                            ),
                          );
                          questions.addAll(
                            await questionBank.getQuestions(
                              SatsQuestionSubcategories(
                                ESatsQuestionSubcategories.Circles,
                              ).string,
                              1,
                              true,
                              true,
                              difficulty: SatsQuestionDifficulty.difficultyEasy,
                            ),
                          );
                          questions.addAll(
                            await questionBank.getQuestions(
                              SatsQuestionSubcategories(
                                ESatsQuestionSubcategories
                                    .LinesAnglesAndTriangles,
                              ).string,
                              1,
                              true,
                              true,
                              difficulty:
                                  SatsQuestionDifficulty.difficultyMedium,
                            ),
                          );
                          questions.addAll(
                            await questionBank.getQuestions(
                              SatsQuestionSubcategories(
                                ESatsQuestionSubcategories
                                    .RightTrianglesAndTrigonometry,
                              ).string,
                              1,
                              true,
                              true,
                              difficulty:
                                  SatsQuestionDifficulty.difficultyMedium,
                            ),
                          );
                          questions.addAll(
                            await questionBank.getQuestions(
                              SatsQuestionSubcategories(
                                ESatsQuestionSubcategories.AreaAndVolume,
                              ).string,
                              1,
                              true,
                              true,
                              difficulty:
                                  SatsQuestionDifficulty.difficultyMedium,
                            ),
                          );
                          print("questions: ${questions.length}");
                        }();
                        Navigator.of(context).push(
                          PageTransition(
                            type: PageTransitionType.fade,
                            child: LevelTest(
                              10,
                              testRouteBuilder: (BuildContext context,
                                      {required bool initialTest,
                                      required bool endingTest,}) =>
                                  FutureBuilder(
                                future: questionsF,
                                builder: (context, snapshot) {
                                  print(
                                      "future questions: ${questions.length}",);
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                        child: CircularProgressIndicator(),);
                                  } else {
                                    return MathQuizModel(
                                      "R&W - Exercise {}",
                                      "R&W",
                                      600,
                                      page: Home(),
                                      initialTest: true,
                                      onEnd: (Map<String, QuizQuestionData>
                                              questions,
                                          Map<String, bool> answers,
                                          bool initialTest,
                                          bool endingTest,) {
                                        SharedPreferences.getInstance()
                                            .then((prefs) {
                                          Map<String, List<String>>
                                              savedQuestionScores = {
                                            for (String questionSubcategory
                                                in SatsQuestionSubcategories
                                                    .typesList)
                                              questionSubcategory:
                                                  prefs.getStringList(
                                                        "scores_questions_$questionSubcategory",
                                                      ) ??
                                                      [],
                                          };

                                          List<String>
                                              savedProgressQuestionScores =
                                              prefs.getStringList(
                                                      "scores_questionsLast",) ??
                                                  List<String>.generate(
                                                      SatsQuestionSubcategories
                                                          .typesList.length,
                                                      (index) => "-1",);

                                          for (int i = 0;
                                              i <
                                                  SatsQuestionSubcategories
                                                      .typesList.length;
                                              i++) {
                                            String questionSubcategory =
                                                SatsQuestionSubcategories
                                                    .typesList
                                                    .elementAt(i);
                                            int score = -1;
                                            for (String questionId
                                                in questions.keys) {
                                              if (questions[questionId]!
                                                      .subcategory
                                                      ?.string ==
                                                  questionSubcategory) {
                                                if (answers[questionId] ??
                                                    false) {
                                                  score = score == -1
                                                      ? 1
                                                      : score + 1;
                                                }
                                              }
                                            }
                                            if (score > -1) {
                                              savedQuestionScores[
                                                      questionSubcategory]
                                                  ?.add(score.toString());
                                            }
                                            savedProgressQuestionScores[
                                                i] = score >=
                                                    0.0
                                                ? score.toString()
                                                : savedProgressQuestionScores[
                                                    i];

                                            prefs.setStringList(
                                              "scores_questions_$questionSubcategory",
                                              savedQuestionScores[
                                                  questionSubcategory]!,
                                            );

                                            prefs.setStringList(
                                                "scores_questionsLast",
                                                savedProgressQuestionScores,);
                                          }
                                        });
                                      },
                                      description:
                                          "The test will comprise of 6 Math Questions.",
                                      exerciseNumber: 0,
                                      questions: questions,
                                      oldName: questions.values
                                          .elementAt(0)
                                          .subcategoryStr!,
                                      exerciseString: questions.values
                                          .elementAt(0)
                                          .subcategoryStr!,
                                    );
                                  }
                                },
                              ),
                              initialTest: true,
                              testActivitiesDescription:
                                  "The test will comprise of 6 Math Questions.\n\nYou can use the graphic calculator.",
                              testScoreDescription:
                                  "We will use your score to personalize your app experience.",
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
