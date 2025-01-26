import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../home.dart';
import '../quiz/quiz_model.dart';
import 'package:flutter_quizzes/flutter_quizzes.dart';

FutureBuilder vocabularyBuilder(
    BuildContext context, {
      required bool initialTest,
      required bool endingTest,
    }) {
  return FutureBuilder(
    future: () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String level = prefs.getString("level") ?? "cpe";
      return await convertToQuestions("vocabulary", level, 10);
    }(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
      print("questions: ${snapshot.connectionState} ${snapshot.data}");
      return QuizModel(
        "Vocabulary",
        "Vocabulary",
        79,
        answerLayout : QuizModelAnswerLayout.list,
        initialTest: initialTest,
        endingTest: endingTest,
        initScore: 0,
        initMaxScore: 0,
        singleTextQuestion: true,
        page: Home(),
        description: "Vocabulary",
        oldName: "vocabulary",
        exerciseNumber: 0,
        exerciseString: "Vocabulary",
        questions: snapshot.data!,
      );
    },
  );
}
