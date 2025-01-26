import 'package:brainace_pro/builders/strong_concentration_builder.dart';
import 'package:flutter_quizzes/flutter_quizzes.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../home.dart';
import '../quiz/quiz_model.dart';

FutureBuilder spellingMistakesBuilder(
  BuildContext context, {
  required bool initialTest,
  required bool endingTest,
}) {
  return FutureBuilder(
    future: () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String level = prefs.getString("level") ?? "cpe";
      return await convertToRandomQuestions("spelling_mistakes", level, 10);
    }(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
      return QuizModel(
        "Spelling",
        "Spelling",
        60,
        answerLayout: QuizModelAnswerLayout.boxes,
        centerTitle: true,
        timeBar: true,
        progressBar: false,
        showQuestionTask: false,
        singleTextQuestion: true,
        initialTest: initialTest,
        endingTest: endingTest,
        initScore: 0,
        initMaxScore: 0,
        page: initialTest
            ? strongConcentrationBuilder(initialTest: true, endingTest: false)
            : endingTest
                ? strongConcentrationBuilder(
                    initialTest: false, endingTest: true,)
                : Home(),
        description: "Exercise 2 - spelling mistakes",
        oldName: "long_term_concentration",
        exerciseNumber: 0,
        exerciseString: "SpellingMistakes",
        questions: snapshot.data!,
      );
    },
  );
}
