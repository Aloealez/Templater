import 'package:brainace_pro/buttons.dart';
import 'package:brainace_pro/quiz/quiz_model.dart';
import 'package:flutter_quizzes/flutter_quizzes.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:flutter/material.dart';
import '../builders/strong_concentration_builder.dart';
import 'package:flutter/services.dart';
import 'package:yaml/yaml.dart';
import 'dart:math';
import '../app_bar.dart';

class LongTermConcentrationVideo extends StatefulWidget {
  const LongTermConcentrationVideo({
    super.key,
    this.initialTest = false,
    this.endingTest = false,
  });

  final bool initialTest;
  final bool endingTest;

  static LongTermConcentrationVideo routeBuilder(
      BuildContext context, {
        required bool initialTest,
        required bool endingTest,
      }) {
    return LongTermConcentrationVideo(
    );
  }

  @override
  State<LongTermConcentrationVideo> createState() =>
      _LongTermConcentrationVideo();
}

class _LongTermConcentrationVideo extends State<LongTermConcentrationVideo> {
  double score = 0;
  final _controller = YoutubePlayerController(
    params: const YoutubePlayerParams(
      showControls: false,
      mute: false,
      showFullscreenButton: false,
      loop: false,
      enableKeyboard: false,
    ),
  );
  late String videoId = '';
  late int exerciseId = 0;

  late dynamic tasks;

  @override
  void initState() {
    super.initState();
    chooseVideo();
    readData();
  }

  void chooseVideo() async {
    final file = await rootBundle.loadString('assets/attention/long_term_concentration_test.yaml');
    final newExerciseId = Random().nextInt(13);
    final newVideoId = loadYaml(file)['tests'][newExerciseId]['video_id'];
    _controller.loadVideo('https://www.youtube.com/watch?v=$newVideoId');
    tasks = loadYaml(file)['tests'][newExerciseId]['questions'];

    setState(() {
      videoId = newVideoId;
      exerciseId = newExerciseId;
    });
  }

  @override
  dispose() {
    _controller.close();
    super.dispose();
  }

  void readData() async {
    try {
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return videoId.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            appBar: appBar(context, ''),
            body: Container(
              width: size.width * 0.9,
              height: size.height * 0.9,
              margin: EdgeInsets.only(
                left: size.width / 10,
                right: size.width / 10,
                top: size.height / 30,
              ),
              child: Column(
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
                      Text(
                        'Exercise 2 - Long Term Concentration',
                        style: TextStyle(
                          fontSize: size.width / 18,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: size.height / 25,
                      ),
                      Text(
                        'Do the following listening exercise.',
                        style: TextStyle(fontSize: size.width / 26),
                      ),
                      SizedBox(
                        height: size.height / 30,
                      ),
                      YoutubePlayer(
                        controller: _controller,
                      ),
                      SizedBox(
                        height: size.height / 50,
                      ),
                      Text(
                        'While listening we recommend you make notes.',
                        style: TextStyle(fontSize: size.width / 26),
                      ),
                    ],
                  ),
                  SizedBox(height: size.height / 5),
                  SizedBox(
                    height: size.height * 0.05,
                    width: size.width * 0.75,
                    child: RedirectButton(
                      // route: LongTermConcentrationTest(
                      //   exerciseId: exerciseId,
                      //   initialTest: widget.initialTest,
                      //   endingTest: widget.endingTest,
                      // ),
                      route: QuizModel(
                        'Attention',
                        'Attention',
                        120,
                        initialTest: widget.initialTest,
                        endingTest: widget.endingTest,
                        initScore: 0,
                        initMaxScore: 4,
                        page: widget.initialTest
                            ? strongConcentrationBuilder(initialTest: true, endingTest: false)
                            : widget.endingTest
                            ? strongConcentrationBuilder(initialTest: false, endingTest: true)
                            : strongConcentrationBuilder(initialTest: false, endingTest: false),
                        description: 'Exercise 2 - Long Term Concentration',
                        oldName: 'long_term_concentration',
                        exerciseNumber: 2,
                        exerciseString: 'LongTermConcentrationVideo',
                        questions: {
                          for (int i = 0; i < 10; ++i)
                            '$i': () {
                              Map<String, String> answers = {};
                              answers = {
                                'A': tasks[i]['answers'][0].toString(),
                                'B': tasks[i]['answers'][1].toString(),
                                if (tasks[i]['answers'].length >= 3) 'C': tasks[i]['answers'][2].toString(),
                                if (tasks[i]['answers'].length >= 4) 'D': tasks[i]['answers'][3].toString(),
                              };
                              Map<String, bool> correct = {
                                'A': tasks[i]['correct_answer'] == 0,
                                'B': tasks[i]['correct_answer'] == 1,
                                'C': tasks[i]['correct_answer'] == 2,
                                'D': tasks[i]['correct_answer'] == 3,
                              };
                              return QuizQuestionData(
                                answers,
                                correct,
                                {
                                  'A': 1,
                                  'B': 1,
                                  'C': 1,
                                  'D': 1,
                                },
                                question: "${tasks[i]["question"]}",
                              );
                            }(),
                        },
                      ),
                      text: 'Continue',
                      width: size.width,
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
