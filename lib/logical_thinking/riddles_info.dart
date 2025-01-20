import 'package:flutter/material.dart';
import '../buttons.dart';

import 'riddles.dart';

class Riddles extends StatefulWidget {
  final bool initialTest;
  final bool endingTest;

  const Riddles({this.initialTest = false, this.endingTest = false, super.key});

  @override
  State<Riddles> createState() => _Riddles();
}

class _Riddles extends State<Riddles> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(
          left: size.width / 10,
          right: size.width / 10,
          bottom: size.height / 10,
          top: size.height / 15,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 0.05 * size.height),
            Align(
              alignment: Alignment.center,
              child: Column(
                children: [
                  Text(
                    "Logical",
                    style: TextStyle(fontSize: 0.08 * size.height),
                  ),
                  Text(
                    "Thinking",
                    style: TextStyle(fontSize: 0.035 * size.height),
                  ),
                ],
              ),
            ),
            SizedBox(height: 0.03 * size.height),
            Text(
              "Exercise 1 - Math riddles",
              style: TextStyle(fontSize: 0.025 * size.height),
            ),
            SizedBox(height: 0.04 * size.height),
            RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 0.02 * size.height,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                children: const [
                  TextSpan(
                    text: "In this exercises you will complete part of the ",
                  ),
                  TextSpan(
                    text: "8 minutes to solve as many riddles as you can.",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizedBox(height: 0.015 * size.height),
            RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 0.02 * size.height,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                children: const [
                  TextSpan(
                    text: "For each ",
                  ),
                  TextSpan(
                    text: "correct answer ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: "you will ",
                  ),
                  TextSpan(
                    text: "get 5 points, ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: "for each ",
                  ),
                  TextSpan(
                    text: "wrong answer ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: "you will ",
                  ),
                  TextSpan(
                    text: "loose 2 points.",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizedBox(height: 0.015 * size.height),
            RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 0.022 * size.height,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                children: const [
                  TextSpan(
                    text: "When ready click \"",
                  ),
                  TextSpan(
                    text: "CONTINUE",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: ".\"",
                  ),
                ],
              ),
            ),
            const Spacer(),
            Center(
              child: SizedBox(
                height: size.height * 0.05,
                width: size.width * 0.75,
                child: RedirectButton(
                  route: RiddlesTest(
                    initialTest: widget.initialTest,
                    endingTest: widget.endingTest,
                  ),
                  text: 'Continue',
                  width: size.width,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
