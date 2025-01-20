import 'package:flutter/material.dart';
import '../../app_bar.dart';

class WordlyInfo extends StatefulWidget {
  const WordlyInfo({
    super.key,
  });

  @override
  State<WordlyInfo> createState() => _WordlyInfo();
}

class _WordlyInfo extends State<WordlyInfo> {
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
                "INSTRUCTIONS",
                style: TextStyle(fontSize: 0.08 * size.width),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 0.04 * size.height),
            Text(
              "1. Guess a five-letter word. Remember, the word has to be existing English word.",
              style: TextStyle(fontSize: 0.05 * size.width),
            ),
            SizedBox(height: 0.02 * size.height),
            Text(
              "2. Submit your guess by pressing Enter.",
              style: TextStyle(fontSize: 0.05 * size.width),
            ),
            SizedBox(height: 0.02 * size.height),
            Text(
              "3. The game will provide feedback on your guess:",
              style: TextStyle(fontSize: 0.05 * size.width),
            ),
            Text(
              "   - Green: Correct letter in the correct position.",
              style: TextStyle(fontSize: 0.05 * size.width),
            ),
            Text(
              "   - Yellow: Correct letter, but in the wrong position.",
              style: TextStyle(fontSize: 0.05 * size.width),
            ),
            Text(
              "   - Blue: Incorrect letter.",
              style: TextStyle(fontSize: 0.05 * size.width),
            ),
            SizedBox(height: 0.02 * size.height),
            Text(
              "4. Keep guessing until you find the word or run out of attempts.",
              style: TextStyle(fontSize: 0.05 * size.width),
            ),
          ],
        ),
      ),
    );
  }
}
