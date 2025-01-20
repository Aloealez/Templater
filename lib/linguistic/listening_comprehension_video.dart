import 'package:brainace_pro/linguistic/reading_comprehension_info.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:flutter/material.dart';
import '../quiz/quiz_model.dart';
import 'package:flutter_quizzes/flutter_quizzes.dart';
import 'package:flutter/services.dart';
import 'package:yaml/yaml.dart';
import 'dart:math';
import '../buttons.dart';
import '../app_bar.dart';

class ListeningComprehensionVideo extends StatefulWidget {
  const ListeningComprehensionVideo({
    super.key,
    this.initialTest = false,
    this.endingTest = false,
  });

  final bool initialTest;
  final bool endingTest;

  static ListeningComprehensionVideo routeBuilder(
      BuildContext context, {
        required bool initialTest,
        required bool endingTest,
      }) {
    return ListeningComprehensionVideo(
      initialTest: initialTest,
      endingTest: endingTest,
    );
  }

  @override
  State<ListeningComprehensionVideo> createState() => _Video();
}

class _Video extends State<ListeningComprehensionVideo> {
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
  late String videoId = "";
  late int exerciseId;

  late dynamic tasks;

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    exerciseId = Random().nextInt(16);
    chooseVideo();
    readData();
  }

  void readData() async {
    try {
      // List<String> newQuestions = [];
      // List<int> newCorrectAnswers = [];
      // List<List<String>> newAnswers = [];

      final file = await rootBundle
          .loadString('assets/attention/long_term_concentration_test.yaml');
      tasks = loadYaml(file)["tests"][exerciseId]["questions"];

      // for (var i = 0; i < tasks.length; i++) {
      //   newQuestions.add(tasks[i]["question"]);
      //   newCorrectAnswers.add(tasks[i]["correct_answer"]);
      //   newAnswers.add([]);
      //
      //   for (var answer in tasks[i]["answers"]) {
      //     newAnswers[newAnswers.length - 1].add(answer.toString());
      //   }
      // }
      // setState(() {
      //   correctAnswers = newCorrectAnswers;
      //   questions = newQuestions;
      //   answers = newAnswers;
      // });
    } catch (e) {
      print("Error: $e");
    }
  }

  void chooseVideo() async {
    final file = await rootBundle
        .loadString('assets/attention/long_term_concentration_test.yaml');
    final newVideoId = loadYaml(file)["tests"][exerciseId]["video_id"];
    _controller.loadVideo("https://www.youtube.com/watch?v=$newVideoId");

    setState(() {
      videoId = newVideoId;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return videoId.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            appBar: appBar(context, ""),
            body: SingleChildScrollView(
              child: Container(
                width: size.width * 0.9,
                height: size.height * 0.9,
                margin: EdgeInsets.only(
                  left: size.width / 10,
                  right: size.width / 10,
                  //top: size.height / 10,
                ),
                child: Column(
                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Center(
                          child: RichText(
                            text: TextSpan(
                              style: TextStyle(
                                color:
                                    Theme.of(context).colorScheme.onSurface,
                              ),
                              children: [
                                TextSpan(
                                  text: "Linguistic\n",
                                  style: TextStyle(
                                    fontSize: size.width / 8,
                                  ),
                                ),
                                TextSpan(
                                  text: "Intelligence",
                                  style: TextStyle(
                                    fontSize: size.width / 16,
                                  ),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(
                          height: size.height / 50,
                        ),
                        Text(
                          "Exercise 1 - Listening Comprehension",
                          style: TextStyle(fontSize: size.width / 22),
                        ),
                        SizedBox(
                          height: size.height / 20,
                        ),
                        Text(
                          "Do the following listening exercise.",
                          style: TextStyle(fontSize: size.width / 24),
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
                          "While listening we recommend you make notes.",
                          style: TextStyle(fontSize: size.width / 26),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        height: size.height * 0.05,
                        width: size.width * 0.75,
                        child: RedirectButton(
                          // route: ListeningComprehensionTest(
                          //   initialTest: widget.initialTest,
                          //   endingTest: widget.endingTest,
                          //   exerciseId: exerciseId,
                          // ),
                          route: QuizModel(
                            "Linguistic",
                            "Linguistic",
                            60,
                            initialTest: widget.initialTest,
                            endingTest: widget.endingTest,
                            initScore: 0,
                            initMaxScore: 4,
                            page: widget.initialTest
                                ? const ReadingComprehensionInfo(initialTest: true)
                                : widget.endingTest
                                ? const ReadingComprehensionInfo(endingTest: true)
                                : const ReadingComprehensionInfo(),
                            description: "Exercise 1 - Listening Comprehension",
                            oldName: "listening_comprehension",
                            exerciseNumber: 2,
                            exerciseString: "ListeningComprehensionVideo",
                            questions: {
                              for (int i = 0; i < tasks.length; ++i)
                                "$i": () {
                                  Map<String, String> answers = {};
                                  answers = {
                                    "A": tasks[i]["answers"][0].toString(),
                                    "B": tasks[i]["answers"][1].toString(),
                                    if (tasks[i]["answers"].length >= 3) "C": tasks[i]["answers"][2].toString(),
                                    if (tasks[i]["answers"].length >= 4) "D": tasks[i]["answers"][3].toString(),
                                  };
                                  Map<String, bool> correct = {
                                    "A": tasks[i]["correct_answer"] == 0,
                                    "B": tasks[i]["correct_answer"] == 1,
                                    "C": tasks[i]["correct_answer"] == 2,
                                    "D": tasks[i]["correct_answer"] == 3,
                                  };
                                  return QuizQuestionData(
                                    answers,
                                    correct,
                                    {
                                      "A": 1,
                                      "B": 1,
                                      "C": 1,
                                      "D": 1,
                                    },
                                    question: "${tasks[i]["question"]}",
                                  );
                                }(),
                            },
                          ),
                          //clearAllWindows: true,
                          text: 'Continue',
                          width: size.width,
                        ),
                      ),
                    ),
                    SizedBox(height: size.height / 15),
                  ],
                ),
              ),
            ),
          );
  }
}
