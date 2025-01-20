import 'package:flutter/material.dart';
import '../app_bar.dart';
import '../score_n_progress/progress_screen.dart';
import 'dart:math';
import 'hangman_wordlist.dart';

class Hangman extends StatefulWidget {
  const Hangman({super.key, this.testVersion = false});

  final bool testVersion;

  @override
  State<Hangman> createState() => _Hangman();
}

const qwerty = [
  ['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P'],
  ['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L'],
  ['Z', 'X', 'C', 'V', 'B', 'N', 'M'],
];
var blocked = List.generate(
  qwerty.length,
  (i) => List.generate(qwerty[i].length, (j) => false),
);

class _Hangman extends State<Hangman> {
  int act = 0;
  int actRow = 0;
  int mistakes = 0;
  String password = "";
  final guessedKeys = <String>[];
  final guessedKeys2 = <String>[];
  final notGuessedKeys = <String>[];

  final cText = TextEditingController();

  void tappedKey(BuildContext context, int row, int indx) {
    if (mistakes != 8) {
      setState(() {
        String tappedLetter = qwerty[row][indx];
        bool found = false;
        for (int i = 0; i < noun.length; i++) {
          if (tappedLetter == noun[i]) {
            currentWord = currentWord.substring(0, i) +
                noun[i] +
                currentWord.substring(i + 1);
            found = true;
          }
        }
        if (found == false && !blocked[row][indx]) {
          mistakes++;
        }
        if (mistakes == 8 || currentWord.toLowerCase() == noun.toLowerCase()) {
          currentWord = noun;
          Future.delayed(const Duration(seconds: 3), () {
            if (context.mounted) {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProgressScreen(
                    name: "idioms",
                    userScore: mistakes.toDouble(),
                    maxScore: 8,
                    txt: "You got",
                    pointAlternative: "letters wrong",
                    exercise: 'Hangman',
                  ),
                ),
              );
            }
          });
        }
        blocked[row][indx] = true;
      });
    }
  }

  Row buildKey(BuildContext context, int row, int indx) {
    Size size = MediaQuery.of(context).size;
    return Row(
      children: [
        InkWell(
          onTap: () {
            tappedKey(context, row, indx);
          },
          child: Container(
            height: 0.055 * size.height,
            width: 0.085 * size.width,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              color: (!blocked[row][indx]
                  ? Theme.of(context).colorScheme.primary
                  : (Theme.of(context).brightness == Brightness.dark
                      ? const Color(0xFFD4CDF4)
                      : const Color(0xFF231942))),
            ),
            child: Center(
              child: Text(
                qwerty[row][indx].toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: (qwerty[row][indx].length == 1)
                      ? 0.04 * size.width
                      : 0.03 * size.width,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 0.008 * size.width),
      ],
    );
  }

  List<List<int>> guessed = List.generate(7, (i) => List.generate(6, (j) => 0));

  List<List<String>> letters =
      List.generate(7, (i) => List.generate(7, (j) => ''));

  String noun = "";
  String currentWord = "";

  String repeat(String s, int times) {
    return List.filled(times, s).join('');
  }

  @override
  void initState() {
    super.initState();
    var rng = Random();
    noun = wordlist[rng.nextInt(wordlist.length)].toUpperCase();
    for (int i = 0; i < noun.length; i++) {
      currentWord += '_';
    }
    blocked = List.generate(
      qwerty.length,
      (i) => List.generate(qwerty[i].length, (j) => false),
    );
    int givenLetterIdx = rng.nextInt(noun.length);

    String currentWord2 = repeat('_', givenLetterIdx) +
        noun[givenLetterIdx] +
        repeat('_', noun.length - givenLetterIdx - 1);

    setState(() {
      password = noun;
      currentWord = currentWord2;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: appBar(context, ""),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(
            left: size.width / 30,
            right: size.width / 30,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Builder(
                builder: (context) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 0.03 * size.height),
                      Container(
                        margin: EdgeInsets.only(
                          left: size.width / 20,
                          right: size.width / 20,
                        ),
                        child: Text(
                          '$mistakes letters mistaken',
                          style: TextStyle(
                            fontSize: size.width / 20,
                            fontWeight: FontWeight.w500,
                            color: (Theme.of(context).brightness ==
                                    Brightness.dark)
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(height: 0.03 * size.height),
                      Center(
                        child: SizedBox(
                          width: 0.7 * size.width,
                          height: mistakes == 8 ? null : 0.4 * size.height,
                          child: Image.asset(
                            'assets/linguistic/hangman/${mistakes + ((Theme.of(context).brightness == Brightness.dark) ? 9 : 0)}.png',
                            fit: BoxFit.cover,
                            gaplessPlayback: true,
                          ),
                        ),
                      ),
                      SizedBox(height: 0.04 * size.height),
                      Center(
                        child: Text(
                          currentWord,
                          style: TextStyle(
                            fontSize: size.width / 10,
                            letterSpacing: 7,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Monospace',
                            color: (Theme.of(context).brightness ==
                                    Brightness.dark)
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(height: 0.04 * size.height),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              10,
                              (index) => buildKey(context, 0, index),
                            ),
                          ),
                          SizedBox(height: 0.005 * size.height),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              9,
                              (index) => buildKey(context, 1, index),
                            ),
                          ),
                          SizedBox(height: 0.005 * size.height),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              7,
                              (index) => buildKey(context, 2, index),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
