import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yaml/yaml.dart';
import 'package:flutter_bta_functions/flutter_bta_functions.dart';
import '../home.dart';
import '../quiz/quiz_model.dart';
import 'package:flutter_quizzes/flutter_quizzes.dart';

FutureBuilder riddleOfTheDayBuilder(
    BuildContext context, {
      required bool initialTest,
      required bool endingTest,
    }) {
  return FutureBuilder(
    future: () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      List<String> lastScores = prefs.getStringList("riddle_of_the_day_scores") ?? ["0"];
      print("lastScores: $lastScores");

      String level = prefs.getString("level") ?? "cpe";
      return [await convertToQuestions("riddle_of_the_day", "default", 1), lastScores];
    }(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
      return QuizModel(
        "RiddleOfTheDay",
        "RiddleOfTheDay",
        180,
        answerLayout: QuizModelAnswerLayout.textInput,
        initialTest: initialTest,
        endingTest: endingTest,
        initScore: double.parse(snapshot.data![1].last),
        initMaxScore: snapshot.data![1].length.toDouble(),
        page: Home(),
        description: "Riddle Of The Day",
        oldName: "riddle_of_the_day",
        exerciseNumber: 0,
        exerciseString: "RiddleOfTheDay",
        questions: snapshot.data![0],
      );
    },
  );
}
