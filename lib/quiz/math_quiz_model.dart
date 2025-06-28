import 'package:audioplayers/audioplayers.dart';
import 'package:brainace_pro/margins.dart';
import 'package:flutter_html_as_text/flutter_html_as_text.dart';
import 'package:brainace_pro/animated_progress_bar.dart';
import 'package:brainace_pro/buttons.dart';
import 'package:flutter_quizzes/flutter_quizzes.dart';
import 'package:brainace_pro/quiz/quiz_question_task.dart';
import 'package:brainace_pro/score_n_progress/progress_screen.dart';
import 'package:brainace_pro/score_n_progress/show_improvement.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';
import 'dart:async';
import '../../../app_bar.dart';
import '../initial_score_screen.dart';
import 'build_answer_icon.dart';
import 'package:latext/latext.dart';

class GraphWidget extends StatelessWidget {
  final List<dynamic> graphs;

  const GraphWidget({super.key, required this.graphs});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      padding: const EdgeInsets.all(6),
      child: CustomPaint(
        painter: _GraphPainter(graphs),
        child: Container(),
      ),
    );
  }
}

class _GraphPainter extends CustomPainter {
  final List<dynamic> graphs;

  _GraphPainter(this.graphs);

  @override
  void paint(Canvas canvas, Size size) {
    double minX = double.infinity, maxX = -double.infinity;
    double minY = double.infinity, maxY = -double.infinity;
    for (var graph in graphs) {
      List<dynamic> points = graph['graph_points'] ?? [];
      for (var point in points) {
        double x = (point[0] as num).toDouble();
        double y = (point[1] as num).toDouble();
        if (x < minX) minX = x;
        if (x > maxX) maxX = x;
        if (y < minY) minY = y;
        if (y > maxY) maxY = y;
      }
    }
    const margin = 8.0;
    double scaleX = (size.width - 2 * margin) / ((maxX - minX) == 0 ? 1 : (maxX - minX));
    double scaleY = (size.height - 2 * margin) / ((maxY - minY) == 0 ? 1 : (maxY - minY));

    Offset convertPoint(dynamic point) {
      double x = ((point[0] as num).toDouble() - minX) * scaleX + margin;
      double y = size.height - (((point[1] as num).toDouble() - minY) * scaleY + margin);
      return Offset(x, y);
    }

    if (graphs.isNotEmpty && (graphs[0]['grid'] ?? false) == true) {
      final gridPaint = Paint()
        ..color = Colors.grey[300]!
        ..strokeWidth = 0.5;
      for (double y = margin; y <= size.height - margin; y += 15) {
        canvas.drawLine(
          Offset(margin, y),
          Offset(size.width - margin, y),
          gridPaint,
        );
      }
      for (double x = margin; x <= size.width - margin; x += 15) {
        canvas.drawLine(
          Offset(x, margin),
          Offset(x, size.height - margin),
          gridPaint,
        );
      }
    }

    for (var graph in graphs) {
      List<dynamic> points = graph['graph_points'] ?? [];
      if (points.isEmpty) continue;
      final lineColorList = graph['line_color'] ?? [255, 0, 0, 0];
      final lineColor = Color.fromARGB(
        lineColorList[0],
        lineColorList[1],
        lineColorList[2],
        lineColorList[3],
      );
      final lineThickness = (graph['line_thickness'] as num?)?.toDouble() ?? 1.0;
      final linePaint = Paint()
        ..color = lineColor
        ..strokeWidth = lineThickness
        ..style = PaintingStyle.stroke;
      final path = Path();
      path.moveTo(convertPoint(points.first).dx, convertPoint(points.first).dy);
      for (var pt in points.skip(1)) {
        path.lineTo(convertPoint(pt).dx, convertPoint(pt).dy);
      }
      canvas.drawPath(path, linePaint);

      final pointColorList = graph['point_color'] ?? [255, 0, 0, 0];
      final pointColor = Color.fromARGB(
        pointColorList[0],
        pointColorList[1],
        pointColorList[2],
        pointColorList[3],
      );
      final pointThickness = (graph['point_thickness'] as num?)?.toDouble() ?? 0.0;
      final pointPaint = Paint()
        ..color = pointColor
        ..style = PaintingStyle.fill;
      for (var p in points) {
        Offset offset = convertPoint(p);
        canvas.drawCircle(offset, pointThickness + 2, pointPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _GraphPainter oldDelegate) => true;
}

class MathQuizModel extends StatefulWidget {
  final Map<String, QuizQuestionData> questions;

  /// Used for top title of the quiz. Use {} to insert current question number.
  final String title;

  /// Maximum allowed time for the quiz.
  final int time;

  /// Initial score (result of this quiz will add to the value provided).
  final double initScore;

  /// Initial max score (this quiz will add to the value provided).
  final double initMaxScore;

  /// If all questions should be shown at once, especially useful for multiline user-input ones.
  final bool showMultipleQuestions;

  /// Layout of the answer options.
  final QuizModelAnswerLayout answerLayout;

  /// If answer is required to continue.
  final bool requireAnswer;

  final AssetSource? music;

  final String exerciseName;

  final int htmlFormat;

  final bool initialTest;
  final bool endingTest;
  final Widget page;
  final String description;
  final String oldName;
  final int exerciseNumber;
  final String exerciseString;
  final Function(
    Map<String, QuizQuestionData> questions,
    Map<String, bool> answers,
    bool initialTest,
    bool endingTest,
  )? onEnd;
  final Future Function(
    Map<String, QuizQuestionData> questions,
    Map<String, bool> answers,
    bool initialTest,
    bool endingTest,
  )? onEndAsync;

  const MathQuizModel(
    this.title,
    this.exerciseName,
    this.time, {
    this.showMultipleQuestions = false,
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
    this.requireAnswer = false,
    this.music,
    this.htmlFormat = -1,
  });

  @override
  State<MathQuizModel> createState() => _MathQuizModelState();
}

class _MathQuizModelState extends State<MathQuizModel> {
  double score = 0;
  String? selectedOption;
  int currentQuestionIndex = 0;
  String currentQuestionId = '';
  late Timer _timer;
  late int _time;
  Map<String, String> answers = {};
  double maxScore = 0;
  final player = AudioPlayer();
  bool forceContinue = false;

  @override
  void initState() {
    _time = widget.time;
    currentQuestionId = widget.questions.keys.elementAt(currentQuestionIndex);
    selectedOption = widget.answerLayout == QuizModelAnswerLayout.textInput ? '' : null;

    super.initState();
    for (var questionId in widget.questions.keys) {
      maxScore += widget.questions[questionId]!.score.values.elementAt(0);
    }

    setState(() {
      maxScore = maxScore + widget.initMaxScore;
    });

    if (widget.music != null) {
      player.play(widget.music!);
      player.setReleaseMode(ReleaseMode.loop);
    }
    startTimer();
  }

  void handleContinue() {
    if (widget.answerLayout == QuizModelAnswerLayout.textInput && !widget.showMultipleQuestions) {
      setState(() {
        answers[currentQuestionId] = selectedOption!;
      });
      // _textInputController.clear();
    }
    if (currentQuestionIndex < widget.questions.length - 1 && _time > 0 && !widget.showMultipleQuestions && !forceContinue) {
      if (selectedOption != null) {
        setState(
          () {
            selectedOption = null;
            currentQuestionIndex++;
            currentQuestionId = widget.questions.keys.elementAt(currentQuestionIndex);
          },
        );
      }
    } else {
      if (widget.onEnd != null) {
        widget.onEnd!(
          widget.questions,
          getCorrectBoolArray(widget.questions, answers),
          widget.initialTest,
          widget.endingTest,
        );
      }
      if (widget.onEndAsync != null) {
        widget.onEndAsync!(
          widget.questions,
          getCorrectBoolArray(widget.questions, answers),
          widget.initialTest,
          widget.endingTest,
        );
      }

      double score = 0;
      score = widget.initScore;
      for (var questionId in widget.questions.keys) {
        if (answers[questionId] == null) {
          continue;
        }
        if (widget.questions[questionId]!.correct[answers[questionId]] ?? false) {
          score += widget.questions[questionId]!.score[answers[questionId]] ?? 0;
          SharedPreferences.getInstance().then((prefs) {
            double auria = prefs.getDouble('auria') ?? 0.0;
            auria += 1;
            prefs.setDouble('auria', auria);
          });
        } else if (widget.questions[questionId]!.scoreIncorrect != null) {
          score += widget.questions[questionId]!.scoreIncorrect![answers[questionId]] ?? 0;
        }
      }

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

  Widget buildAnswerChecks(
    BuildContext context,
    String? usersAnswer,
    String answerLetter,
    String questionId,
  ) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(
        left: size.width * 0.035,
      ),
      child: Text(
        '$answerLetter.',
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface,
          fontSize: textScaleFactor(widget.questions[questionId]!.question.length) * 1.4 * size.width,
        ),
      ),
    );
  }

  Widget buildLetterAnswer(
    BuildContext context,
    String answerLetter,
    String questionId,
  ) {
    Size size = MediaQuery.of(context).size;
    return ListTile(
      contentPadding: EdgeInsets.only(
        left: 0.008 * size.width,
        right: 0.025 * size.width,
      ),
      leading: buildAnswerChecks(
        context,
        selectedOption,
        answerLetter,
        questionId,
      ),
      title: (widget.htmlFormat != -1 && widget.htmlFormat <= currentQuestionIndex)
          ? HtmlAsTextSpan(
              '${widget.questions[questionId]?.answers[answerLetter]}',
              fontSize: textScaleFactor(
                    widget.questions[questionId]!.question.length,
                  ) *
                  0.95 *
                  size.width,
            )
          : LaTexT(
              equationStyle: TextStyle(
                fontSize: textScaleFactor(
                      widget.questions[questionId]!.answers[answerLetter]!.length,
                    ) *
                    1.13 *
                    size.width,
              ),
              laTeXCode: Text(
                widget.questions[questionId]!.answers[answerLetter]!,
                style: TextStyle(
                  fontSize: textScaleFactor(
                        widget.questions[questionId]!.question.length,
                      ) *
                      1.2 *
                      size.width,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
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

  Widget buildAnswer(
    BuildContext context,
    String answerLetter,
    String questionId,
    Widget Function(BuildContext context, String answerLetter, String questionId) subBuildAnswer,
  ) {
    Size size = MediaQuery.of(context).size;
    return Card(
      margin: EdgeInsets.only(
        top: size.height * 0.015,
      ),
      color: selectedOption == null
          ? Theme.of(context).colorScheme.primary.withOpacity(0.8)
          : widget.questions[questionId]!.correct[answerLetter]!
              ? Colors.green
              : selectedOption == answerLetter
                  ? Colors.red
                  : Theme.of(context).colorScheme.primary.withOpacity(0.8),
      // !(selectedOption == answerLetter || widget.questions[questionId]!.correct[answerLetter]!) ?  :
      // ( ??= false) ? Colors.green : Colors.red,
      // : Colors.red,
      // child: buildLetterAnswer(context, answerLetter, questionId),
      child: subBuildAnswer(context, answerLetter, questionId),
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
    BuildContext context,
    Size size,
    int questionIndex,
    String questionId,
  ) {
    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: size.width / 11),
              child: Text(
                widget.title.replaceAll('{}', '${questionIndex + 1}'),
                style: TextStyle(fontSize: 0.023 * size.height),
                textAlign: TextAlign.start,
              ),
            ),
            SizedBox(width: 0.018 * size.width),
            InkWell(
              child: Container(
                width: 0.08 * size.width,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.8),
                ),
                child: Icon(
                  Icons.question_mark_rounded,
                  color: Colors.white,
                ),
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
              '${_time.toString()}s',
              style: TextStyle(fontSize: size.width / 20),
              textAlign: TextAlign.start,
            ),
            SizedBox(width: 0.019 * size.width),
          ],
        ),
        SizedBox(height: 0.01 * size.height),
        AnimatedProgressBar(
          answerCount: widget.questions.length,
          answers: getCorrectBoolArray(widget.questions, answers),
        ),
      ],
    );
  }

  Widget buildQuestionTask(BuildContext context, Size size, String questionId) {
    return (widget.htmlFormat != -1 && widget.htmlFormat <= currentQuestionIndex)
        ? QuizQuestionTask(
            question: widget.questions[questionId]!,
          )
        : LaTexT(
            equationStyle: TextStyle(
              fontSize: textScaleFactor(
                    widget.questions[questionId]!.question.length,
                  ) *
                  1.16 *
                  size.width,
            ),
            laTeXCode: Text(
              widget.questions[questionId]!.question.replaceAll('{dollars}', ' Dollars'),
              softWrap: true,
              style: TextStyle(
                fontSize: textScaleFactor(
                      widget.questions[questionId]!.question.length,
                    ) *
                    1.1 *
                    size.width,
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
          );
  }

  Widget _buildTable(List<List<String>> rows) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(right: 10, top: 10, bottom: 10, left: 4),
      child: Table(
        border: TableBorder.symmetric(
            inside: BorderSide(width: 1, color: Colors.grey.shade300),
            outside: BorderSide(width: 1, color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(13.0),),
        children: [
          // TableRow(
          //   children: ['x', 'y']
          //       .map((h) => Padding(
          //             padding: EdgeInsets.symmetric(vertical: 3),
          //             child: Center(child: Text(h, style: TextStyle(fontWeight: FontWeight.bold))),
          //           ))
          //       .toList(),
          // ),
          ...rows.map((r) => TableRow(
                children: r
                    .map((content) => Padding(
                          padding: EdgeInsets.symmetric(vertical: 5),
                          child: Center(
                              // child: Text(content)
                              child: LaTexT(
                                equationStyle: TextStyle(
                                  fontSize:
                                  textScaleFactor(
                                    content.length,
                                  ) * 0.8 *
                                      size.width,
                                ),
                                laTeXCode: Text(
                                  content,
                                  style: TextStyle(
                                    fontSize: textScaleFactor(
                                      content.length,
                                    ) *
                                        0.8 *
                                        size.width,
                                    color: Theme.of(context).colorScheme.onSurface,
                                  ),
                                ),
                              ),
                          ),
                        ),)
                    .toList(),
              ),),
        ],
      ),
    );
  }

  Widget _buildAnswerCard(BuildContext context, String answerLetter, String questionId) {
    Size size = MediaQuery.of(context).size;
    return ListTile(
      contentPadding: EdgeInsets.only(
        left: 0.008 * size.width,
        right: 0.012 * size.width,
      ),
      leading: buildAnswerChecks(context, selectedOption, answerLetter, questionId),
      title: _buildTable((widget.questions[questionId]?.answers[answerLetter] as List<dynamic>)
          .map((e) => (e as List<dynamic>).map((e2) => (e2 as String)).toList())
          .toList(),),
      // Text(
      //   "${widget.questions[questionId]?.answers[answerLetter]}",
      //   style: TextStyle(fontSize: textScaleFactor(widget.questions[questionId]!.question.length) * 0.95 * size.width,),
      // ),
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

  Widget _buildSingleColumnAnswers(
    BuildContext context,
    Size size,
    String questionId,
  ) {
    return Container(
      // margin: quizMargins(size),
      child: Column(
        children: [
          for (int i = 0; i < widget.questions[questionId]!.answers.length; i++)
            buildAnswer(
              context,
              widget.questions[questionId]!.answers.keys.elementAt(i),
              questionId,
              buildLetterAnswer,
            ),
        ],
      ),
    );
  }

  Widget _buildTwoColumnAnswers(
    BuildContext context,
    Size size,
    String questionId,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            spacing: 1,
            children: [
              buildAnswer(
                context,
                widget.questions[questionId]!.answers.keys.elementAt(0),
                questionId,
                _buildAnswerCard,
              ),
              SizedBox(height: 0.014 * size.height),
              buildAnswer(
                context,
                widget.questions[questionId]!.answers.keys.elementAt(1),
                questionId,
                _buildAnswerCard,
              ),
            ],
          ),
        ),
        SizedBox(width: 0.054 * size.width),
        Expanded(
          child: Column(
            children: [
              buildAnswer(
                context,
                widget.questions[questionId]!.answers.keys.elementAt(2),
                questionId,
                _buildAnswerCard,
              ),
              SizedBox(height: 0.014 * size.height),
              buildAnswer(
                context,
                widget.questions[questionId]!.answers.keys.elementAt(3),
                questionId,
                _buildAnswerCard,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildQuestion(
    BuildContext context,
    Size size,
    String questionId,
    int questionIndex,
  ) {
    return Column(
      children: [
        Container(
          margin: quizMargins(size),
          child: Column(
            children: [
              buildQuestionTask(context, size, questionId),
              SizedBox(height: 0.01 * size.height),
              widget.questions[questionId]!.answers.values.first is String
                  ? _buildSingleColumnAnswers(context, size, questionId)
                  : _buildTwoColumnAnswers(context, size, questionId),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildQuestions(
    BuildContext context,
    Size size,
    String questionId,
    int questionIndex,
  ) {
    return Column(
      children: [
        buildTitle(context, size, questionIndex, questionId),
        SizedBox(height: 0.035 * size.height),
        if (!widget.showMultipleQuestions) buildQuestion(context, size, questionId, questionIndex),
        if (widget.showMultipleQuestions)
          for (int i = 0; i < widget.questions.length; i++)
            Column(
              children: [
                buildQuestion(
                  context,
                  size,
                  widget.questions.keys.elementAt(i),
                  i,
                ),
                SizedBox(height: 0.025 * size.height),
              ],
            ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: appBar(context, ''),
      body: Stack(
        children: [
          Align(
            alignment: Alignment(
              Random().nextDouble() * 2 - 1,
              Random().nextDouble() * 2 - 1,
            ),
            child: Text(
              'WS',
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
                  bottom: size.height / 7,
                ),
                child: buildQuestions(
                  context,
                  size,
                  currentQuestionId,
                  currentQuestionIndex,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment(0, 0.9),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: size.height * 0.064,
                  width: size.width * 0.39,
                  child: RedirectButton(
                    onClick: handleContinue,
                    text: 'Continue',
                    width: size.width,
                    requirement: widget.requireAnswer
                        ? (selectedOption != null && selectedOption != '')
                        : widget.answerLayout == QuizModelAnswerLayout.list || widget.answerLayout == QuizModelAnswerLayout.boxes
                            ? selectedOption != null
                            : true,
                  ),
                ),
                SizedBox(width: 0.054 * size.width),
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
