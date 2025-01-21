import 'package:brainace_pro/builders/strong_concentration_builder.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../home.dart';
import '../quiz/quiz_model.dart';
import 'package:flutter_quizzes/flutter_quizzes.dart';

FutureBuilder correctAWordBuilder(
    BuildContext context, {
      required bool initialTest,
      required bool endingTest,
    }) {
  return FutureBuilder(
    future: () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String level = prefs.getString("level") ?? "cpe";
      return await convertToQuestions("correct_a_word", level, 3);
    }(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
      print("questions: ${snapshot.connectionState} ${snapshot.data}");
      return QuizModel(
        "Correct a Word",
        "Correct a Word",
        120,
        answerLayout : QuizModelAnswerLayout.textInput,
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
