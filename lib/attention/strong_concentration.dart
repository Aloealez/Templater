import 'package:brainace_pro/initial_score_screen.dart';
import 'package:brainace_pro/title_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import '/home.dart';
import '../score_n_progress/progress_screen.dart';
import '/buttons.dart';
import 'package:audioplayers/audioplayers.dart';
import '/app_bar.dart';
import '../score_n_progress/show_improvement.dart';
import 'equations.dart';

class StrongConcentration extends StatefulWidget {
  const StrongConcentration({
    super.key,
    this.initialTest = false,
    this.endingTest = false,
  });

  final bool initialTest;
  final bool endingTest;

  @override
  State<StrongConcentration> createState() => _StrongConcentration();
}

class _StrongConcentration extends State<StrongConcentration> {
  int _id = 0;
  int _remainingTime = 130;
  late Timer _timer;
  final player = AudioPlayer();
  List<double> userAnswers = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

  Future<void> startTimer() async {
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        setState(
          () {
            if (_remainingTime > 0) {
              _remainingTime--;
            } else {
              Navigator.pop(context);
              if (widget.initialTest) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InitialScoreScreen(
                      title: "Attention",
                      description: "Exercise 3 - Strong Concentration",
                      exercise: 3,
                      userScore: countScore(),
                      maxScore: 10,
                      page: const Home(),
                      clearAllWindows: true,
                    ),
                  ),
                );
              } else if (widget.endingTest) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ShowImprovement(
                      title: "Attention",
                      description: "Exercise 3 - Strong Concentration",
                      exercise: 3,
                      yourScore: countScore(),
                      maximum: 10,
                      page: const TitlePage(
                        title: 'BrainAce.pro',
                      ),
                      lastin: true,
                    ),
                  ),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProgressScreen(
                      name: "strong_concentration",
                      userScore: countScore(),
                      maxScore: 10,
                      exercise: 'StrongConcentrationDesc',
                    ),
                  ),
                );
              }
            }
          },
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    startTimer();

    equations.shuffle();
    player.play(AssetSource("attention/distracting_music.mp3"));
    player.setReleaseMode(ReleaseMode.loop);
  }

  Column equation(Row text, Size size, {bool isId = true}) {
    _id++;
    final thisId = _id;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            isId ? Text("$thisId.   ") : const SizedBox(height: 0, width: 0),
            text,
            SizedBox(
              width: size.width / 6,
              height: size.height / 36,
              child: TextField(
                style: TextStyle(fontSize: size.width / 30),
                keyboardType: TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r"[\d.]")),
                  TextInputFormatter.withFunction(
                    (oldValue, newValue) {
                      String text = newValue.text;
                      if (text.isNotEmpty) {
                        userAnswers[thisId - 1] = double.parse(text);
                      }
                      return newValue;
                    },
                  ),
                ],
                maxLines: 1,
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: size.height / 50,
        ),
      ],
    );
  }

  double countScore() {
    double score = 0;

    for (var i = 0; i < 12; i++) {
      if (userAnswers[i] == equations[i][1]) {
        score++;
      }
    }
    return score;
  }

  Row createEquation(double smallText, String text, {bool isId = true}) {
    return Row(
      children: [
        Text(
          text,
          style: TextStyle(fontSize: smallText),
        ),
        const SizedBox(
          width: 5,
        ),
      ],
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    player.audioCache.clearAll();
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _id = 0;
    Size size = MediaQuery.of(context).size;
    final smallText = size.width / 28;
    return Scaffold(
      appBar: appBar(context, ""),
      body: SingleChildScrollView(
        child: Container(
          width: size.width * 0.9,
          margin: EdgeInsets.only(
            left: size.width / 10,
            right: size.width / 10,
            //top: size.height / 30,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: Text(
                      "Attention",
                      style: TextStyle(
                        fontSize: size.width / 8,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: size.height / 50,
                  ),
                  Text(
                    "Exercise 3 - Strong Concentration",
                    style: TextStyle(fontSize: size.width / 20),
                  ),
                  SizedBox(
                    height: size.height / 50,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Solve:",
                            style: TextStyle(
                              fontSize: size.width / 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            width: size.width / 2,
                            margin: EdgeInsets.only(
                              left: size.width / 20,
                            ),
                            child: Column(
                              children: List.generate(12, (index) {
                                return equation(
                                  createEquation(
                                    smallText,
                                    equations[index][0].toString(),
                                  ),
                                  size,
                                );
                              }),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(
                            Icons.timer,
                            size: 0.08 * size.width,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 10.0),
                          Text(
                            "${_remainingTime.toString()}s",
                            style: TextStyle(fontSize: size.width / 20),
                            textAlign: TextAlign.start,
                          ),
                          SizedBox(
                            height: size.height / 25,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: size.height / 25,
              ),
              SizedBox(
                height: size.height * 0.05,
                width: size.width * 0.75,
                child: RedirectButton(
                  route: (widget.initialTest)
                      ? InitialScoreScreen(
                          title: "Attention",
                          description: "Exercise 3 - Strong Concentration",
                          exercise: 3,
                          userScore: countScore(),
                          maxScore: 10,
                          page: const Home(),
                          clearAllWindows: true,
                        )
                      : (widget.endingTest
                          ? ShowImprovement(
                              title: "Attention",
                              description: "Exercise 3 - Strong Concentration",
                              exercise: 3,
                              yourScore: countScore(),
                              maximum: 10,
                              page: const TitlePage(
                                title: 'BrainAce.pro',
                              ),
                              lastin: true,
                            )
                          : ProgressScreen(
                              name: "strong_concentration",
                              userScore: countScore(),
                              maxScore: 10,
                              exercise: 'StrongConcentrationDesc',
                            )),
                  text: 'Continue',
                  width: size.width,
                  // requirement: userAnswers.every((element) => element != 0),
                ),
              ),
              SizedBox(
                height: size.height / 25,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
