import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../app_bar.dart';
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

class RedirectButton extends StatelessWidget {
  final VoidCallback onClick;
  final String text;
  final double fontScale;
  final double width;
  final bool requirement;

  const RedirectButton({
    Key? key,
    required this.onClick,
    required this.text,
    required this.fontScale,
    required this.width,
    this.requirement = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: requirement ? onClick : null,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: fontScale * 20),
      ),
    );
  }
}

class GraphWidget extends StatelessWidget {
  final List<dynamic> graphs;
  const GraphWidget({Key? key, required this.graphs}) : super(key: key);

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
    double scaleX =
        (size.width - 2 * margin) / ((maxX - minX) == 0 ? 1 : (maxX - minX));
    double scaleY =
        (size.height - 2 * margin) / ((maxY - minY) == 0 ? 1 : (maxY - minY));

    Offset convertPoint(dynamic point) {
      double x = ((point[0] as num).toDouble() - minX) * scaleX + margin;
      double y = size.height -
          (((point[1] as num).toDouble() - minY) * scaleY + margin);
      return Offset(x, y);
    }

    if (graphs.isNotEmpty && (graphs[0]['grid'] ?? false) == true) {
      final gridPaint = Paint()
        ..color = Colors.grey[300]!
        ..strokeWidth = 0.5;
      for (double y = margin; y <= size.height - margin; y += 15) {
        canvas.drawLine(Offset(margin, y), Offset(size.width - margin, y), gridPaint);
      }
      for (double x = margin; x <= size.width - margin; x += 15) {
        canvas.drawLine(Offset(x, margin), Offset(x, size.height - margin), gridPaint);
      }
    }

    for (var graph in graphs) {
      List<dynamic> points = graph['graph_points'] ?? [];
      if (points.isEmpty) continue;
      final lineColorList = graph['line_color'] ?? [255, 0, 0, 0];
      final lineColor = Color.fromARGB(
          lineColorList[0], lineColorList[1], lineColorList[2], lineColorList[3]);
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
          pointColorList[0], pointColorList[1], pointColorList[2], pointColorList[3]);
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

String _getCorrectAnswer(dynamic correctField) {
  if (correctField is Map) {
    for (var key in correctField.keys) {
      if (correctField[key] == true) return key;
    }
  }
  if (correctField is String) return correctField;
  return "A";
}

Color? _getIconColor({
  required bool answered,
  required bool isSelected,
  required bool isCorrect,
  required bool wasChosen,
}) {
  if (!answered) {
    return isSelected ? Colors.blue : null;
  } else {
    if (isCorrect) return Colors.green;
    if (wasChosen) return Colors.red;
    return null;
  }
}

String _getIconPath({
  required bool answered,
  required bool isSelected,
  required bool isCorrect,
  required bool wasChosen,
  required String letter,
  required BuildContext context,
}) {
  bool highlight;
  if (!answered) {
    highlight = isSelected;
  } else {
    highlight = isCorrect || wasChosen;
  }
  String theme = Theme.of(context).brightness == Brightness.dark ? "black" : "white";
  if (highlight) {
    return 'assets/icons/${letter.toLowerCase()}_filled.png';
  } else {
    return 'assets/icons/${letter.toLowerCase()}_outlined_$theme.png';
  }
}

ImageIcon createAnswerIcon({
  required String letter,
  required bool answered,
  required bool isSelected,
  required bool isCorrect,
  required bool wasChosen,
  required BuildContext context,
}) {
  final iconPath = _getIconPath(
    answered: answered,
    isSelected: isSelected,
    isCorrect: isCorrect,
    wasChosen: wasChosen,
    letter: letter,
    context: context,
  );
  final iconColor = _getIconColor(
    answered: answered,
    isSelected: isSelected,
    isCorrect: isCorrect,
    wasChosen: wasChosen,
  );
  return ImageIcon(
    AssetImage(iconPath),
    size: 30,
    color: iconColor,
  );
}

class QuizModel extends StatefulWidget {
  final String title;
  final String exerciseName;
  final int time;
  final bool showProgressBar;
  final bool showTimeBar;

  const QuizModel(
      this.title,
      this.exerciseName,
      this.time, {
        this.showProgressBar = true,
        this.showTimeBar = true,
        Key? key,
      }) : super(key: key);

  @override
  State<QuizModel> createState() => _QuizModelState();
}

class _QuizModelState extends State<QuizModel> {
  late Future<Map<String, dynamic>> futureQuestion;
  String? selectedAnswer;
  bool answered = false;
  int timerSeconds = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    timerSeconds = widget.time;
    futureQuestion = loadQuestion();
    startTimer();
  }

  Future<Map<String, dynamic>> loadQuestion() async {
    String data = await rootBundle.loadString('assets/math_questions.json');
    final jsonResult = json.decode(data) as Map<String, dynamic>;
    return jsonResult['questions'][0] ?? {};
  }

  void startTimer() {
    if (widget.time <= 0) return;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (timerSeconds > 0) {
          timerSeconds--;
        } else {
          _timer?.cancel();
          _showExplanationDialog();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  bool areAnswersNumeric(Map<String, dynamic> answers) {
    return answers.values.every((ans) => RegExp(r'^\d+°?$').hasMatch(ans.toString()));
  }

  void _showExplanationDialog() {
    futureQuestion.then((question) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("Explanation"),
          content: Text("${question['explanation'] ?? ""}"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildAnswerCard({
    required String letter,
    required String answerText,
    required String correctAnswer,
  }) {
    bool isSelectedAnswer = (letter == selectedAnswer);
    bool isCorrect = (letter == correctAnswer);
    bool wasChosen = isSelectedAnswer;
    return Card(
      child: ListTile(
        leading: createAnswerIcon(
          letter: letter,
          answered: answered,
          isSelected: isSelectedAnswer,
          isCorrect: isCorrect,
          wasChosen: wasChosen,
          context: context,
        ),
        title: Text("$letter: $answerText", style: const TextStyle(fontSize: 15)),
        onTap: () {
          if (!answered) {
            setState(() {
              selectedAnswer = letter;
              answered = true;
            });
          }
        },
      ),
    );
  }

  Widget _buildTwoColumnAnswers(Map<String, dynamic> answers, String correct) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            children: [
              _buildAnswerCard(letter: "A", answerText: answers["A"] ?? "", correctAnswer: correct),
              _buildAnswerCard(letter: "B", answerText: answers["B"] ?? "", correctAnswer: correct),
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: [
              _buildAnswerCard(letter: "C", answerText: answers["C"] ?? "", correctAnswer: correct),
              _buildAnswerCard(letter: "D", answerText: answers["D"] ?? "", correctAnswer: correct),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSingleColumnAnswers(Map<String, dynamic> answers, String correct) {
    List<String> keys = answers.keys.toList()..sort();
    return Column(
      children: keys
          .map((k) => _buildAnswerCard(letter: k, answerText: answers[k] ?? "", correctAnswer: correct))
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: appBar(context, ""),
      body: FutureBuilder<Map<String, dynamic>>(
        future: futureQuestion,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData) {
            return const Center(child: Text("No question available"));
          }
          final question = snapshot.data!;
          final answersMap = question['answers'] as Map<String, dynamic>? ?? {};
          final correctAnswer = _getCorrectAnswer(question['correct']);
          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 0.04 * size.width,
              vertical: 0.02 * size.height,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    if (widget.time > 0)
                      Text(
                        "$timerSeconds s",
                        style: const TextStyle(fontSize: 18, color: Colors.red),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                if (widget.showProgressBar)
                  LinearProgressIndicator(
                    value: 0.5,
                    minHeight: 5,
                    backgroundColor: Colors.grey[300],
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                const SizedBox(height: 12),
                Text(
                  "${question['task'] ?? ""}",
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                if (question['graph'] != null) GraphWidget(graphs: question['graph']),
                const SizedBox(height: 12),
                Expanded(
                  child: areAnswersNumeric(answersMap)
                      ? _buildTwoColumnAnswers(answersMap, correctAnswer)
                      : SingleChildScrollView(
                    child: _buildSingleColumnAnswers(answersMap, correctAnswer),
                  ),
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment(0, 0.9),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: size.height * 0.064,
                        width: size.width * 0.39,
                        child: RedirectButton(
                          onClick: () {
                            if (answered) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Wybrano: $selectedAnswer")),
                              );
                              setState(() {
                                answered = false;
                                selectedAnswer = null;
                              });
                            }
                          },
                          text: 'Continue',
                          fontScale: 0.73,
                          width: size.width,
                          requirement: answered,
                        ),
                      ),
                      SizedBox(width: 0.054 * size.width),
                      SizedBox(
                        height: size.height * 0.064,
                        width: size.width * 0.33,
                        child: RedirectButton(
                          onClick: _showExplanationDialog,
                          text: 'End',
                          fontScale: 0.73,
                          width: size.width,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                ExpansionTile(
                  title: const Text("Explanation", style: TextStyle(fontSize: 16)),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("${question['explanation'] ?? ""}", style: const TextStyle(fontSize: 14)),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

void main() {
  runApp(
    MaterialApp(
      home: QuizModel(
        "Exercise 1 - Math",
        "Math",
        60,
      ),
    ),
  );
}
