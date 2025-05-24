import 'package:brainace_pro/score_n_progress/progress_screen.dart';
import 'package:flutter_quizzes/flutter_quizzes.dart';
import 'package:flutter/material.dart';
import 'package:brainace_pro/buttons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../app_bar.dart';

class LevelInstruction extends StatefulWidget {
  final String testName;
  final String testTime;
  final FutureBuilder? nextRouteBuilder;
  final Widget Function(BuildContext context, {required bool initialTest, required bool endingTest}) testRouteBuilder;
  final String? testTimeDescription;
  final String testActivitiesDescription;
  final String testScoreDescription;
  final bool initialTest;
  final bool endingTest;
  final String? exercise;

  const LevelInstruction(
    this.testName, {
    required this.testTime,
    this.nextRouteBuilder,
    required this.testRouteBuilder,
    this.testTimeDescription,
    this.testActivitiesDescription = "The test will comprise of 10 Reading and Writing Questions.",
    this.testScoreDescription = "We will use your score to personalize your app experience.",
    this.initialTest = false,
    this.endingTest = false,
    this.exercise,
    super.key,
  });

  @override
  State<LevelInstruction> createState() => _LevelInstructionState();
}

class _LevelInstructionState extends State<LevelInstruction> {
  late SharedPreferences prefs;

  Future<void> initSharedPrefs() async {
    prefs = await SharedPreferences.getInstance();
    print("Initialized shared preferences.");
  }

  @override
  void initState() {
    super.initState();
    initSharedPrefs(); // Initialize shared preferences
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: appBar(context, ""),
      body: Stack(
        children: [
          Align(
            alignment: Alignment(0, -0.93),
            child: Container(
              margin: EdgeInsets.only(
                left: size.width / 10,
                right: size.width / 10,
                bottom: 0,
              ),
              child: RawScrollbar(
                thumbColor: Theme.of(context).colorScheme.primary,
                radius: const Radius.circular(40),
                thickness: 5,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        widget.testName,
                        style: TextStyle(
                          fontSize: 0.041 * size.height,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 0.02 * size.height),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.access_time, size: size.width * 0.097, color: Theme.of(context).colorScheme.primaryContainer.withAlpha(200)),
                          SizedBox(width: 0.02 * size.width),
                          Text(
                            widget.testTime,
                            style: TextStyle(
                              fontSize: 0.029 * size.height,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment(0, 0.045),
            child: Container(
              margin: EdgeInsets.only(
                left: size.width / 10,
                right: size.width / 10,
                bottom: size.height / 50,
              ),
              child: RawScrollbar(
                thumbColor: Theme.of(context).colorScheme.primary,
                radius: const Radius.circular(40),
                thickness: 5,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.testTimeDescription != null && widget.testTimeDescription!.isNotEmpty) SizedBox(height: 0.02 * size.height),
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
                      SizedBox(height: 0.06 * size.height),
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
                  height: widget.exercise == null ? size.height * 0.065 : size.height * 0.064,
                  width: widget.exercise == null ? size.width * 0.80 : size.width * 0.32,
                  child: GestureDetector(
                    onTap: () async {
                      // Get the future from your testRouteBuilder's FutureBuilder
                      final futureBuilder = widget.nextRouteBuilder ??
                        widget.testRouteBuilder(
                          context,
                          initialTest: widget.initialTest,
                          endingTest: widget.endingTest,
                        );

                      // If it's a FutureBuilder, get its future and await it
                      if (futureBuilder is FutureBuilder) {
                        try {
                          final result = await futureBuilder.future;

                          // Check if the result is valid
                          if (result != null && result.length > 0) {
                            final alreadyDone = result.length > 3 && result[3] == true;

                            if (result.length > 2 && result[2] != null) {
                              // Show error dialog
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('Error'),
                                  content: Text(result[2]),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pop(),
                                      child: Text('OK'),
                                    ),
                                  ],
                                ),
                              );
                            } else if (alreadyDone) {
                              // Show dialog if already completed
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('Already Completed'),
                                  content: Text('You have already completed today\'s riddle.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pop(),
                                      child: Text('Okay'),
                                    ),
                                  ],
                                ),
                              );
                            } else if (result[0] == null) {
                              // Show error dialog if no riddle is available
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('Error'),
                                  content: Text('No riddle is available for today.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pop(),
                                      child: Text('OK'),
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              // Navigate to the quiz page
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => futureBuilder.builder(context, AsyncSnapshot.withData(ConnectionState.done, result)),
                                ),
                              );
                            }
                          }
                        } catch (e) {
                          // Handle unexpected errors
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Error'),
                              content: Text('An unexpected error occurred.'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: Text('OK'),
                                ),
                              ],
                            ),
                          );
                        }
                      } else {
                        // Directly navigate to the riddle of the day if not using FutureBuilder
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => futureBuilder,
                          ),
                        );
                      }
                    },
                    child: Container(
                      width: size.width,
                      padding: EdgeInsets.symmetric(horizontal: size.width / 10),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).colorScheme.shadow,
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          'Start',
                          style: TextStyle(
                            fontSize: size.width / 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                if (widget.exercise != null) SizedBox(width: 0.054 * size.width),
                if (widget.exercise != null)
                  SizedBox(
                    height: size.height * 0.064,
                    width: size.width * 0.45,
                    child: RedirectButton(
                      text: 'Progress',
                      width: size.width,
                      route: ProgressScreen(exercise: widget.exercise!),
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