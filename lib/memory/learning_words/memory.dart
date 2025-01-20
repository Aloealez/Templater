import 'package:flutter/material.dart';
import 'memory_words.dart';
import '../../buttons.dart';
import '../../app_bar.dart';

class Memory extends StatefulWidget {
  final bool initialTest;
  final bool endingTest;

  const Memory({this.initialTest = false, this.endingTest = false, super.key});

  @override
  State<Memory> createState() => _Memory();
}

class _Memory extends State<Memory> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: appBar(context, ""),
      body: Container(
        margin: EdgeInsets.only(
          left: size.width / 10,
          right: size.width / 10,
        ),
        child: Column(
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                "Memory",
                style: TextStyle(fontSize: 0.06 * size.height),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 0.02 * size.height),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Exercise 1 - Learning",
                  style: TextStyle(fontSize: 0.025 * size.height),
                  textAlign: TextAlign.start,
                ),
                SizedBox(height: 0.02 * size.height),
                Text(
                  "In this exercises you will be given 5 minutes to learn as many words as you can. When you are ready to start, click CONTINUE.",
                  style: TextStyle(fontSize: 0.02 * size.height),
                  textAlign: TextAlign.start,
                ),
              ],
            ),
            const Spacer(),
            Center(
              child: SizedBox(
                height: size.height * 0.05,
                width: size.width * 0.75,
                child: RedirectButton(
                  route: MemoryWords(
                    initialTest: widget.initialTest,
                    endingTest: widget.endingTest,
                  ),
                  text: 'Continue',
                  width: size.width,
                ),
              ),
            ),
            SizedBox(height: 0.1 * size.height),
          ],
        ),
      ),
    );
  }
}
