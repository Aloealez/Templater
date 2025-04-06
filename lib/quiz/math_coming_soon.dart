// import 'dart:async';
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import '../../app_bar.dart';
// import 'package:audioplayers/audioplayers.dart';
// import 'package:brainace_pro/animated_time_bar.dart';
// import 'package:brainace_pro/margins.dart';
// import 'package:flutter_html_as_text/flutter_html_as_text.dart';
// import 'package:brainace_pro/animated_progress_bar.dart';
// import 'package:brainace_pro/buttons.dart';
// import 'package:flutter_quizzes/flutter_quizzes.dart';
// import 'package:brainace_pro/quiz/quiz_question_task.dart';
// import 'package:brainace_pro/score_n_progress/progress_screen.dart';
// import 'package:brainace_pro/score_n_progress/show_improvement.dart';
// import 'package:flutter/material.dart';
// import 'dart:math';
// import 'dart:async';
// import '../../../app_bar.dart';
// import '../initial_score_screen.dart';
// import 'build_answer_icon.dart';
// import 'dart:math' as math;
//
// class GraphWidget extends StatelessWidget {
//   final List<dynamic> graphs;
//
//   const GraphWidget({Key? key, required this.graphs}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 220,
//       padding: const EdgeInsets.all(6),
//       child: CustomPaint(
//         painter: _GraphPainter(graphs),
//         child: Container(),
//       ),
//     );
//   }
// }
//
// class _GraphPainter extends CustomPainter {
//   final List<dynamic> graphs;
//
//   _GraphPainter(this.graphs);
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     double minX = double.infinity, maxX = -double.infinity;
//     double minY = double.infinity, maxY = -double.infinity;
//     for (var graph in graphs) {
//       List<dynamic> points = graph['graph_points'] ?? [];
//       for (var point in points) {
//         double x = (point[0] as num).toDouble();
//         double y = (point[1] as num).toDouble();
//         if (x < minX) minX = x;
//         if (x > maxX) maxX = x;
//         if (y < minY) minY = y;
//         if (y > maxY) maxY = y;
//       }
//     }
//     const margin = 8.0;
//     double scaleX =
//         (size.width - 2 * margin) / ((maxX - minX) == 0 ? 1 : (maxX - minX));
//     double scaleY =
//         (size.height - 2 * margin) / ((maxY - minY) == 0 ? 1 : (maxY - minY));
//
//     Offset convertPoint(dynamic point) {
//       double x = ((point[0] as num).toDouble() - minX) * scaleX + margin;
//       double y = size.height -
//           (((point[1] as num).toDouble() - minY) * scaleY + margin);
//       return Offset(x, y);
//     }
//
//     if (graphs.isNotEmpty && (graphs[0]['grid'] ?? false) == true) {
//       final gridPaint = Paint()
//         ..color = Colors.grey[300]!
//         ..strokeWidth = 0.5;
//       for (double y = margin; y <= size.height - margin; y += 15) {
//         canvas.drawLine(
//             Offset(margin, y), Offset(size.width - margin, y), gridPaint);
//       }
//       for (double x = margin; x <= size.width - margin; x += 15) {
//         canvas.drawLine(
//             Offset(x, margin), Offset(x, size.height - margin), gridPaint);
//       }
//     }
//
//     for (var graph in graphs) {
//       List<dynamic> points = graph['graph_points'] ?? [];
//       if (points.isEmpty) continue;
//       final lineColorList = graph['line_color'] ?? [255, 0, 0, 0];
//       final lineColor = Color.fromARGB(lineColorList[0], lineColorList[1],
//           lineColorList[2], lineColorList[3]);
//       final lineThickness =
//           (graph['line_thickness'] as num?)?.toDouble() ?? 1.0;
//       final linePaint = Paint()
//         ..color = lineColor
//         ..strokeWidth = lineThickness
//         ..style = PaintingStyle.stroke;
//       final path = Path();
//       path.moveTo(convertPoint(points.first).dx, convertPoint(points.first).dy);
//       for (var pt in points.skip(1)) {
//         path.lineTo(convertPoint(pt).dx, convertPoint(pt).dy);
//       }
//       canvas.drawPath(path, linePaint);
//
//       final pointColorList = graph['point_color'] ?? [255, 0, 0, 0];
//       final pointColor = Color.fromARGB(pointColorList[0], pointColorList[1],
//           pointColorList[2], pointColorList[3]);
//       final pointThickness =
//           (graph['point_thickness'] as num?)?.toDouble() ?? 0.0;
//       final pointPaint = Paint()
//         ..color = pointColor
//         ..style = PaintingStyle.fill;
//       for (var p in points) {
//         Offset offset = convertPoint(p);
//         canvas.drawCircle(offset, pointThickness + 2, pointPaint);
//       }
//     }
//   }
//
//   @override
//   bool shouldRepaint(covariant _GraphPainter oldDelegate) => true;
// }
//
// String _getCorrectAnswer(dynamic correctField) {
//   if (correctField is Map) {
//     for (var key in correctField.keys) {
//       if (correctField[key] == true) return key;
//     }
//   }
//   if (correctField is String) return correctField;
//   return "A";
// }
//
// Color? _getIconColor({
//   required bool answered,
//   required bool isSelected,
//   required bool isCorrect,
//   required bool wasChosen,
// }) {
//   if (!answered) {
//     return isSelected ? Colors.blue : null;
//   } else {
//     if (isCorrect) return Colors.green;
//     if (wasChosen) return Colors.red;
//     return null;
//   }
// }
//
// String _getIconPath({
//   required bool answered,
//   required bool isSelected,
//   required bool isCorrect,
//   required bool wasChosen,
//   required String letter,
//   required BuildContext context,
// }) {
//   bool highlight;
//   if (!answered) {
//     highlight = isSelected;
//   } else {
//     highlight = isCorrect || wasChosen;
//   }
//   String theme =
//       Theme.of(context).brightness == Brightness.dark ? "black" : "white";
//   if (highlight) {
//     return 'assets/icons/${letter.toLowerCase()}_filled.png';
//   } else {
//     return 'assets/icons/${letter.toLowerCase()}_outlined_$theme.png';
//   }
// }
//
// ImageIcon createAnswerIcon({
//   required String letter,
//   required bool answered,
//   required bool isSelected,
//   required bool isCorrect,
//   required bool wasChosen,
//   required BuildContext context,
// }) {
//   final iconPath = _getIconPath(
//     answered: answered,
//     isSelected: isSelected,
//     isCorrect: isCorrect,
//     wasChosen: wasChosen,
//     letter: letter,
//     context: context,
//   );
//   final iconColor = _getIconColor(
//     answered: answered,
//     isSelected: isSelected,
//     isCorrect: isCorrect,
//     wasChosen: wasChosen,
//   );
//   return ImageIcon(
//     AssetImage(iconPath),
//     size: 30,
//     color: iconColor,
//   );
// }
//
// class MathQuizModel extends StatefulWidget {
//   final Map<String, QuizQuestionData> questions;
//
//   /// Used for top title of the quiz. Use {} to insert current question number.
//   final String title;
//
//   /// Maximum allowed time for the quiz.
//   final int time;
//
//   /// Initial score (result of this quiz will add to the value provided).
//   final double initScore;
//
//   /// Initial max score (this quiz will add to the value provided).
//   final double initMaxScore;
//
//   final AssetSource? music;
//
//   final String exerciseName;
//
//   final bool initialTest;
//   final bool endingTest;
//   final Widget page;
//   final String description;
//   final String oldName;
//   final int exerciseNumber;
//   final String exerciseString;
//   final Function(Map<String, QuizQuestionData> questions,
//       Map<String, bool> answers, bool initialTest, bool endingTest)? onEnd;
//   final Future Function(Map<String, QuizQuestionData> questions,
//       Map<String, bool> answers, bool initialTest, bool endingTest)? onEndAsync;
//
//   const MathQuizModel(
//     this.title,
//     this.exerciseName,
//     this.time, {
//         this.initScore = 0,
//         this.initMaxScore = 0,
//         this.initialTest = false,
//         this.endingTest = false,
//         required this.page,
//         required this.description,
//         required this.oldName,
//         required this.exerciseNumber,
//         required this.exerciseString,
//         this.onEnd,
//         this.onEndAsync,
//         this.music,
//         required this.questions,
//     super.key,
//   });
//
//   @override
//   State<MathQuizModel> createState() => _MathQuizModelState();
// }
//
// class _MathQuizModelState extends State<MathQuizModel> {
//   double score = 0;
//   String? selectedOption;
//   int currentQuestionIndex = 0;
//   String currentQuestionId = "";
//   late Timer _timer;
//   late int _time;
//   Map<String, String> answers = {};
//   double maxScore = 0;
//   final player = AudioPlayer();
//   bool forceContinue = false;
//
//   late Future<Map<String, dynamic>> futureQuestion;
//   String? selectedAnswer;
//   bool answered = false;
//   int timerSeconds = 0;
//
//   @override
//   void initState() {
//     _time = widget.time;
//     currentQuestionId = widget.questions.keys.elementAt(currentQuestionIndex);
//     selectedOption = null;
//
//     super.initState();
//     for (var questionId in widget.questions.keys) {
//       maxScore += widget.questions[questionId]!.score.values.elementAt(0);
//     }
//
//     setState(() {
//       maxScore = maxScore + widget.initMaxScore;
//     });
//
//     if (widget.music != null) {
//       player.play(widget.music!);
//       player.setReleaseMode(ReleaseMode.loop);
//     }
//     startTimer();
//
//     timerSeconds = widget.time;
//     futureQuestion = loadQuestion();
//   }
//
//   Future<Map<String, dynamic>> loadQuestion() async {
//     String data = await rootBundle.loadString('assets/math_questions.json');
//     final jsonResult = json.decode(data) as Map<String, dynamic>;
//     return jsonResult['questions'][0] ?? {};
//   }
//
//   void startTimer() {
//     if (widget.time <= 0) return;
//     _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       setState(() {
//         if (timerSeconds > 0) {
//           timerSeconds--;
//         } else {
//           _timer?.cancel();
//           _showExplanationDialog();
//         }
//       });
//     });
//   }
//
//   @override
//   void dispose() {
//     _timer?.cancel();
//     super.dispose();
//   }
//
//   bool areAnswersNumeric(Map<String, dynamic> answers) {
//     return answers.values
//         .every((ans) => RegExp(r'^\d+°?$').hasMatch(ans.toString()));
//   }
//
//   void _showExplanationDialog() {
//     futureQuestion.then((question) {
//       showDialog(
//         context: context,
//         builder: (ctx) => AlertDialog(
//           title: const Text("Explanation"),
//           content: Text("${question['explanation'] ?? ""}"),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(ctx).pop(),
//               child: const Text("OK"),
//             ),
//           ],
//         ),
//       );
//     });
//   }
//
//   ImageIcon buildAnswerChecks(BuildContext context, String? usersAnswer,
//       String answerLetter, String questionId) {
//     Size size = MediaQuery.of(context).size;
//     if (usersAnswer == null) {
//       return buildAnswerIcon(
//         context, answerLetter, false, QuizModelAnswerLayout.list, widget.questions, questionId, answerLetter,);
//     }
//     return (usersAnswer == answerLetter ||
//         widget.questions[questionId]!.correct[answerLetter]!)
//         ? buildAnswerIcon(
//         context, answerLetter, true, QuizModelAnswerLayout.list, widget.questions, questionId, answerLetter)
//         : buildAnswerIcon(
//         context, answerLetter, false, QuizModelAnswerLayout.list, widget.questions, questionId, answerLetter);
//   }
//
//   Widget _buildAnswerCard(
//       BuildContext context, String answerLetter, String questionId) {
//     Size size = MediaQuery.of(context).size;
//     return Card(
//       child: ListTile(
//         contentPadding: EdgeInsets.only(
//           left: 0.008 * size.width,
//           right: 0.012 * size.width,
//         ),
//         leading:
//         buildAnswerChecks(context, selectedOption, answerLetter, questionId),
//         title: HtmlAsTextSpan(
//           "${widget.questions[questionId]?.answers[answerLetter]}",
//           // fontSize: 0.0155 * size.height,
//           fontSize:
//           textScaleFactor(widget.questions[questionId]!.question.length) *
//               0.95 *
//               size.width,
//         ),
//         onTap: selectedOption == null
//             ? () {
//           setState(() {
//             selectedOption = answerLetter;
//             answers[questionId] = selectedOption!;
//           });
//         }
//             : null,
//       ),
//     );
//   }
//
//   Widget _buildTwoColumnAnswers(Map<String, dynamic> answers, String correct) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Expanded(
//           child: Column(
//             children: [
//               _buildAnswerCard(
//                 context,
//                 widget.questions[questionId]!.answers.keys.elementAt(i),
//         questionId),
//               _buildAnswerCard(
//                   letter: "B",
//                   answerText: answers["B"] ?? "",
//                   correctAnswer: correct),
//             ],
//           ),
//         ),
//         Expanded(
//           child: Column(
//             children: [
//               _buildAnswerCard(
//                   letter: "C",
//                   answerText: answers["C"] ?? "",
//                   correctAnswer: correct),
//               _buildAnswerCard(
//                   letter: "D",
//                   answerText: answers["D"] ?? "",
//                   correctAnswer: correct),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildSingleColumnAnswers(
//       Map<String, dynamic> answers, String correct) {
//     List<String> keys = answers.keys.toList()..sort();
//     return Column(
//       children: keys
//           .map((k) => _buildAnswerCard(
//               letter: k, answerText: answers[k] ?? "", correctAnswer: correct))
//           .toList(),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return Scaffold(
//       appBar: appBar(context, ""),
//       body: FutureBuilder<Map<String, dynamic>>(
//         future: futureQuestion,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           if (!snapshot.hasData) {
//             return const Center(child: Text("No question available"));
//           }
//           final question = snapshot.data!;
//           final answersMap = question['answers'] as Map<String, dynamic>? ?? {};
//           final correctAnswer = _getCorrectAnswer(question['correct']);
//           return Padding(
//             padding: EdgeInsets.symmetric(
//               horizontal: 0.04 * size.width,
//               vertical: 0.02 * size.height,
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Padding(
//                       padding: EdgeInsets.only(left: size.width / 11),
//                       child: Text(
//                         "${widget.title}".replaceAll("{}", "${currentQuestionIndex + 1}"),
//                         style: TextStyle(fontSize: 0.023 * size.height),
//                         textAlign: TextAlign.start,
//                       ),
//                     ),
//                     SizedBox(width: 0.018 * size.width),
//                     InkWell(
//                       child: Image.asset(
//                         Theme.of(context).brightness == Brightness.dark
//                             ? "assets/help_icon_dark.png"
//                             : "assets/help_icon_light.png",
//                         width: 0.056 * size.width,
//                       ),
//                       onTap: () {
//                         ReportQuestionDialog(
//                           context,
//                           null,
//                           widget.questions[currentQuestionId]!.question,
//                         );
//                       },
//                     ),
//                     const Spacer(),
//                     // Icon(
//                     //   Icons.timer,
//                     //   size: 0.08 * size.width,
//                     //   color: Theme.of(context).colorScheme.primary,
//                     // ),
//                     // const SizedBox(width: 10.0),
//                     Text(
//                       "${_time.toString()}s",
//                       style: TextStyle(fontSize: size.width / 20),
//                       textAlign: TextAlign.start,
//                     ),
//                     SizedBox(width: 0.019 * size.width),
//                   ],
//                 ),
//                 const SizedBox(height: 8),
//                 AnimatedProgressBar(
//                   answerCount: widget.questions.length,
//                   answers: getCorrectBoolArray(widget.questions, answers),
//                 ),
//                 const SizedBox(height: 12),
//                 Text(
//                   "${question['task'] ?? ""}",
//                   style: const TextStyle(
//                       fontSize: 18, fontWeight: FontWeight.w700),
//                 ),
//                 const SizedBox(height: 12),
//                 if (question['graph'] != null)
//                   GraphWidget(graphs: question['graph']),
//                 const SizedBox(height: 12),
//                 Expanded(
//                   child: areAnswersNumeric(answersMap)
//                       ? _buildTwoColumnAnswers(answersMap, correctAnswer)
//                       : SingleChildScrollView(
//                           child: _buildSingleColumnAnswers(
//                               answersMap, correctAnswer),
//                         ),
//                 ),
//                 const SizedBox(height: 12),
//                 Align(
//                   alignment: Alignment(0, 0.9),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       SizedBox(
//                         height: size.height * 0.064,
//                         width: size.width * 0.39,
//                         child: RedirectButton(
//                           onClick: () {
//                             if (answered) {
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 SnackBar(
//                                     content: Text("Wybrano: $selectedAnswer")),
//                               );
//                               setState(() {
//                                 answered = false;
//                                 selectedAnswer = null;
//                               });
//                             }
//                           },
//                           text: 'Continue',
//                           fontScale: 0.73,
//                           width: size.width,
//                           requirement: answered,
//                         ),
//                       ),
//                       SizedBox(width: 0.054 * size.width),
//                       SizedBox(
//                         height: size.height * 0.064,
//                         width: size.width * 0.33,
//                         child: RedirectButton(
//                           onClick: _showExplanationDialog,
//                           text: 'End',
//                           fontScale: 0.73,
//                           width: size.width,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 ExpansionTile(
//                   title:
//                       const Text("Explanation", style: TextStyle(fontSize: 16)),
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Text("${question['explanation'] ?? ""}",
//                           style: const TextStyle(fontSize: 14)),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
