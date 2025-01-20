import 'dart:math';
import 'package:brainace_pro/buttons.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../app_bar.dart';
import 'colors.dart';
import '/score_n_progress/progress_screen.dart';
import 'info_2048.dart';

class Game2048 extends StatefulWidget {
  const Game2048({super.key});

  @override
  State<Game2048> createState() => _Game2048State();
}

class _Game2048State extends State<Game2048> {
  int prevScore = 0, score = 0, bestScore = 0;
  List<List<int>> prevTiles =
      List.generate(4, (i) => List.generate(4, (j) => 0));
  List<List<int>> tiles = List.generate(4, (i) => List.generate(4, (j) => 0));

  late SharedPreferences prefs;

  List<List<int>> transposeMatrix(List<List<int>> matrix) {
    List<List<int>> result = List.generate(
      matrix[0].length,
      (index) => List<int>.empty(growable: true),
    );

    for (int i = matrix.length - 1; i >= 0; i--) {
      for (int j = matrix[i].length - 1; j >= 0; j--) {
        result[j].add(matrix[i][j]);
      }
    }

    return result;
  }

  void restartGame() {
    setState(() {
      prevScore = 0;
      score = 0;
      prevTiles = List.generate(4, (i) => List.generate(4, (j) => 0));
      tiles = List.generate(4, (i) => List.generate(4, (j) => 0));
      generateNewTile();
    });
  }

  void undoMove() {
    setState(() {
      tiles = prevTiles;
      score = prevScore;
    });
  }

  void move(int direction) {
    prevTiles = tiles;
    prevScore = score;
    List<List<int>> newTiles = tiles;

    for (int i = 0; i < direction; i++) {
      newTiles = transposeMatrix(newTiles);
    }

    for (int i = 3; i > 0; i--) {
      for (int j = 0; j < 4; j++) {
        int I = i;
        while (i < 4 && newTiles[i - 1][j] != 0 && newTiles[i][j] == 0) {
          newTiles[i][j] = newTiles[i - 1][j];
          newTiles[i - 1][j] = 0;
          i++;
        }
        if (i == 4) i--;

        if (newTiles[i][j] == newTiles[i - 1][j]) {
          newTiles[i][j] += newTiles[i - 1][j];
          newTiles[i - 1][j] = 0;
          score += newTiles[i][j];
        }
        i = I;
      }
    }

    for (int i = direction; i < 4; i++) {
      newTiles = transposeMatrix(newTiles);
    }

    setState(() {
      tiles = newTiles;
      bestScore = max(bestScore, score);

      prefs.setInt("bestScore", bestScore);
      generateNewTile();
    });
  }

  void generateNewTile() {
    List<int> emptyTiles = [];
    for (int i = 0; i < 16; i++) {
      if (tiles[i ~/ 4][i % 4] == 0) {
        emptyTiles.add(i);
      }
    }

    if (emptyTiles.isNotEmpty) {
      int index = emptyTiles[Random().nextInt(emptyTiles.length)];
      tiles[index ~/ 4][index % 4] = Random().nextInt(2) == 0 ? 2 : 4;
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          Size size = MediaQuery.of(context).size;

          return Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              child: Container(
                width: size.width / 2,
                height: size.height / 3,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: size.height / 25),
                    Text(
                      "You lose!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: size.width / 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ProgressScreen(
                                  name: "2048",
                                  userScore: score.toDouble(),
                                  maxScore: 2048,
                                  exercise: 'Game2048',
                                ),
                              ),
                            );
                          },
                          child: Container(
                            width: size.width / 7,
                            height: size.width / 7,
                            decoration: BoxDecoration(
                              color: (Theme.of(context).brightness ==
                                      Brightness.light)
                                  ? boardColorLight
                                  : boardColorDark,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(context).colorScheme.shadow,
                                  blurRadius: 6,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.exit_to_app,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: size.height / 25),
                  ],
                ),
              ),
            ),
          );
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
    initMemory();

    generateNewTile();
    prevTiles = tiles;
  }

  Future<void> initMemory() async {
    prefs = await SharedPreferences.getInstance();

    setState(() {
      bestScore = prefs.getInt("bestScore") ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final boardSize = size.width * 0.85;
    final sizePerTile = (boardSize / 4).floorToDouble();
    final tileSize = sizePerTile - 12.0 - (12.0 / 4);

    return Scaffold(
      appBar: appBar(context, ""),
      body: Center(
        child: Container(
          margin: EdgeInsets.only(
            left: size.width * 0.075,
            right: size.width * 0.075,
            top: size.height / 20,
            bottom: size.height / 10,
          ),
          child: Column(
            children: <Widget>[
              Row(
                children: [
                  Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "2048",
                          style: TextStyle(
                            fontSize: size.width / 8,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const InstructionsButton(Info2048()),
                      ],),
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            width: size.width / 5.5,
                            height: size.height / 15,
                            decoration: BoxDecoration(
                              color: (Theme.of(context).brightness ==
                                      Brightness.light)
                                  ? boardColorLight
                                  : boardColorDark,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 6,
                                  offset: const Offset(5, 5),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                "SCORE\n$score",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black.withOpacity(0.3),
                                      blurRadius: 6,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: size.width / 50),
                          Container(
                            width: size.width / 6.5,
                            height: size.height / 15,
                            decoration: BoxDecoration(
                              color: (Theme.of(context).brightness ==
                                      Brightness.light)
                                  ? boardColorLight
                                  : boardColorDark,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 6,
                                  offset: const Offset(5, 5),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                "BEST\n$bestScore",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black.withOpacity(0.3),
                                      blurRadius: 6,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: size.height / 25),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () {
                              undoMove();
                            },
                            child: Container(
                              width: size.width / 10,
                              height: size.width / 10,
                              decoration: BoxDecoration(
                                color: (Theme.of(context).brightness ==
                                        Brightness.light)
                                    ? boardColorLight
                                    : boardColorDark,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 6,
                                    offset: const Offset(5, 5),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.undo,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black.withOpacity(0.3),
                                      blurRadius: 6,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: size.width / 25),
                          InkWell(
                            onTap: () {
                              restartGame();
                            },
                            child: Container(
                              width: size.width / 10,
                              height: size.width / 10,
                              decoration: BoxDecoration(
                                color: (Theme.of(context).brightness ==
                                        Brightness.light)
                                    ? boardColorLight
                                    : boardColorDark,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 6,
                                    offset: const Offset(5, 5),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.restart_alt,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black.withOpacity(0.3),
                                      blurRadius: 6,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: size.height / 15),
              GestureDetector(
                onPanEnd: (details) {
                  double dx = details.velocity.pixelsPerSecond.dx;
                  double dy = details.velocity.pixelsPerSecond.dy;

                  if (dx.abs() < dy.abs()) {
                    if (dy > 0) {
                      move(0);
                    } else if (dy < 0) {
                      move(2);
                    }
                  } else {
                    if (dx > 0) {
                      move(1);
                    } else if (dx < 0) {
                      move(3);
                    }
                  }
                },
                child: Container(
                  height: boardSize,
                  width: boardSize,
                  decoration: BoxDecoration(
                    color: (Theme.of(context).brightness == Brightness.light)
                        ? boardColorLight
                        : boardColorDark,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 6,
                        offset: const Offset(5, 5),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: List.generate(16, (i) {
                      var x = ((i + 1) / 4).ceil();
                      var y = x - 1;

                      var top = y * (tileSize) + (x * 12.0);
                      var z = (i - (4 * y));
                      var left = z * (tileSize) + ((z + 1) * 12.0);

                      return AnimatedPositioned(
                        duration: const Duration(milliseconds: 200),
                        top: top,
                        left: left,
                        child: Container(
                          width: tileSize,
                          height: tileSize,
                          decoration: BoxDecoration(
                            color: (Theme.of(context).brightness ==
                                    Brightness.light)
                                ? tileColorsLight[tiles[i ~/ 4][i % 4]]
                                : tileColorsDark[tiles[i ~/ 4][i % 4]],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              tiles[i ~/ 4][i % 4] == 0
                                  ? ""
                                  : "${tiles[i ~/ 4][i % 4]}",
                              style: TextStyle(
                                fontSize: size.width / 20,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
