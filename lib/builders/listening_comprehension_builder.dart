import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:yaml/yaml.dart';
import '../linguistic/reading_comprehension_info.dart';
import '../quiz/quiz_model.dart';
import 'package:flutter_quizzes/flutter_quizzes.dart';
import '../video_screen.dart';


FutureBuilder listeningComprehensionBuilder(int exerciseId, bool initialTest, bool endingTest) {
  return FutureBuilder(future: () async {
    final file = await rootBundle.loadString('assets/attention/long_term_concentration_test.yaml');
    return loadYaml(file)["tests"][exerciseId];
  }(), builder: (context, snapshot) {
    if (snapshot.connectionState != ConnectionState.done) {
      return Center(
          child: CupertinoActivityIndicator(),
      );
    }
    final tasks = snapshot.data["questions"];
    return VideoScreen(
      videoId: snapshot.data["video_id"],
      route: QuizModel(
        "Linguistic",
        "Linguistic",
        60,
        initialTest: initialTest,
        endingTest: endingTest,
        initScore: 0,
        initMaxScore: 4,
        page: initialTest
            ? const ReadingComprehensionInfo(initialTest: true)
            : endingTest
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
    );
  },);
}