import 'package:audioplayers/audioplayers.dart';
import 'package:brainace_pro/animated_time_bar.dart';
import 'package:brainace_pro/margins.dart';
import 'package:flutter_html_as_text/flutter_html_as_text.dart';
import 'package:brainace_pro/animated_progress_bar.dart';
import 'package:brainace_pro/buttons.dart';
import 'package:flutter_quizzes/flutter_quizzes.dart';
import 'package:brainace_pro/quiz/quiz_question_task.dart';
import 'package:brainace_pro/score_n_progress/progress_screen.dart';
import 'package:brainace_pro/score_n_progress/show_improvement.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';
import '../../../app_bar.dart';
import '../initial_score_screen.dart';
import 'dart:math' as math;

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

  /// If task and answers should be displayed in one line.
  final bool inlineTaskAndAnswers;

  /// If all questions should be shown at once, especially useful for multiline user-input ones.
  final bool showMultipleQuestions;

  /// If question task defined in QuestionData should be displayed.
  final bool showQuestionTask;

  /// Layout of the answer options.
  final QuizModelAnswerLayout answerLayout;

  /// Hint text for text input.
  final String hintText;

  /// If text input should only accept numbers.
  final bool inputTextNumbersOnly;

  /// If text input should be inline with the continue button.
  final bool inlineTextInputButton;

  /// If answer is required to continue.
  final bool requireAnswer;

  final AssetSource? music;

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

  const QuizModel(
    this.title,
    this.exerciseName,
    this.time, {
    this.showMultipleQuestions = false,
    this.showQuestionTask = true,
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
    this.inlineTaskAndAnswers = false,
    this.hintText = "Enter your answer",
    this.inputTextNumbersOnly = false,
    this.requireAnswer = false,
    this.music,
    this.inlineTextInputButton = false,
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
  Map<String, String> answers = {};
  double maxScore = 0;
  Map<String, TextEditingController> _textEditingControllers = {};
  final player = AudioPlayer();
  bool forceContinue = false;

  double textScaleFactor(int textLength) {
    double val = 0.0056;
    val += 1 / (math.sqrt(math.sqrt(math.sqrt(textLength.toDouble()))) * 16);
    val = math.min(val, 0.049);
    val = math.max(val, 0.029);
    print("val: $val");
    return val;
  }

  Map<String, bool> getCorrectBoolArray() {
    return {
      for (var answerId in answers.keys)
        answerId: widget.questions[answerId] == null
            ? false
            : widget.questions[answerId]!.correct[answers[answerId]] ?? false,
    };
  }

  @override
  void initState() {
    _time = widget.time;
    currentQuestionId = widget.questions.keys.elementAt(currentQuestionIndex);
    selectedOption =
        widget.answerLayout == QuizModelAnswerLayout.textInput ? "" : null;

    super.initState();
    for (var questionId in widget.questions.keys) {
      _textEditingControllers[questionId] = TextEditingController();
      maxScore += widget.questions[questionId]!.score.values.elementAt(0);
    }
    print("init max score: $maxScore");
    setState(() {
      maxScore = maxScore + widget.initMaxScore;
    });

    if (widget.music != null) {
      player.play(widget.music!);
      player.setReleaseMode(ReleaseMode.loop);
    }
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
    print("selectedOption: $selectedOption");
    print("answers: $answers");
    if (widget.answerLayout == QuizModelAnswerLayout.textInput &&
        !widget.showMultipleQuestions) {
      setState(() {
        answers[currentQuestionId] = selectedOption!;
      });
      // _textInputController.clear();
    }
    if (currentQuestionIndex < widget.questions.length - 1 &&
        _time > 0 &&
        !widget.showMultipleQuestions &&
        !forceContinue) {
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
        widget.onEnd!(widget.questions, getCorrectBoolArray(),
            widget.initialTest, widget.endingTest);
      }
      if (widget.onEndAsync != null) {
        widget.onEndAsync!(widget.questions, getCorrectBoolArray(),
            widget.initialTest, widget.endingTest);
      }

      double score = 0;
      score = widget.initScore;
      for (var questionId in widget.questions.keys) {
        if (answers[questionId] == null) {
          continue;
        }
        print(
            "questionId: $questionId answer: ${answers[questionId]} correct: ${widget.questions[questionId]!.correct[answers[questionId]]}");
        if (widget.questions[questionId]!.correct[answers[questionId]] ??
            false) {
          score +=
              widget.questions[questionId]!.score[answers[questionId]] ?? 0;
        } else if (widget.questions[questionId]!.scoreIncorrect != null) {
          score += widget.questions[questionId]!
                  .scoreIncorrect![answers[questionId]] ??
              0;
        }
      }

      print("score: $score");
      print("answers: $answers");

      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => (widget.initialTest)
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
                      userScore: score,
                      maxScore: maxScore,
                      exercise: widget.exerciseString,
                    )),
        ),
      );
    }
  }

  ImageIcon createAnswerIcon(
    BuildContext context,
    String answerLetter,
    bool coloredIcon,
    String questionId,
    String answerId,
  ) {
    String theme =
        Theme.of(context).brightness == Brightness.dark ? "black" : "black";
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
          : Theme.of(context).colorScheme.onSurface,
      // size: 0.062 * MediaQuery.of(context).size.width,
      size: textScaleFactor(widget.questions[questionId]!.question!.length) *
          MediaQuery.of(context).size.width *
          1.7,
    );
  }

  ImageIcon buildAnswerChecks(BuildContext context, String? usersAnswer,
      String answerLetter, String questionId) {
    Size size = MediaQuery.of(context).size;
    if (usersAnswer == null) {
      return createAnswerIcon(
          context, answerLetter, false, questionId, answerLetter);
    }
    return (usersAnswer == answerLetter ||
            widget.questions[questionId]!.correct[answerLetter]!)
        ? createAnswerIcon(
            context, answerLetter, true, questionId, answerLetter)
        : createAnswerIcon(
            context, answerLetter, false, questionId, answerLetter);
  }

  ListTile buildLetterAnswer(
      BuildContext context, String answerLetter, String questionId) {
    Size size = MediaQuery.of(context).size;
    return ListTile(
      contentPadding: EdgeInsets.only(
        left: 0.008 * size.width,
        right: 0.012 * size.width,
      ),
      leading:
          buildAnswerChecks(context, selectedOption, answerLetter, questionId),
      title: HtmlAsTextSpan(
        "${widget.questions[questionId]?.answers[answerLetter]}",
        // fontSize: 0.0155 * size.height,
        fontSize:
            textScaleFactor(widget.questions[questionId]!.question.length) *
                0.9 *
                size.width,
      ),
      onTap: selectedOption == null
          ? () {
              setState(() {
                selectedOption = answerLetter;
                answers[questionId] = selectedOption!;
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
    player.audioCache.clearAll();
    player.dispose();
    _timer.cancel();
    super.dispose();
  }

  Column buildTitle(
      BuildContext context, Size size, int questionIndex, String questionId) {
    return Column(
      children: [
        if (!widget.centerTitle)
          Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: size.width / 11),
                child: Text(
                  "${widget.title}".replaceAll("{}", "${questionIndex + 1}"),
                  style: TextStyle(fontSize: 0.023 * size.height),
                  textAlign: TextAlign.start,
                ),
              ),
              SizedBox(width: 0.018 * size.width),
              InkWell(
                child: Image.asset(
                  Theme.of(context).brightness == Brightness.dark
                      ? "assets/help_icon_dark.png"
                      : "assets/help_icon_light.png",
                  width: 0.056 * size.width,
                ),
                onTap: () {
                  ReportQuestionDialog(
                    context,
                    null,
                    widget.questions[questionId]!.question,
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
            "${widget.title}".replaceAll("{}", "${questionIndex + 1}"),
            style: TextStyle(
              fontSize: 0.041 * size.height,
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
            answers: getCorrectBoolArray(),
          ),
      ],
    );
  }

  Widget buildQuestionTask(BuildContext context, Size size, String questionId) {
    return widget.inlineTaskAndAnswers
        ? Row(
            children: [
              Text("${questionId}"),
              SizedBox(
                width: size.width * 0.025,
              ),
              Text(
                widget.questions[questionId]!.question,
                style: TextStyle(
                  fontSize: size.width * 0.035,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          )
        : widget.singleTextQuestion
            ? Text(
                widget.questions[questionId]!.question,
                style: TextStyle(
                  fontSize: textScaleFactor(
                          widget.questions[questionId]!.question.length) *
                      1.1 *
                      size.width,
                  fontWeight: FontWeight.w600,
                ),
              )
            : QuizQuestionTask(
                question: widget.questions[questionId]!,
              );
  }

  Widget buildBoxAnswer(
      BuildContext context, Size size, String questionId, String answerId) {
    return Column(
      children: [
        SizedBox(
          height: 0.15 * size.height,
          width: size.width * 0.71,
          child: InkWell(
            onTap: selectedOption == null
                ? () {
                    setState(() {
                      selectedOption = answerId;
                      answers[questionId] = selectedOption!;
                    });
                  }
                : null,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: selectedOption == null
                      ? [
                          Theme.of(context).colorScheme.primary,
                          Theme.of(context).colorScheme.secondary
                        ]
                      : selectedOption == answerId
                          ? (widget.questions[questionId]!.correct[answerId]!
                              ? [
                                  Colors.green,
                                  Colors.green,
                                ]
                              : [Colors.red, Colors.red])
                          : widget.questions[questionId]!.correct[answerId]!
                              ? [Colors.green, Colors.green]
                              : [
                                  Theme.of(context).colorScheme.primary,
                                  Theme.of(context).colorScheme.secondary
                                ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius:
                    BorderRadius.circular(35), // for pill-like corners
              ),
              child: Center(
                child: Text(
                  widget.questions[questionId]!.answers[answerId]!,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
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
    );
  }

  Widget buildTextInput(BuildContext context, Size size, String questionId,
      {double fontSize = 1.0}) {
    return Center(
      child: TextField(
        controller: _textEditingControllers[questionId],
        enableSuggestions: false,
        onChanged: (value) {
          value = value.trim();
          if (widget.inputTextNumbersOnly) {
            try {
              value = double.parse(value.replaceAll(',', '.')).toString();
            } catch (e) {
              value = "";
            }
          }
          for (int i = 0;
              i < widget.questions[questionId]!.answers.length;
              i++) {
            print("value: $value");
            print(
                "answer: ${widget.questions[questionId]!.answers.values.elementAt(i)}");
            print(
                "score: ${widget.questions[questionId]!.score.values.elementAt(i)}");
            if (widget.questions[questionId]?.answers.values.elementAt(i) ==
                value) {
              setState(() {
                selectedOption =
                    widget.questions[questionId]?.answers.keys.elementAt(i);
                if (widget.showMultipleQuestions) {
                  answers[questionId] = selectedOption!;
                }
              });
              break;
            }
          }
        },
        style: TextStyle(
          height: 0.9,
          fontSize: 14 * fontSize,
          // e.g., set text color if desired
          color: Theme.of(context).colorScheme.onSurface,
        ),
        decoration: InputDecoration(
          hintText: "",
          hintStyle: TextStyle(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
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
          contentPadding: EdgeInsets.only(
            top: size.height / 60,
            left: size.width / 50,
            right: size.width / 50,
          ),
        ),
      ),
    );
  }

  Widget buildAnswers(BuildContext context, Size size, String questionId) {
    return Container(
      // margin: quizMargins(size),
      child: widget.answerLayout == QuizModelAnswerLayout.boxes
          ? Column(
              children: [
                for (int i = 0;
                    i < widget.questions[questionId]!.answers.length;
                    i++)
                  buildBoxAnswer(context, size, questionId,
                      widget.questions[questionId]!.answers.keys.elementAt(i)),
              ],
            )
          : widget.answerLayout == QuizModelAnswerLayout.textInput
              ? widget.inlineTextInputButton
                  ? Padding(
                      padding: EdgeInsets.only(
                        top: 0.03 * size.height,
                        bottom: 0.03 * size.height,
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 0.49 * size.width,
                            height: 0.05 * size.height,
                            child: buildTextInput(
                              context,
                              size,
                              questionId,
                              fontSize: 1,
                            ),
                          ),
                          SizedBox(width: 0.024 * size.width),
                          SizedBox(
                            width: size.width * 0.25,
                            height: size.height * 0.05,
                            child: RedirectButton(
                              onClick: handleContinue,
                              text: 'Next',
                              width: size.width,
                              requirement: widget.requireAnswer
                                  ? (selectedOption != null &&
                                      selectedOption != "")
                                  : widget.answerLayout ==
                                              QuizModelAnswerLayout.list ||
                                          widget.answerLayout ==
                                              QuizModelAnswerLayout.boxes
                                      ? selectedOption != null
                                      : true,
                            ),
                          ),
                        ],
                      ))
                  : Padding(
                      padding: EdgeInsets.only(
                        right: 0.04 * size.width,
                        top: 0.09 * size.height,
                        bottom: 0.09 * size.height,
                      ),
                      child: buildTextInput(
                        context,
                        size,
                        questionId,
                        fontSize: 1.3,
                      ),
                    )
              : widget.answerLayout == QuizModelAnswerLayout.list
                  ? Column(
                      children: [
                        for (int i = 0;
                            i < widget.questions[questionId]!.answers.length;
                            i++)
                          buildLetterAnswer(
                              context,
                              widget.questions[questionId]!.answers.keys
                                  .elementAt(i),
                              questionId),
                      ],
                    )
                  : Container(),
    );
  }

  Widget buildQuestion(
      BuildContext context, Size size, String questionId, int questionIndex) {
    return Column(
      children: [
        widget.inlineTaskAndAnswers
            ? Container(
                margin: quizMargins(size),
                child: Row(
                  children: [
                    this.buildQuestionTask(context, size, questionId),
                    SizedBox(width: 0.015 * size.width),
                    SizedBox(
                      width: 0.15 * size.width,
                      height: 0.03 * size.height,
                      child: buildTextInput(
                        context,
                        size,
                        questionId,
                        fontSize: 1,
                      ),
                    ),
                  ],
                ),
              )
            : Container(
                margin: quizMargins(size),
                child: Column(
                  children: [
                    if (widget.showQuestionTask ||
                        widget.answerLayout == QuizModelAnswerLayout.list ||
                        widget.answerLayout == QuizModelAnswerLayout.textInput)
                      this.buildQuestionTask(context, size, questionId),
                    SizedBox(height: 0.01 * size.height),
                    this.buildAnswers(context, size, questionId),
                  ],
                ),
              ),
      ],
    );
  }

  Widget buildQuestions(
      BuildContext context, Size size, String questionId, int questionIndex) {
    print("building question: ${widget.questions[questionId]!.question}");
    return Column(
      children: [
        this.buildTitle(context, size, questionIndex, questionId),
        SizedBox(height: 0.035 * size.height),
        if (!widget.showMultipleQuestions)
          buildQuestion(context, size, questionId, questionIndex),
        if (widget.showMultipleQuestions)
          for (int i = 0; i < widget.questions.length; i++)
            Column(
              children: [
                buildQuestion(
                    context, size, widget.questions.keys.elementAt(i), i),
                SizedBox(height: 0.025 * size.height),
              ],
            )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    print("score: $score");

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
            alignment: Alignment(0, -1),
            child: SingleChildScrollView(
              child: Container(
                  width: size.width * 0.9,
                  margin: EdgeInsets.only(
                    left: size.height / 50,
                    right: size.height / 50,
                    bottom: size.height / 9,
                  ),
                  child: buildQuestions(
                      context, size, currentQuestionId, currentQuestionIndex)),
            ),
          ),
          if (!widget.inlineTextInputButton)
            Align(
              alignment: Alignment(0, 0.9),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: size.height * 0.064,
                    width: size.width * 0.33,
                    child: RedirectButton(
                      onClick: () {
                        forceContinue = true;
                        handleContinue();
                      },
                      text: 'End',
                      width: size.width,
                    ),
                  ),
                  SizedBox(width: 0.054 * size.width),
                  SizedBox(
                    height: size.height * 0.064,
                    width: size.width * 0.39,
                    child: RedirectButton(
                      onClick: handleContinue,
                      text: 'Continue',
                      width: size.width,
                      requirement: widget.requireAnswer
                          ? (selectedOption != null && selectedOption != "")
                          : widget.answerLayout == QuizModelAnswerLayout.list ||
                                  widget.answerLayout ==
                                      QuizModelAnswerLayout.boxes
                              ? selectedOption != null
                              : true,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
