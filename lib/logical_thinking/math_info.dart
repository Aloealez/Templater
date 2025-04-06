import 'package:flutter/material.dart';
import '../buttons.dart';

class LogicalThinking extends StatefulWidget {
  final bool initialTest;
  final bool endingTest;

  const LogicalThinking({
    this.initialTest = false,
    this.endingTest = false,
    super.key,
  });

  @override
  State<LogicalThinking> createState() => _LogicalThinking();
}

class _LogicalThinking extends State<LogicalThinking> {
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
          left: size.width / 15,
          right: size.width / 15,
          bottom: size.height / 10,
        ),
        child: Column(
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
              "Exercise 1 - Math practice",
              style: TextStyle(fontSize: 0.025 * size.height),
            ),
            SizedBox(height: 0.04 * size.height),
            RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 0.022 * size.height,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                children: const [
                  TextSpan(
                    text: "In this exercises you will complete part of the ",
                  ),
                  TextSpan(
                    text: "SAT Math with CALCULATOR",
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  TextSpan(
                    text: " Part.",
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
                    text: "You will have ",
                  ),
                  TextSpan(
                    text: "350 seconds",
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  TextSpan(
                    text: ".",
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
                    text: "CONTINUE\"",
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  TextSpan(
                    text: ".",
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
                  route: const Text("nie"),
                  text: 'Continue',
                  width: size.width,
                ),
              ),
            ),
            //SizedBox(height: 0.1 * size.height),
          ],
        ),
      ),
    );
  }
}
