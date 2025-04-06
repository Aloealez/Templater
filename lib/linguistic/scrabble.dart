import 'package:flutter/material.dart';
import '/buttons.dart';
import 'dart:math';
import 'package:dictionaryx/dictionary_msa_json_flutter.dart';
import '../score_n_progress/progress_screen.dart';
import '/app_bar.dart';

final Map<String, int> scrabblePoints = {
  'A': 1,
  'B': 3,
  'C': 3,
  'D': 2,
  'E': 1,
  'F': 4,
  'G': 2,
  'H': 4,
  'I': 1,
  'J': 8,
  'K': 5,
  'L': 1,
  'M': 3,
  'N': 1,
  'O': 1,
  'P': 3,
  'Q': 10,
  'R': 1,
  'S': 1,
  'T': 1,
  'U': 1,
  'V': 4,
  'W': 4,
  'X': 8,
  'Y': 4,
  'Z': 10,
};

final List<String> vowels = ['A', 'E', 'I', 'O', 'U'];
final List<String> consonants = [
  'B',
  'C',
  'D',
  'F',
  'G',
  'H',
  'J',
  'K',
  'L',
  'M',
  'N',
  'P',
  'Q',
  'R',
  'S',
  'T',
  'V',
  'W',
  'X',
  'Z',
];

class LetterItem {
  String letter;
  int points;

  LetterItem({
    required this.letter,
    required this.points,
  });
}

class Scrabble extends StatefulWidget {
  final int iteration;
  final int allPoints;
  final bool initialTest;
  final bool endingTest;

  const Scrabble({
    required this.iteration,
    required this.allPoints,
    this.initialTest = false,
    this.endingTest = false,
    super.key,
  });
  @override
  State<Scrabble> createState() => _Scrabble();
}

class _Scrabble extends State<Scrabble> {
  final dMSAJson = DictionaryMSAFlutter();

  List usedList = List.generate(9, (index) => false);
  bool wordExists = false;
  int roundPoints = 0;
  List<int> word = [];
  @override
  void initState() {
    super.initState();
  }

  void toggleUnused() {
    setState(() {
      if (word.isNotEmpty) {
        int index = word.removeLast();
        usedList[index] = false;
        roundPoints -= scrabblePoints[picked[index]]!;
        if (word.isNotEmpty) {
          Future<bool> lookupWord() async {
            if (await dMSAJson
                .hasEntry(word.map((e) => picked[e]).join('').toLowerCase())) {
              return true;
            } else {
              return false;
            }
          }

          Future<void> amogus() async {
            wordExists = await lookupWord();
          }

          amogus();
        }
      } else {
        wordExists = false;
      }
    });
  }

  Widget roundedLetterSquare({
    required String letter,
    required bool used,
    required int index,
    int? digit,
  }) {
    void toggleUsed() {
      setState(() {
        if (!usedList[index]) {
          usedList[index] = true;
          word.add(index);
          roundPoints += scrabblePoints[letter]!;

          if (word.isNotEmpty) {
            Future<bool> lookupWord() async {
              if (await dMSAJson.hasEntry(
                word.map((e) => picked[e]).join('').toLowerCase(),
              )) {
                return true;
              } else {
                return false;
              }
            }

            Future<void> amogus() async {
              wordExists = await lookupWord();
            }

            amogus();
          } else {
            wordExists = false;
          }
        }
      });
    }

    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: toggleUsed,
      child: Container(
        width: size.width * 0.14,
        height: size.width * 0.14,
        decoration: BoxDecoration(
          color: (!usedList[index]
              ? Theme.of(context).colorScheme.primary
              : (Theme.of(context).brightness == Brightness.dark
                  ? const Color(0xFFD4CDF4)
                  : const Color(0xFF231942))),
          borderRadius: BorderRadius.circular((size.width * 0.14) / 2.5),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.shadow,
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(5, 5),
            ),
          ],
        ),
        child: Stack(
          children: [
            Center(
              child: Text(
                letter,
                style: TextStyle(
                  shadows: [
                    Shadow(
                      color: Theme.of(context).colorScheme.shadow,
                      blurRadius: 5,
                      offset: const Offset(2, 2),
                    ),
                  ],
                  fontSize: (size.width * 0.14) / 2,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  decoration: TextDecoration.none,
                ),
              ),
            ),
            if (digit != null) // Display the digit if it is not null
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  child: Text(
                    scrabblePoints[letter].toString(),
                    style: TextStyle(
                      shadows: [
                        Shadow(
                          color: Theme.of(context).colorScheme.shadow,
                          blurRadius: 5,
                          offset: const Offset(2, 2),
                        ),
                      ],
                      fontSize: (size.width * 0.14) / 3,
                      color: Colors.white,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget resultLetter({
    required String letter,
  }) {
    Size size = MediaQuery.of(context).size;

    return Container(
      width: size.width * 0.14,
      height: size.width * 0.14,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular((size.width * 0.14) / 2.5),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow,
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(5, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          Center(
            child: Text(
              letter,
              style: TextStyle(
                fontSize: (size.width * 0.14) / 2,
                fontWeight: FontWeight.w500,
                color: Colors.white,
                decoration: TextDecoration.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool isDragged = false;
  List<String> picked = [
    vowels[Random().nextInt(vowels.length)],
    vowels[Random().nextInt(vowels.length)],
    consonants[Random().nextInt(vowels.length)],
    consonants[Random().nextInt(vowels.length)],
    (scrabblePoints.keys.toList())[Random().nextInt(scrabblePoints.length)],
    (scrabblePoints.keys.toList())[Random().nextInt(scrabblePoints.length)],
    (scrabblePoints.keys.toList())[Random().nextInt(scrabblePoints.length)],
    (scrabblePoints.keys.toList())[Random().nextInt(scrabblePoints.length)],
    (scrabblePoints.keys.toList())[Random().nextInt(scrabblePoints.length)],
  ]..shuffle();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: appBar(context, ""),
      body: Center(
        child: Container(
          margin: EdgeInsets.only(
            left: size.width / 11,
            right: size.width / 11,
          ),
          child: Stack(
            children: [
              Align(
                alignment: Alignment(0, -0.95),
                child: Text(
                  "Scrabble",
                  style: TextStyle(
                    fontSize: 0.048 * size.height,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Align(
                alignment: Alignment(0, -0.60),
                child: Wrap(
                  children: List.generate(word.length, (index) {
                    return Container(
                      margin: const EdgeInsets.all(0),
                      child: InkWell(
                        onTap: index == word.length - 1 ? () {
                          toggleUnused();
                        } : null,
                        child: resultLetter(
                          letter: picked[word[index]],
                        ),
                      ),
                    );
                  }),
                ),
              ),
              Align(
                alignment: Alignment(0, -0.75),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "This Word ${wordExists ? "Exists" : "Does Not Exist"}.",
                      style: TextStyle(fontSize: 0.02 * size.height),
                    ),
                    Text(
                      "This Word is worth: $roundPoints points.",
                      style: TextStyle(fontSize: 0.02 * size.height),
                    ),
                    SizedBox(height: 0.07 * size.height),
                    Wrap(
                      alignment: WrapAlignment.center,
                      children: List.generate(9, (index) {
                        return Container(
                          margin: const EdgeInsets.only(right: 4, left: 4),
                          child: roundedLetterSquare(
                            letter: picked[index],
                            used: false,
                            index: index,
                            digit: 1,
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment(0, 0.85),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: size.height * 0.064,
                      width: size.width * 0.39,
                      child: RedirectButton(
                        text: '${widget.allPoints} ${widget.allPoints == 1 ? 'point' : 'points'}',
                        width: size.width,
                        popRoute: false,
                        color: Color(0xFF2EEAE8),
                      ),
                    ),
                    SizedBox(width: 0.051 * size.width),
                    (widget.iteration == 5)
                        ? SizedBox(
                      height: size.height * 0.064,
                      width: size.width * 0.37,
                      child: RedirectButton(
                        route: ProgressScreen(
                          userScore: (widget.allPoints + (wordExists ? roundPoints : 0)).toDouble(),
                          maxScore: 50,
                          exercise: 'Scrabble',
                        ),
                        text: 'End',
                        width: size.width,
                        color: Color(0xFFFF5ACE),
                      ),
                    )
                        : SizedBox(
                      height: size.height * 0.064,
                      width: size.width * 0.37,
                      child: RedirectButton(
                        color: Color(0xFFFF5ACE),
                        onClick: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Scrabble(
                                iteration: widget.iteration + 1,
                                allPoints: wordExists
                                    ? (widget.allPoints + roundPoints)
                                    : widget.allPoints,
                                initialTest: widget.initialTest,
                                endingTest: widget.endingTest,
                              ),
                            ),
                          );
                        },
                        text: '${widget.iteration + 1}${ () {
                          switch (widget.iteration + 1) {
                            case 1:
                              return 'st';
                            case 2:
                              return 'nd';
                            case 3:
                              return 'rd';
                            case 4:
                              return 'th';
                            default:
                              return 'th';
                          }
                        } ()} round',
                        width: size.width,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
