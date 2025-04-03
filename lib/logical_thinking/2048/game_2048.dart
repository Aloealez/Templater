import 'dart:math';
import 'package:brainace_pro/buttons.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../app_bar.dart';
import 'colors.dart';
import '/score_n_progress/progress_screen.dart';
import 'info_2048.dart';

/// Kierunki ruchu
enum Direction { up, down, left, right }

/// Klasa opisująca pojedynczy kafelek
class TileData {
  int id;
  int value;
  int row;
  int col;
  bool merged;

  TileData({
    required this.id,
    required this.value,
    required this.row,
    required this.col,
    this.merged = false,
  });

  TileData copy() {
    return TileData(
      id: id,
      value: value,
      row: row,
      col: col,
      merged: merged,
    );
  }
}

class Game2048 extends StatefulWidget {
  const Game2048({super.key});

  @override
  State<Game2048> createState() => _Game2048State();
}

class _Game2048State extends State<Game2048> {
  /// Używane do zapisu i odczytu najlepszego wyniku
  late SharedPreferences prefs;

  /// Rozmiar planszy (4×4)
  final int boardSize = 4;

  /// Lista kafelków w grze
  List<TileData> _tileData = [];

  /// Poprzedni stan gry (do cofnięcia – undo)
  List<TileData> _prevTileData = [];

  /// Liczniki punktów
  int score = 0;
  int prevScore = 0;
  int bestScore = 0;

  /// ID kafelka – unikatowy identyfikator (rosnący)
  int _tileIdCounter = 0;

  @override
  void initState() {
    super.initState();
    initMemory();
    // Uruchamiamy grę na starcie
    restartGame();
  }

  /// Pobranie instancji SharedPreferences i wczytanie bestScore
  Future<void> initMemory() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      bestScore = prefs.getInt("bestScore") ?? 0;
    });
  }

  /// Resetowanie flag merged (przed każdym ruchem)
  void resetMergedFlags() {
    for (var tile in _tileData) {
      tile.merged = false;
    }
  }

  /// Zapamiętanie stanu (lista kafelków + score) przed ruchem
  void saveState() {
    _prevTileData = _tileData.map((t) => t.copy()).toList();
    prevScore = score;
  }

  /// Cofnięcie ruchu
  void undoMove() {
    setState(() {
      _tileData = _prevTileData.map((t) => t.copy()).toList();
      score = prevScore;
    });
  }

  /// Restart gry – czyści stan, generuje 2 kafelki początkowe, zachowuje bestScore
  void restartGame() {
    setState(() {
      _tileData.clear();
      score = 0;
      _tileIdCounter = 0;
      generateNewTile();
      generateNewTile();
      saveState();
    });
  }

  /// Funkcja wyświetlająca dialog końca gry
  void showGameOverDialog() {
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
                color: Theme.of(context).brightness == Brightness.light
                    ? boardColorLight
                    : boardColorDark,
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
                      color: Theme.of(context).brightness == Brightness.light
                          ? Colors.black
                          : Colors.white,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ProgressScreen(
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
                            color: Theme.of(context).brightness == Brightness.light
                                ? tileColorsLight[0]
                                : tileColorsDark[0],
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

  /// Sprawdza, czy nie ma już wolnych pól *i* żadnych możliwych ruchów
  /// Jeśli tak – koniec gry
  bool noAvailableMoves() {
    // Czy plansza jest pełna (brak wolnych pól)?
    for (int row = 0; row < boardSize; row++) {
      for (int col = 0; col < boardSize; col++) {
        bool occupied = _tileData.any((tile) => tile.row == row && tile.col == col);
        if (!occupied) {
          return false;
        }
      }
    }

    // Sprawdzamy możliwość scalenia sąsiednich kafelków.
    for (int row = 0; row < boardSize; row++) {
      for (int col = 0; col < boardSize; col++) {
        final tile = _tileData.firstWhere(
              (t) => t.row == row && t.col == col,
          orElse: () => TileData(id: -1, value: -1, row: -1, col: -1),
        );
        if (tile.id == -1) continue;

        final neighbors = [
          [row, col + 1],
          [row, col - 1],
          [row + 1, col],
          [row - 1, col],
        ];

        for (var n in neighbors) {
          int nx = n[0];
          int ny = n[1];
          if (nx >= 0 && nx < boardSize && ny >= 0 && ny < boardSize) {
            final neighborTile = _tileData.firstWhere(
                  (t) => t.row == nx && t.col == ny,
              orElse: () => TileData(id: -1, value: -1, row: -1, col: -1),
            );
            if (neighborTile.value == tile.value) {
              return false;
            }
          }
        }
      }
    }
    return true;
  }

  void generateNewTile() {
    List<Point<int>> freePositions = [];
    for (int row = 0; row < boardSize; row++) {
      for (int col = 0; col < boardSize; col++) {
        if (!_tileData.any((tile) => tile.row == row && tile.col == col)) {
          freePositions.add(Point(row, col));
        }
      }
    }

    if (freePositions.isNotEmpty) {
      int minFreeNeighbors = 5; // maksymalnie 4 sąsiadów
      List<Point<int>> candidatePositions = [];
      for (Point<int> pos in freePositions) {
        int freeNeighbors = 0;
        List<Point<int>> neighbors = [
          Point(pos.x - 1, pos.y),
          Point(pos.x + 1, pos.y),
          Point(pos.x, pos.y - 1),
          Point(pos.x, pos.y + 1),
        ];
        for (Point<int> n in neighbors) {
          if (n.x >= 0 && n.x < boardSize && n.y >= 0 && n.y < boardSize) {
            if (!_tileData.any((tile) => tile.row == n.x && tile.col == n.y)) {
              freeNeighbors++;
            }
          }
        }
        if (freeNeighbors < minFreeNeighbors) {
          minFreeNeighbors = freeNeighbors;
          candidatePositions = [pos];
        } else if (freeNeighbors == minFreeNeighbors) {
          candidatePositions.add(pos);
        }
      }
      final chosenPos = candidatePositions[Random().nextInt(candidatePositions.length)];
      setState(() {
        _tileData.add(
          TileData(
            id: _tileIdCounter++,
            value: Random().nextBool() ? 2 : 4,
            row: chosenPos.x,
            col: chosenPos.y,
          ),
        );
      });
    } else {
      if (noAvailableMoves()) {
        showGameOverDialog();
      }
    }
  }

  void move(int direction) {
    Direction dir;
    switch (direction) {
      case 0:
        dir = Direction.down;
        break;
      case 1:
        dir = Direction.right;
        break;
      case 2:
        dir = Direction.up;
        break;
      case 3:
        dir = Direction.left;
        break;
      default:
        return;
    }

    bool moved = false;
    saveState();
    resetMergedFlags();

    if (dir == Direction.left || dir == Direction.right) {
      for (int row = 0; row < boardSize; row++) {
        List<TileData> rowTiles = _tileData.where((t) => t.row == row).toList();
        if (dir == Direction.left) {
          rowTiles.sort((a, b) => a.col.compareTo(b.col));
        } else {
          rowTiles.sort((a, b) => b.col.compareTo(a.col));
        }
        for (TileData tile in rowTiles) {
          if (dir == Direction.left) {
            for (int col = tile.col - 1; col >= 0; col--) {
              if (!_tileData.any((t) => t.row == row && t.col == col)) {
                tile.col = col;
                moved = true;
              } else {
                TileData? other;
                try {
                  other = _tileData.firstWhere((t) => t.row == row && t.col == col);
                } catch (e) {
                  other = null;
                }
                if (other != null &&
                    other.value == tile.value &&
                    !other.merged &&
                    !tile.merged) {
                  other.value *= 2;
                  other.merged = true;
                  score += other.value;
                  _tileData.removeWhere((t) => t.id == tile.id);
                  moved = true;
                }
                break;
              }
            }
          } else {
            for (int col = tile.col + 1; col < boardSize; col++) {
              if (!_tileData.any((t) => t.row == row && t.col == col)) {
                tile.col = col;
                moved = true;
              } else {
                TileData? other;
                try {
                  other = _tileData.firstWhere((t) => t.row == row && t.col == col);
                } catch (e) {
                  other = null;
                }
                if (other != null &&
                    other.value == tile.value &&
                    !other.merged &&
                    !tile.merged) {
                  other.value *= 2;
                  other.merged = true;
                  score += other.value;
                  _tileData.removeWhere((t) => t.id == tile.id);
                  moved = true;
                }
                break;
              }
            }
          }
        }
      }
    } else {
      for (int col = 0; col < boardSize; col++) {
        List<TileData> colTiles = _tileData.where((t) => t.col == col).toList();
        if (dir == Direction.up) {
          colTiles.sort((a, b) => a.row.compareTo(b.row));
        } else {
          colTiles.sort((a, b) => b.row.compareTo(a.row));
        }
        for (TileData tile in colTiles) {
          if (dir == Direction.up) {
            for (int row = tile.row - 1; row >= 0; row--) {
              if (!_tileData.any((t) => t.col == col && t.row == row)) {
                tile.row = row;
                moved = true;
              } else {
                TileData? other;
                try {
                  other = _tileData.firstWhere((t) => t.col == col && t.row == row);
                } catch (e) {
                  other = null;
                }
                if (other != null &&
                    other.value == tile.value &&
                    !other.merged &&
                    !tile.merged) {
                  other.value *= 2;
                  other.merged = true;
                  score += other.value;
                  _tileData.removeWhere((t) => t.id == tile.id);
                  moved = true;
                }
                break;
              }
            }
          } else {
            for (int row = tile.row + 1; row < boardSize; row++) {
              if (!_tileData.any((t) => t.col == col && t.row == row)) {
                tile.row = row;
                moved = true;
              } else {
                TileData? other;
                try {
                  other = _tileData.firstWhere((t) => t.col == col && t.row == row);
                } catch (e) {
                  other = null;
                }
                if (other != null &&
                    other.value == tile.value &&
                    !other.merged &&
                    !tile.merged) {
                  other.value *= 2;
                  other.merged = true;
                  score += other.value;
                  _tileData.removeWhere((t) => t.id == tile.id);
                  moved = true;
                }
                break;
              }
            }
          }
        }
      }
    }

    if (moved) {
      setState(() {
        bestScore = max(bestScore, score);
        prefs.setInt("bestScore", bestScore);
      });
      Future.delayed(const Duration(milliseconds: 300), () {
        generateNewTile();
      });
    } else {
      if (noAvailableMoves()) {
        showGameOverDialog();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final boardSizePx = size.width * 0.85;
    final tileSize = (boardSizePx / 4) - 12 - (12 / 4);

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
                    ],
                  ),
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
                            onTap: undoMove,
                            child: Container(
                              width: size.width / 10,
                              height: size.width / 10,
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
                            onTap: restartGame,
                            child: Container(
                              width: size.width / 10,
                              height: size.width / 10,
                              decoration: BoxDecoration(
                                color: (Theme.of(context).brightness == Brightness.light)
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
                      move(0); // down
                    } else if (dy < 0) {
                      move(2); // up
                    }
                  } else {
                    if (dx > 0) {
                      move(1); // right
                    } else if (dx < 0) {
                      move(3); // left
                    }
                  }
                },
                child: Container(
                  width: boardSizePx,
                  height: boardSizePx,
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
                    children: [
                      for (int row = 0; row < 4; row++)
                        for (int col = 0; col < 4; col++)
                          Positioned(
                            top: row * tileSize + (row + 1) * 12.0,
                            left: col * tileSize + (col + 1) * 12.0,
                            child: Container(
                              width: tileSize,
                              height: tileSize,
                              decoration: BoxDecoration(
                                color: (Theme.of(context).brightness == Brightness.light)
                                    ? tileColorsLight[0]
                                    : tileColorsDark[0],
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                      ..._tileData.map((tile) {
                        final top = tile.row * tileSize + (tile.row + 1) * 12.0;
                        final left = tile.col * tileSize + (tile.col + 1) * 12.0;
                        return AnimatedPositioned(
                          key: ValueKey(tile.id),
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          top: top,
                          left: left,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            width: tileSize,
                            height: tileSize,
                            decoration: BoxDecoration(
                              color: (Theme.of(context).brightness == Brightness.light)
                                  ? tileColorsLight[tile.value] ?? tileColorsLight[2]
                                  : tileColorsDark[tile.value] ?? tileColorsDark[2],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                tile.value == 0 ? "" : "${tile.value}",
                                style: TextStyle(
                                  fontSize: tileSize / 3,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
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
