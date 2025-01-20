import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';
import '../score_n_progress/progress_screen.dart';
import '../app_bar.dart';
import 'package:page_transition/page_transition.dart';

class FindTheNumber extends StatefulWidget {
  const FindTheNumber({super.key});

  @override
  State<FindTheNumber> createState() => _FindTheNumber();
}

class _FindTheNumber extends State<FindTheNumber> {
  double score = 0;
  late Timer _timer;
  int _time = 20;
  int excludedNumber = Random().nextInt(10);
  //int x = 0, y = 0;
  late List<List<int>> randomNumbers = List.generate(
    10,
        (_) => List.generate(
      8,
          (_) {
        int randomNum;
        do {
          randomNum = Random().nextInt(10);
        } while (randomNum == excludedNumber);
        return randomNum;
      },
    ),
  );

  /*int x = Random().nextInt(10);
  int y = Random().nextInt(8);
  randomNumbers[1][1] = excludedNumber;*/

  int x = Random().nextInt(7);
  int y = Random().nextInt(9);

  GestureDetector createButton(BuildContext context, int i, int j) {
    final bool isCorrectNumber = randomNumbers[i][j] == excludedNumber;
    return GestureDetector(
      onTap: isCorrectNumber ? () {
        setState(() {
          if (randomNumbers[i][j] == excludedNumber) {
            ++score;
          }
          int randomNum;
          do {
            randomNum = Random().nextInt(10);
          } while (randomNum == excludedNumber);
          excludedNumber = randomNum;
          randomNumbers = List.generate(
            10,
                (_) => List.generate(
              8,
                  (_) {
                int randomNum;
                do {
                  randomNum = Random().nextInt(10);
                } while (randomNum == excludedNumber);
                return randomNum;
              },
            ),
          );
          x = Random().nextInt(7);
          y = Random().nextInt(9);
          randomNumbers[y][x] = excludedNumber;
        });
        if (i == y && j == x) {
          ++score;
        }
      } : null,
      child: Container(
        width: MediaQuery.of(context).size.width / 10,
        height: MediaQuery.of(context).size.height / 22,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            randomNumbers[i][j].toString(),
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width / 12,
              fontWeight: FontWeight.bold,
              //color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    startTimer();

    setState(() {
      randomNumbers[y][x] = excludedNumber;
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void startTimer() {
    _timer = Timer.periodic(
      const Duration(seconds: 1),
          (timer) {
        setState(
              () {
            _time--;
            if (_time <= 0) {
              Navigator.pop(context);
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.fade,
                  child: ProgressScreen(
                    name: "find_the_number",
                    userScore: score.toDouble(),
                    maxScore: 10,
                    exercise: "FindTheNumber",
                  ),
                  reverseDuration: const Duration(milliseconds: 100),
                  opaque: true,
                ),
              );
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: appBar(context, ""),
      body: SingleChildScrollView(
        child: Container(
          width: size.width * 0.9,
          height: size.height * 0.9,
          margin: EdgeInsets.only(
            left: size.width / 10,
            right: size.width / 10,
            top: size.height / 30,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Text(
                  "ATTENTION",
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
                "Exercise 1 - Find The Number",
                style: TextStyle(fontSize: size.width / 20),
              ),
              SizedBox(
                height: size.height / 25,
              ),
              Row(
                children: [
                  const SizedBox(width: 30.0),
                  Text(
                    "Find",
                    style: TextStyle(fontSize: size.width / 20),
                  ),
                  SizedBox(width: 0.05 * size.width),
                  Text(
                    excludedNumber.toString(),
                    style: TextStyle(
                      fontSize: 0.07 * size.height,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.timer,
                    size: 0.08 * min(size.width, size.height),
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 10.0),
                  Text(
                    "${_time.toString()} s",
                    style: TextStyle(
                      fontSize: 0.018 * size.height,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(width: 30.0),
                ],
              ),
              SizedBox(height: 0.02 * size.height),
              Column(
                children: List.generate(
                  10,
                      (i) {
                    return Row(
                      children: List.generate(
                        8,
                            (j) {
                          return createButton(
                            context,
                            i,
                            j,
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
