import 'package:flutter/material.dart';
import '../app_bar.dart';
import '../buttons.dart';
import 'memory_game2.dart';

class MemoryGame1 extends StatefulWidget {
  const MemoryGame1({super.key});

  @override
  State<MemoryGame1> createState() => _MemoryGame1();
}

class _MemoryGame1 extends State<MemoryGame1> {
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
                "Memory",
                style: TextStyle(fontSize: 0.06 * size.height),
                textAlign: TextAlign.center,
              ),
            ),
            Text(
              "Exercise 1 - Memory Game",
              style: TextStyle(fontSize: 0.025 * size.height),
              textAlign: TextAlign.start,
            ),
            SizedBox(height: 0.04 * size.height),
            Center(
              child: SizedBox(
                width: 0.8 * size.width,
                child: RichText(
                  textAlign: TextAlign.left,
                  text: TextSpan(
                    text: 'In the game, you will be presented ',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontStyle: FontStyle.normal,
                      fontSize: size.width / 20,
                      height: 1.2,
                    ),
                    children: const <TextSpan>[
                      TextSpan(
                        text: 'with a set of face-down cards, each featuring a matching pair. ',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      TextSpan(
                        text: 'The objective is to ',
                      ),
                      TextSpan(
                        text: 'flip over two cards at a time, attempting to find matching pairs ',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      TextSpan(
                        text: 'by remembering the locations of previously revealed cards, with the goal of successfully matching all pairs ',
                      ),
                      TextSpan(
                        text: 'in the fewest moves possible.',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 0.04 * size.height),
            Text(
              'When you click “CONTINUE” the stopwatch will begin.',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontStyle: FontStyle.italic,
                fontSize: size.width / 20,
                height: 1.2,
              ),
            ),
            const Spacer(),
            Center(
              child: SizedBox(
                height: size.height * 0.05,
                width: size.width * 0.75,
                child: RedirectButton(
                  route: const MemoryGame2(),
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
