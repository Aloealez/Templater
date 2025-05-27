import 'package:flutter/material.dart';
import 'package:flutter_quizzes/flutter_quizzes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import '/navbar.dart';
import 'yourProgress_screen.dart';

class AnalysisScreen extends StatefulWidget {
  const AnalysisScreen({super.key});

  @override
  _AnalysisScreenState createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  late SharedPreferences prefs;
  int scoreMath = 0;
  int scoreRW = 0;
  Color hoverColor = Colors.white24;

  Future<Map<String, double>> GetSatsPoints() async {
    List<String> questionSubcategoriesPointsStr =
        prefs.getStringList('scores_questionsLast') ??
            List<String>.generate(
              SatsQuestionSubcategories.typesList.length,
              (index) => '-1',
            );
    print('questionSubcategoriesPointsStr: $questionSubcategoriesPointsStr');
    List<String> questionsSubcategories =
        List.from(SatsQuestionSubcategories.typesList);
    Map<String, double> questionsSubcategoriesPoints = {
      for (int i = 0; i < questionSubcategoriesPointsStr.length; i++)
        SatsQuestionSubcategories.typesList[i]:
            double.parse(questionSubcategoriesPointsStr[i]),
    };
    return questionsSubcategoriesPoints;
  }

  @override
  void initState() {
    super.initState();
    _initScores();
  }

  Future<void> _initScores() async {
    prefs = await SharedPreferences.getInstance();
    var scores = await GetSatsPoints();

    for (var i = 0; i < 10; i++) {
      int score = (scores[SatsQuestionSubcategories.typesList[i]] ?? 0).toInt();
      if (score > 0) {
        scoreRW += score;
      }
    }
    for (var i = 10; i < SatsQuestionSubcategories.typesList.length; i++) {
      int score = (scores[SatsQuestionSubcategories.typesList[i]] ?? 0).toInt();
      if (score > 0) {
        scoreMath += score;
      }
    }
    scoreMath = (scoreMath * 800 / (19 * 4)).round();
    scoreRW = (scoreRW * 800 / (10 * 5)).round();

    print('Score Math: $scoreMath');
    print('Score RW: $scoreRW');

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: size.width,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            buildTitle('Current Score Prediction', size),
            const SizedBox(height: 20),
            buildScoreContainer(size),
            const SizedBox(height: 30),
            buildTitle('Your Progress', size),
            const SizedBox(height: 20),
            buildProgressContainer(context, size),
            const SizedBox(height: 30),
            buildTitle('Weak Points And Strengths', size),
            const SizedBox(height: 20),
            buildWeaknessContainer(),
          ],
        ),
      ),
      bottomNavigationBar: MyBottomNavigationBar(),
    );
  }

  Widget buildTitle(String title, Size size) {
    return Text(
      title,
      style: TextStyle(
        fontSize: size.width / 20,
        color: Colors.white,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget buildScoreContainer(Size size) {
    return Container(
      width: containerWidth,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '${scoreRW + scoreMath}',
                    style: TextStyle(
                      fontSize: size.width / 10,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(
                    text: '/ 1600 composite',
                    style: TextStyle(fontSize: size.width / 16),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 8),
          buildScoreText('0', '0', size),
        ],
      ),
    );
  }

  Widget buildScoreText(String primary, String secondary, Size size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: '$scoreMath',
                style: TextStyle(
                  fontSize: size.width / 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextSpan(
                text: '\tMath',
                style: TextStyle(fontSize: size.width / 16),
              ),
            ],
          ),
        ),
        const SizedBox(width: 20),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: '$scoreRW',
                style: TextStyle(
                  fontSize: size.width / 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextSpan(
                text: '\tR&W',
                style: TextStyle(
                  fontSize: size.width / 16,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildProgressContainer(BuildContext context, Size size) {
    return Container(
      width: containerWidth,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: Border(left: BorderSide(color: Colors.white, width: 2)),
        ),
        child: Column(
          children: [
            buildProgressBar(context, 'Before', 500),
            SizedBox(height: size.height / 40),
            buildProgressBar(context, 'Now', scoreMath + scoreRW),
          ],
        ),
      ),
    );
  }

  Widget buildProgressBar(BuildContext context, String label, int score) {
    final size = MediaQuery.of(context).size;
    final score = scoreRW + scoreMath;
    double progress = score / 1600;

    return SizedBox(
      width: containerWidth,
      height: size.height / 30,
      child: Row(
        children: [
          Container(
            width: containerWidth * progress,
            height: size.height / 30,
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 8),
            child: Text(
              score.toString(),
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.black, fontSize: 14),
            ),
          ),
          SizedBox(width: size.width / 20),
          Text(
            label,
            style:
                TextStyle(fontFamily: 'opensan', fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }

  Widget buildWeaknessContainer() {
    return Container(
      width: containerWidth,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      CombinedProgress(Progress: true, Weak: false),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    return ScaleTransition(
                      scale: Tween<double>(begin: 0.8, end: 1.0)
                          .animate(animation),
                      child: child,
                    );
                  },
                ),
              );
            },
            child: buildWeakPoint(Icons.sentiment_very_satisfied, 'Great'),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      CombinedProgress(Progress: false, Weak: true),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    return ScaleTransition(
                      scale: Tween<double>(begin: 0.8, end: 1.0)
                          .animate(animation),
                      child: child,
                    );
                  },
                ),
              );
            },
            child: buildWeakPoint(Icons.person_rounded, 'Weak'),
          ),
        ],
      ),
    );
  }

  Widget buildWeakPoint(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, size: 50, color: Colors.white),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

const double containerWidth = 300;
const double containerHeight = 200;
