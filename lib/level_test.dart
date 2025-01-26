import 'package:flutter_quizzes/flutter_quizzes.dart';
import 'package:flutter/material.dart';
import 'package:brainace_pro/buttons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../app_bar.dart';
import 'home.dart';

class LevelTest extends StatefulWidget {
  final int testTime;
  final FutureBuilder? nextRouteBuilder;
  final Widget Function(BuildContext context, {required bool initialTest, required bool endingTest}) testRouteBuilder;
  final String? testTimeDescription;
  final String testActivitiesDescription;
  final String testScoreDescription;
  final bool initialTest;
  final bool endingTest;

  const LevelTest(
      this.testTime, {
        this.nextRouteBuilder,
      required this.testRouteBuilder,
        this.testTimeDescription,
        this.testActivitiesDescription = "The test will comprise two activities, through which we will assess your listening and reading levels in English.",
        this.testScoreDescription = "We will use your score to personalize your app experience.",
        this.initialTest = true,
        this.endingTest = false,
        super.key,
      });

  @override
  State<LevelTest> createState() => _LevelTestState();
}

class _LevelTestState extends State<LevelTest> {
  late SharedPreferences prefs;
  late Map<String, SatsQuestion> questions;

  final String category = "rw";

  Future<void> initSharedPrefs() async {
    prefs = await SharedPreferences.getInstance();
    print("Initialized shared preferences.");
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: appBar(context, ""),
      body: Stack(
        children: [
          Align(
            alignment: Alignment(0, -0.95),
            child: Text(
              "Level Test",
              style: TextStyle(
                fontSize: 0.055 * size.height,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Align(
            alignment: Alignment(0, -0.735),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.access_time, size: size.width * 0.097, color: Theme.of(context).colorScheme.primaryContainer.withAlpha(200)),
                SizedBox(width: 0.02 * size.width),
                Text(
                  "${widget.testTime} minute${widget.testTime != 1 ? 's' : ''}",
                  style: TextStyle(
                    fontSize: 0.029 * size.height,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment(0, 0.075),
            child: Container(
              margin: EdgeInsets.only(
                left: size.width / 10,
                right: size.width / 10,
                bottom: size.height / 50,
              ),
              child: RawScrollbar(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.testTimeDescription != null && widget.testTimeDescription!.isNotEmpty)
                        SizedBox(height: 0.02 * size.height),
                      if (widget.testTimeDescription != null && widget.testTimeDescription!.isNotEmpty)
                        Text(
                          widget.testTimeDescription!,
                          style: TextStyle(
                            fontSize: 0.05 * size.height,
                            height: 1.3,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      Text(
                        widget.testActivitiesDescription,
                        style: TextStyle(
                          fontSize: 0.03 * size.height,
                          height: 1.3,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 0.09 * size.height),
                      Text(
                        widget.testScoreDescription,
                        style: TextStyle(
                          fontSize: 0.03 * size.height,
                          height: 1.3,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
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
                    text: 'Start',
                    width: size.width,
                    route: widget.nextRouteBuilder ?? widget.testRouteBuilder(context, initialTest: widget.initialTest, endingTest: widget.endingTest),
                    popRoute: false,
                  ),
                ),
                SizedBox(width: 0.054 * size.width),
                SizedBox(
                  height: size.height * 0.064,
                  width: size.width * 0.33,
                  child: RedirectButton(
                    text: 'Skip',
                    width: size.width,
                    route: Home(),
                    clearAllWindows: true,
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
