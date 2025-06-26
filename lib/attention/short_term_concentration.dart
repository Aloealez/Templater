import 'package:brainace_pro/builders/long_term_concentration_builder.dart';
import 'package:brainace_pro/initial_score_screen.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';
import '../buttons.dart';
import '../score_n_progress/progress_screen.dart';
import '../app_bar.dart';
import '../score_n_progress/show_improvement.dart';

class ShortTermConcentration extends StatefulWidget {
  final bool initialTest;
  final bool endingTest;

  const ShortTermConcentration({
    super.key,
    this.initialTest = false,
    this.endingTest = false,
  });

  static ShortTermConcentration routeBuilder(
    BuildContext context, {
    required bool initialTest,
    required bool endingTest,
  }) {
    return ShortTermConcentration(
      initialTest: initialTest,
      endingTest: endingTest,
    );
  }

  @override
  State<ShortTermConcentration> createState() => _ShortTermConcentration();
}

List<List<String>> films = [
  [
    'https://www.youtube.com/watch?v=_kDrRWlIkjw',
    'https://www.youtube.com/watch?v=pNjxyFp-RfM',
    'https://www.youtube.com/watch?v=3D4CUXMp3BY',
    'https://www.youtube.com/watch?v=pEmAnuEU5PE',
    'https://www.youtube.com/watch?v=MmnwHH6IFuY',
    'https://www.youtube.com/watch?v=lvvBh8Na-wY',
    'https://www.youtube.com/watch?v=02jqF0-Qmho',
  ],
  [
    'https://www.youtube.com/watch?v=VExEBel_bnk',
    'https://www.youtube.com/watch?v=Cs8HyHVVWsU',
    'https://www.youtube.com/watch?v=l7NZfY-WZio',
    'https://www.youtube.com/watch?v=h6sKvWSfvms',
    'https://www.youtube.com/watch?v=n1YIqTO-URo',
    'https://www.youtube.com/watch?v=r0qoeH8Eiqs',
    'https://www.youtube.com/watch?v=XL7XyJWfC5w',
  ],
  [
    'https://www.youtube.com/watch?v=FsOasNc9bt4',
    'https://www.youtube.com/watch?v=1fKSp6eOYMM',
    'https://www.youtube.com/watch?v=43CQBJ73GWg',
    'https://www.youtube.com/watch?v=6125jY_z054',
    'https://www.youtube.com/watch?v=MXaUcoWmWOc',
    'https://www.youtube.com/watch?v=44F10ML4k3A',
    'https://www.youtube.com/watch?v=kdl3XdSiTLA',
  ],
];

class _ShortTermConcentration extends State<ShortTermConcentration> {
  late YoutubePlayerController _controller;
  TextEditingController textController = TextEditingController();
  double score = 0;
  int selectedScore = -1;

  int level = 0;
  int streak = 0;
  String video = films[0][0];

  Future<void> saveStreak(int cScore) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? currentStreak = prefs.getInt('short_term_concentration_streak');
    currentStreak ??= 0;
    int? currentLevel = prefs.getInt('short_term_concentration_level');
    currentLevel ??= 0;
    if (cScore == 1) {
      prefs.setInt('short_term_concentration_streak', currentStreak + 1);
    } else {
      prefs.setInt('short_term_concentration_streak', 0);
    }

    if (currentStreak >= 2 && currentLevel < 3) {
      prefs.setInt('short_term_concentration_level', currentLevel + 1);
      prefs.setInt('short_term_concentration_streak', 0);
    }
  }

  Future<void> readLevel() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    int? currentLevel = prefs.getInt('short_term_concentration_level');
    int? currentStreak = prefs.getInt('short_term_concentration_streak');

    currentLevel ??= 0;
    currentStreak ??= 0;

    setState(() {
      level = currentLevel!;
      streak = currentStreak!;
    });
  }

  @override
  void initState() {
    super.initState();

    _controller = YoutubePlayerController(
      params: const YoutubePlayerParams(
        showControls: true,
        mute: false,
        showFullscreenButton: true,
        loop: false,
        enableKeyboard: false,
      ),
    );
    setState(() {
      readLevel();
    });

    //int level = 0;
  }

  @override
  dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    video = films[level][Random().nextInt(7)];

    _controller.loadVideo(video);
    return Scaffold(
      appBar: appBar(context, ''),
      body: SingleChildScrollView(
        child: Container(
          width: size.width * 0.9,
          height: size.height * 0.9,
          margin: EdgeInsets.only(
            left: size.width / 10,
            right: size.width / 10,
          ),
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: Text(
                      'Attention',
                      style: TextStyle(
                        fontSize: size.width / 8,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: size.height / 50,
                  ),
                  Text(
                    'Exercise 1 - Short Term Concentration',
                    style: TextStyle(fontSize: size.width / 20),
                  ),
                  SizedBox(
                    height: size.height / 25,
                  ),
                  Text(
                    'Follow the instructions in the video.',
                    style: TextStyle(fontSize: size.width / 24),
                  ),
                  SizedBox(
                    height: size.height / 30,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: YoutubePlayer(
                        controller: _controller,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.height / 25,
                  ),
                  Text(
                    'Select You\'r score.',
                    style: TextStyle(fontSize: size.width / 24),
                  ),
                  SizedBox(
                    height: size.height / 50,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(4, (index) {
                      bool isSelected = selectedScore == index;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedScore = index;
                            score = index.toDouble();
                          });
                        },
                        child: AnimatedContainer(
                          alignment: Alignment.center,
                          height: size.height / 20,
                          width: size.width / 7,
                          duration: Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Theme.of(context).colorScheme.primary
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                            border: isSelected
                                ? null
                                : Border.all(width: 2, color: Colors.white),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary
                                          .withOpacity(0.6),
                                      blurRadius: 10,
                                      offset: Offset(0, 4),
                                    ),
                                  ]
                                : [],
                          ),
                          child: Text(
                            index.toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
              SizedBox(
                height: size.height / 7,
              ),
              SizedBox(
                height: size.height * 0.05,
                width: size.width * 0.75,
                child: RedirectButton(
                  onClick: () {
                    if (score == 1) {
                      saveStreak(1);
                    } else {
                      saveStreak(-1);
                    }
                  },
                  route: (widget.initialTest)
                      ? InitialScoreScreen(
                          title: 'Attention',
                          description: 'Exercise 1 - Short Term Concentration',
                          exercise: 2,
                          userScore: score,
                          maxScore: 3,
                      page: longTermConcentrationBuilder(Random().nextInt(13), true, widget.endingTest),
                        )
                      : (widget.endingTest
                          ? ShowImprovement(
                              title: 'Attention',
                              description: 'Exercise 1 - Short Term Concentration',
                              exercise: 2,
                              yourScore: score,
                              maximum: 3,
                              page: longTermConcentrationBuilder(Random().nextInt(13), false, true),
                            )
                          : ProgressScreen(
                              userScore: score,
                              maxScore: 3,
                              exercise: 'ShortTermConcentration',
                            )),
                  text: 'Continue',
                  width: size.width,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
