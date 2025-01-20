import 'package:flutter/material.dart';
import '../../app_bar.dart';
import '../../buttons.dart';
import 'reading_comprehension.dart';

class ReadingComprehensionInfo extends StatefulWidget {
  const ReadingComprehensionInfo({
    this.initialTest = false,
    this.endingTest = false,
    super.key,
  });

  final bool initialTest;
  final bool endingTest;

  @override
  State<ReadingComprehensionInfo> createState() => _ReadingComprehensionInfo();
}

class _ReadingComprehensionInfo extends State<ReadingComprehensionInfo> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: appBar(context, ""),
      body: Container(
        margin: EdgeInsets.only(
          left: size.width / 15,
          right: size.width / 15,
          bottom: size.height / 10,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: Text(
                "Linguistic",
                style: TextStyle(fontSize: 0.14 * size.width),
                textAlign: TextAlign.center,
              ),
            ),
            Center(
              child: Text(
                "Intelligence",
                style: TextStyle(fontSize: 0.08 * size.width),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 0.04 * size.height),
            Text(
              " Exercise 2 - Reading Comprehension",
              style: TextStyle(fontSize: 0.05 * size.width),
              textAlign: TextAlign.start,
            ),
            SizedBox(height: 0.04 * size.height),
            Text(
              "In this exercise, you will be presented with a passage of 500-900 words, followed by 10 multiple-choice questions. You will be able to go back to the reading passage at any time. When you are ready to start, click CONTINUE.",
              style: TextStyle(fontSize: size.height / 50),
            ),
            const Spacer(),
            Center(
              child: SizedBox(
                height: size.height * 0.05,
                width: size.width * 0.75,
                child: RedirectButton(
                  route: ReadingComprehension(
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
