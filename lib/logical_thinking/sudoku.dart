import 'package:brainace_pro/buttons.dart';
import 'package:brainace_pro/logical_thinking/sudoku_info.dart';
import 'package:flutter/material.dart';
import 'package:sudoku_dart/sudoku_dart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';
import '../app_bar.dart';
import '../score_n_progress/progress_screen.dart';

class SudokuGame extends StatefulWidget {
  const SudokuGame({super.key});

  static SudokuGame routeBuilder(
      BuildContext context, {
        required bool initialTest,
        required bool endingTest,
      }) {
    return SudokuGame(
    );
  }

  @override
  State<SudokuGame> createState() => _SudokuGame();
}

class _SudokuGame extends State<SudokuGame> {
  Sudoku sudoku = Sudoku.generate(Level.easy);
  late SharedPreferences prefs;
  int lastScore = 10;

  Future<void> initMemory() async {
    prefs = await SharedPreferences.getInstance();

    List<String> scores = prefs.getStringList(
          "sudoku_scores",
        ) ??
        [];

    setState(() {
      if (scores.isEmpty) {
        lastScore = 0;
      } else {
        lastScore = double.parse(scores[scores.length - 1]).round();
      }

      if (lastScore < 5) {
        sudoku = Sudoku.generate(Level.easy);
      } else if (lastScore >= 5 && lastScore < 10) {
        sudoku = Sudoku.generate(Level.medium);
      } else if (lastScore >= 10 && lastScore < 15) {
        sudoku = Sudoku.generate(Level.hard);
      } else if (lastScore >= 15) {
        sudoku = Sudoku.generate(Level.expert);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      initMemory();
    });
    tappedCol = tappedRow = null;
    sudoku = Sudoku.generate(Level.easy);
    /*Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProgressScreen(
          name: "sudoku",
          score: lastScore + 1,
          txt: "You now have",
        ),
      ),
    );*/
  }

  int? tappedCol, tappedRow;
  List<int> sudoku2 = List<int>.generate(100, (index) => -1);

  BorderRadius _getBorderRadius(int rowIndex, int colIndex) {
    if (rowIndex == 0 && colIndex == 0) {
      return const BorderRadius.only(topLeft: Radius.circular(15));
    } else if (rowIndex == 0 && colIndex == 8) {
      return const BorderRadius.only(topRight: Radius.circular(15));
    } else if (rowIndex == 8 && colIndex == 0) {
      return const BorderRadius.only(bottomLeft: Radius.circular(15));
    } else if (rowIndex == 8 && colIndex == 8) {
      return const BorderRadius.only(bottomRight: Radius.circular(15));
    } else {
      return BorderRadius.zero;
    }
  }

  bool checkSudoku() {
    for (int i = 0; i < 81; ++i) {
      if (sudoku2[i] != -1 && sudoku2[i] != sudoku.solution[i]) {
        return false;
      }
    }
    return true;
  }

  GestureDetector buildNumerButton(
    BuildContext context,
    int indx,
    int? tappedRow,
    int? tappedCol,
  ) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        if (tappedRow != null && tappedCol != null) {
          setState(() {
            if (sudoku.puzzle[9 * tappedRow + tappedCol] != -1) {
              return;
            }
            sudoku2[9 * tappedRow + tappedCol] = indx;
            int cnt = 0;
            for (int i = 0; i < 81; ++i) {
              if (sudoku2[i] != -1 || sudoku.puzzle[i] != -1) {
                ++cnt;
              }
            }
            if (cnt == 81) {
              if (checkSudoku()) {
                lastScore++;
              } else {
                lastScore--;
              }
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProgressScreen(
                    userScore: lastScore.toDouble(),
                    maxScore: 20.0,
                    txt: "You now have",
                    exercise: 'SudokuGame',
                  ),
                ),
              );
            }
          });
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.shadow.withOpacity(0.2),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(5, 5),
            ),
          ],
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: (Theme.of(context).brightness == Brightness.light)
                ? <Color>[
                    Colors.white,
                    const Color.fromARGB(255, 225, 220, 233),
                  ]
                : <Color>[
                    Theme.of(context).colorScheme.surface,
                    const Color.fromARGB(255, 31, 0, 56),
                  ],
            tileMode: TileMode.decal,
          ),
          border: Border.all(color: Theme.of(context).colorScheme.primary),
        ),
        height: 0.15 * size.width,
        width: 0.15 * size.width,
        child: Center(
          child: Text(
            indx.toString(),
            style: TextStyle(
              fontSize: 0.07 * size.width,
              fontWeight: FontWeight.w700,
              color: (Theme.of(context).brightness == Brightness.light)
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    Color color = Theme.of(context).colorScheme.secondary;
    if (Theme.of(context).brightness == Brightness.dark) {
      color = Colors.white;
    }

    return Scaffold(
      appBar: appBar(context, ""),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(
            left: size.width / 15,
            right: size.width / 15,
            bottom: size.height / 10,
          ),
          child: Column(
            children: [
              SizedBox(height: 0.03 * size.height),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        if (tappedRow != null && tappedCol != null) {
                          sudoku2[9 * tappedRow! + tappedCol!] = -1;
                        }
                      });
                    },
                    child: Stack(
                      alignment: AlignmentDirectional.center,
                      children: [
                        Container(
                          width: 0.1 * min(size.width, size.height),
                          height: 0.1 * min(size.width, size.height),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        Icon(
                          size: 0.06 * min(size.width, size.height),
                          Icons.backspace,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                  const InstructionsButton(SudokuInfo()),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Stack(
                        alignment: AlignmentDirectional.center,
                        children: [
                          Container(
                            width: 0.1 * min(size.width, size.height),
                            height: 0.1 * min(size.width, size.height),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          Text(
                            lastScore.toString(),
                            style: TextStyle(
                              fontSize: 0.06 * min(size.width, size.height),
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 0.03 * size.width),
                      Text(
                        "Points",
                        style: TextStyle(
                          fontSize: 0.05 * min(size.width, size.height),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Text(
                "Level 1",
                style: TextStyle(
                  fontSize: 0.05 * size.width,
                ),
              ),
              SizedBox(height: 0.01 * size.height),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color:
                          Theme.of(context).colorScheme.shadow.withOpacity(0.4),
                      spreadRadius: 3,
                      blurRadius: 7,
                      offset: const Offset(4, 8),
                    ),
                  ],
                ),
                child: Table(
                  border: TableBorder.all(
                    width: 0.5,
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  children: List.generate(
                    9,
                    (rowIndex) => TableRow(
                      children: List.generate(
                        9,
                        (colIndex) => InkWell(
                          onTap: () {
                            setState(() {
                              tappedCol = colIndex;
                              tappedRow = rowIndex;
                            });
                          },
                          child: Container(
                            height: 0.1 * size.width,
                            width: 0.1 * size.width,
                            decoration: BoxDecoration(
                              color: (tappedCol == colIndex ||
                                      tappedRow == rowIndex)
                                  ? (Theme.of(context).brightness ==
                                          Brightness.light)
                                      ? (tappedCol == colIndex &&
                                              tappedRow == rowIndex)
                                          ? const Color.fromARGB(
                                              255,
                                              178,
                                              177,
                                              250,
                                            )
                                          : const Color.fromARGB(
                                              255,
                                              223,
                                              214,
                                              255,
                                            )
                                      : (tappedCol == colIndex &&
                                              tappedRow == rowIndex)
                                          ? const Color.fromARGB(
                                              255,
                                              93,
                                              14,
                                              129,
                                            )
                                          : const Color.fromARGB(255, 38, 0, 70)
                                  : Theme.of(context).colorScheme.surface,
                              borderRadius:
                                  _getBorderRadius(rowIndex, colIndex),
                              border: Border(
                                bottom: BorderSide(
                                  color: Theme.of(context).colorScheme.primary,
                                  width: (rowIndex == 2 || rowIndex == 5)
                                      ? 2.0
                                      : 0.5,
                                ),
                                right: BorderSide(
                                  color: Theme.of(context).colorScheme.primary,
                                  width: (colIndex == 2 || colIndex == 5)
                                      ? 2.0
                                      : 0.5,
                                ),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                (sudoku.puzzle[9 * rowIndex + colIndex] == -1)
                                    ? (sudoku2[9 * rowIndex + colIndex] == -1)
                                        ? ' '
                                        : '${sudoku2[9 * rowIndex + colIndex]}'
                                    : '${sudoku.puzzle[9 * rowIndex + colIndex]}',
                                style: TextStyle(
                                  fontSize: 0.05 * size.width,
                                  fontWeight:
                                      (sudoku2[9 * rowIndex + colIndex] == -1)
                                          ? FontWeight.w900
                                          : FontWeight.w300,
                                  color: color,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 0.05 * size.height),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(
                  5,
                  (index) => buildNumerButton(
                    context,
                    index + 1,
                    tappedRow,
                    tappedCol,
                  ),
                ),
              ),
              SizedBox(height: 0.02 * size.height),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(width: 0.07 * size.width),
                  ...List.generate(
                    4,
                    (index) => buildNumerButton(
                      context,
                      index + 6,
                      tappedRow,
                      tappedCol,
                    ),
                  ),
                  SizedBox(width: 0.07 * size.width),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
