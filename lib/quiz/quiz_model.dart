import 'package:brainace_pro/animated_time_bar.dart';
import 'package:flutter_html_as_text/flutter_html_as_text.dart';
import 'package:brainace_pro/animated_progress_bar.dart';
import 'package:brainace_pro/buttons.dart';
import 'package:flutter_quizzes/flutter_quizzes.dart';
import 'package:brainace_pro/quiz_question_task.dart';
import 'package:brainace_pro/score_n_progress/progress_screen.dart';
import 'package:brainace_pro/score_n_progress/show_improvement.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';
import '../../../app_bar.dart';
import '../initial_score_screen.dart';

class QuizModel extends StatefulWidget {
  final Map<String, QuizQuestionData> questions;

  /// Used for top title of the quiz. Use {} to insert current question number.
  final String title;

  /// If title should be center (default is left top corner).
  final bool centerTitle;

  /// If progress bar should be shown.
  final bool progressBar;

  /// If time bar should be shown.
  final bool timeBar;

  /// If question is only contained in question field. Should be updated to this in future.
  final bool singleTextQuestion;

  /// Maximum allowed time for the quiz.
  final int time;

  /// Initial score (result of this quiz will add to the value provided).
  final double initScore;

  /// Initial max score (this quiz will add to the value provided).
  final double initMaxScore;

  /// Layout of the answer options.
  final QuizModelAnswerLayout answerLayout;

  final String exerciseName;

  final bool initialTest;
  final bool endingTest;
  final Widget page;
  final String description;
  final String oldName;
  final int exerciseNumber;
  final String exerciseString;
  final Function(Map<String, QuizQuestionData> questions,
      Map<String, bool> answers, bool initialTest, bool endingTest)? onEnd;
  final Future Function(Map<String, QuizQuestionData> questions,
      Map<String, bool> answers, bool initialTest, bool endingTest)? onEndAsync;

  const QuizModel(this.title,
      this.exerciseName,
      this.time, {
        this.centerTitle = false,
        this.progressBar = true,
        this.timeBar = false,
        this.singleTextQuestion = false,
        required this.questions,
        super.key,
        this.initScore = 0,
        this.initMaxScore = 0,
        this.initialTest = false,
        this.endingTest = false,
        required this.page,
        required this.description,
        required this.oldName,
        required this.exerciseNumber,
        required this.exerciseString,
        this.onEnd,
        this.onEndAsync,
        this.answerLayout = QuizModelAnswerLayout.list,
      });

  @override
  State<QuizModel> createState() => _QuizModelState();
}

class _QuizModelState extends State<QuizModel> {
  double score = 0;
  String? selectedOption;
  int currentQuestionIndex = 0;
  String currentQuestionId = "";
  late Timer _timer;
  late int _time;
  Map<String, bool> answers = {};
  double maxScore = 0;
  final _textInputController = TextEditingController();

  @override
  void initState() {
    print(
        "int max score init: ${widget.initMaxScore}  init score: ${widget
            .initScore}");
    _time = widget.time;
    score += widget.initScore;
    currentQuestionId = widget.questions.keys.elementAt(currentQuestionIndex);
    selectedOption =
    widget.answerLayout == QuizModelAnswerLayout.textInput ? "" : null;

    super.initState();

    for (var question in widget.questions.values) {
      maxScore += question.score.values.elementAt(0);
    }
    print("init max score: $maxScore");
    setState(() {
      maxScore = maxScore + widget.initMaxScore;
    });

    startTimer();
  }

  bool isCorrect(String? selectedAnswer) {
    if (widget.answerLayout == QuizModelAnswerLayout.list ||
        widget.answerLayout == QuizModelAnswerLayout.boxes) {
      if (selectedAnswer == null) {
        return false;
      }
      return widget.questions[currentQuestionId]?.correct[selectedAnswer] ??
          false;
    } else if (widget.answerLayout == QuizModelAnswerLayout.textInput) {
      return false;
    }
    return false;
  }

  void handleContinue() {
    if (widget.answerLayout == QuizModelAnswerLayout.list ||
        widget.answerLayout == QuizModelAnswerLayout.boxes) {
      if (isCorrect(selectedOption)) {
        score +=
            widget.questions[currentQuestionId]?.score[selectedOption] ?? 0;
      } else if (widget.questions[currentQuestionId]?.scoreIncorrect != null) {
        score += widget.questions[currentQuestionId]
            ?.scoreIncorrect![selectedOption] ??
            0;
      }
    } else if (widget.answerLayout == QuizModelAnswerLayout.textInput) {
      for (int i = 0;
      i < widget.questions[currentQuestionId]!.answers.length;
      i++) {
        if (widget.questions[currentQuestionId]?.answers.values.elementAt(i) ==
            selectedOption) {
          score +=
              widget.questions[currentQuestionId]?.score.values.elementAt(i) ??
                  0;
          break;
        }
      }
      _textInputController.clear();
    }
    if (currentQuestionIndex < widget.questions.length - 1 && _time > 0) {
      if (selectedOption != null) {
        setState(
              () {
            selectedOption =
            widget.answerLayout == QuizModelAnswerLayout.textInput
                ? ""
                : null;
            currentQuestionIndex++;
            currentQuestionId =
                widget.questions.keys.elementAt(currentQuestionIndex);
          },
        );
      }
    } else {
      if (widget.onEnd != null) {
        widget.onEnd!(
            widget.questions, answers, widget.initialTest, widget.endingTest);
      }
      if (widget.onEndAsync != null) {
        widget.onEndAsync!(
            widget.questions, answers, widget.initialTest, widget.endingTest);
      }
      Navigator.pop(context);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
          (widget.initialTest)
              ? InitialScoreScreen(
            title: widget.exerciseName,
            description: widget.description,
            exercise: widget.exerciseNumber,
            userScore: score,
            maxScore: maxScore,
            page: widget.page,
          )
              : (widget.endingTest
              ? ShowImprovement(
            title: widget.exerciseName,
            description: widget.description,
            exercise: widget.exerciseNumber,
            yourScore: score,
            maximum: widget.questions.length.toDouble(),
            page: widget.page,
          )
              : ProgressScreen(
            name: widget.oldName,
            userScore: score,
            maxScore: maxScore,
            exercise: widget.exerciseString,
          )),
        ),
      );
    }
  }

  ImageIcon createAnswerIcon(BuildContext context,
      String answerLetter,
      bool coloredIcon,) {
    String theme =
    Theme
        .of(context)
        .brightness == Brightness.dark ? "black" : "black";
    return ImageIcon(
      coloredIcon
          ? answerLetter == "A"
          ? AssetImage('assets/icons/a_filled.png')
          : answerLetter == "B"
          ? AssetImage('assets/icons/b_filled.png')
          : answerLetter == "C"
          ? AssetImage('assets/icons/c_filled.png')
          : AssetImage('assets/icons/d_filled.png')
          : answerLetter == "A"
          ? AssetImage('assets/icons/a_outlined_$theme.png')
          : answerLetter == "B"
          ? AssetImage('assets/icons/b_outlined_$theme.png')
          : answerLetter == "C"
          ? AssetImage('assets/icons/c_outlined_$theme.png')
          : AssetImage('assets/icons/d_outlined_$theme.png'),
      color: coloredIcon
          ? isCorrect(answerLetter)
          ? Colors.green
          : Colors.red
          : Theme
          .of(context)
          .colorScheme
          .onSurface,
      size: 0.062 * MediaQuery
          .of(context)
          .size
          .width,
    );
  }

  ImageIcon buildAnswerChecks(BuildContext context,
      String? usersAnswer,
      String answerLetter,) {
    Size size = MediaQuery
        .of(context)
        .size;
    if (usersAnswer == null) {
      return createAnswerIcon(context, answerLetter, false);
    }
    return (usersAnswer == answerLetter ||
        widget.questions[currentQuestionId]!.correct[answerLetter]!)
        ? createAnswerIcon(context, answerLetter, true)
        : createAnswerIcon(context, answerLetter, false);
  }

  ListTile buildAnswer(BuildContext context, String answerLetter) {
    Size size = MediaQuery
        .of(context)
        .size;
    return ListTile(
      contentPadding: EdgeInsets.only(
        left: 0.008 * size.width,
        right: 0.012 * size.width,
      ),
      leading: buildAnswerChecks(context, selectedOption, answerLetter),
      title: HtmlAsTextSpan(
        "${widget.questions[currentQuestionId]?.answers[answerLetter]}",
        fontSize: 0.0155 * size.height,
      ),
      // title: Text(
      //   "${quizQuestions.values.elementAt(questionIndex).getAnswer(answerLetter)}",
      //   style: TextStyle(fontSize: 0.015 * size.height),
      // ),
      onTap: selectedOption == null
          ? () {
        setState(() {
          selectedOption = answerLetter;
          answers[currentQuestionId] =
          widget.questions[currentQuestionId]!.correct[answerLetter]!;
        });
      }
          : null,
    );
  }

  void startTimer() {
    _timer = Timer.periodic(
      const Duration(seconds: 1),
          (timer) {
        setState(
              () {
            _time--;
            if (_time <= 0) {
              handleContinue();
            }
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Column buildTitle(BuildContext context, Size size) {
    return Column(
      children: [
        if (!widget.centerTitle)
          Row(
            children: [
              Padding(padding: EdgeInsets.only(left: size.width / 11),
                child: Text(
                  "${widget.title}".replaceAll(
                      "{}", "${currentQuestionIndex + 1}"),
                  style: TextStyle(fontSize: 0.025 * size.height),
                  textAlign: TextAlign.start,
                ),),
              SizedBox(width: 0.018 * size.width),
              InkWell(
                child: Image.asset(
                  Theme
                      .of(context)
                      .brightness == Brightness.dark
                      ? "assets/help_icon_dark.png"
                      : "assets/help_icon_light.png",
                  width: 0.056 * size.width,
                ),
                onTap: () {
                  ReportQuestionDialog(
                    context,
                    null,
                    widget.questions[currentQuestionId]!.question,
                  );
                },
              ),
              const Spacer(),
              // Icon(
              //   Icons.timer,
              //   size: 0.08 * size.width,
              //   color: Theme.of(context).colorScheme.primary,
              // ),
              // const SizedBox(width: 10.0),
              Text(
                "${_time.toString()}s",
                style: TextStyle(fontSize: size.width / 20),
                textAlign: TextAlign.start,
              ),
              SizedBox(width: 0.019 * size.width),
            ],
          ),
        if (widget.centerTitle)
          Text(
            "${widget.title}".replaceAll("{}", "${currentQuestionIndex + 1}"),
            style: TextStyle(
              fontSize: 0.039 * size.height,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        SizedBox(height: 0.01 * size.height),
        if (widget.timeBar)
          AnimatedTimeBar(
            timeLeft: _time.toDouble(),
            totalTime: widget.time.toDouble(),
          ),
        SizedBox(height: 0.01 * size.height),
        if (widget.progressBar)
          AnimatedProgressBar(
            answerCount: widget.questions.length,
            answers: answers,
          ),
      ],
    );
  }

  Widget buildQuestionBody(BuildContext context, Size size) {
    return Container(
      margin: EdgeInsets.only(
        left: size.width / 11,
        right: size.width / 14,
      ),
      child: widget.singleTextQuestion ? Text(
        widget.questions[currentQuestionId]!.question,
        style: TextStyle(
          fontSize: size.width * 0.035,
          fontWeight: FontWeight.w600,
        ),
      ) : QuizQuestionTask(
        question: widget.questions[currentQuestionId]!,
      ),
    );
  }

  Widget buildAnswers(BuildContext context, Size size) {
    if (widget.answerLayout == QuizModelAnswerLayout.boxes) {
      return Column(
        children: [
          for (int i = 0; i <
              widget.questions[currentQuestionId]!.answers.length; i++)
            Column(
              children: [
                SizedBox(
                  height: 0.15 * size.height,
                  width: size.width * 0.71,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        selectedOption = widget
                            .questions[currentQuestionId]!
                            .answers
                            .keys
                            .elementAt(i);
                        answers[currentQuestionId] = widget
                            .questions[currentQuestionId]!
                            .correct[selectedOption]!;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: selectedOption == null
                              ? [
                            Theme
                                .of(context)
                                .colorScheme
                                .primary,
                            Theme
                                .of(context)
                                .colorScheme
                                .secondary
                          ]
                              : selectedOption ==
                              widget
                                  .questions[
                              currentQuestionId]!
                                  .answers
                                  .keys
                                  .elementAt(i)
                              ? (widget
                              .questions[
                          currentQuestionId]!
                              .correct
                              .values
                              .elementAt(i)
                              ? [
                            Colors.green,
                            Colors.green
                          ]
                              : [Colors.red, Colors.red])
                              : widget
                              .questions[
                          currentQuestionId]!
                              .correct
                              .values
                              .elementAt(i)
                              ? [
                            Colors.green,
                            Colors.green
                          ]
                              : [
                            Theme
                                .of(context)
                                .colorScheme
                                .primary,
                            Theme
                                .of(context)
                                .colorScheme
                                .secondary
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(
                            35), // for pill-like corners
                      ),
                      child: Center(
                        child: Text(
                          widget.questions[currentQuestionId]!
                              .answers.values
                              .elementAt(i),
                          style: TextStyle(
                            color: Theme
                                .of(context)
                                .colorScheme
                                .onPrimary,
                            fontSize: size.width * 0.07,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 0.04 * size.height),
              ],
            ),
        ],
      );
    }
    if (widget.answerLayout == QuizModelAnswerLayout.textInput) {
      return Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 0.02 * size.width,
          vertical: 0.04 * size.height,
        ),
        child: TextField(
          controller: _textInputController,
          enableSuggestions: false,
          onChanged: (value) {
            selectedOption = value.trim();
          },
          style: TextStyle(
            // e.g., set text color if desired
            color: Theme
                .of(context)
                .colorScheme
                .onSurface,
          ),
          decoration: InputDecoration(
            hintText: "Enter your answer",
            hintStyle: TextStyle(
              color: Theme
                  .of(context)
                  .colorScheme
                  .onSurface
                  .withOpacity(0.7),
            ),
            // Use a big border radius for the “pill” look
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: const BorderSide(
                color: Colors.white,
                // pick your outline color
                width: 1.0,
              ),
            ),
            // Make sure the enabled/disabled/focused borders match
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: const BorderSide(
                color: Colors.white,
                width: 1.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: const BorderSide(
                color: Colors.white,
                width: 1.0,
              ),
            ),
            // Optional: adjust padding so text is vertically/horizontally centered
            contentPadding: const EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: 16.0,
            ),
          ),
        ),
      );
    }
    if (widget.answerLayout == QuizModelAnswerLayout.list) {
      return Column(
        children: [
          buildAnswer(context, "A"),
          buildAnswer(context, "B"),
          if (widget.questions[currentQuestionId]!
              .answers["C"] !=
              null)
            buildAnswer(context, "C"),
          if (widget.questions[currentQuestionId]!
              .answers["D"] !=
              null)
            buildAnswer(context, "D"),
        ],
      );
    }
    return Container();
  }

    @override
    Widget build(BuildContext context) {
      Size size = MediaQuery
          .of(context)
          .size;

      return Scaffold(
        appBar: appBar(context, ""),
        body: Stack(
          children: [
            Align(
              alignment: Alignment(
                  Random().nextDouble() * 2 - 1, Random().nextDouble() * 2 - 1),
              child: Text(
                "WS",
                style: TextStyle(
                  fontSize: size.width / 279,
                  color: Colors.white.withOpacity(0.3),
                ),
              ),
            ),
            Align(
              alignment: Alignment(-1, -1),
              child: SingleChildScrollView(
                child: Container(
                  width: size.width * 0.9,
                  margin: EdgeInsets.only(
                    left: size.height / 30,
                    right: size.height / 30,
                    bottom: size.height / 9,
                  ),
                  child: Column(
                    children: [
                      this.buildTitle(context, size),
                      SizedBox(height: 0.04 * size.height),
                      if (widget.answerLayout == QuizModelAnswerLayout.list ||
                          widget.answerLayout ==
                              QuizModelAnswerLayout.textInput)
                        this.buildQuestionBody(context, size),
                      SizedBox(height: 0.01 * size.height),

                      this.buildAnswers(context, size),
                    ],
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment(0, 0.9),
              child: SizedBox(
                height: size.height * 0.065,
                width: size.width * 0.71,
                child: RedirectButton(
                  onClick: handleContinue,
                  text: 'Continue',
                  width: size.width,
                  requirement:
                  widget.answerLayout == QuizModelAnswerLayout.list ||
                      widget.answerLayout == QuizModelAnswerLayout.boxes
                      ? selectedOption != null
                      : true,
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
