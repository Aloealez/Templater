import 'package:brainace_pro/quiz/quiz_model.dart';
import 'package:flutter_quizzes/flutter_quizzes.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../home.dart';

FutureBuilder idiomsBuilder(
  BuildContext context, {
  required bool initialTest,
  required bool endingTest,
}) {
  return FutureBuilder(
    future: () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String level = prefs.getString("level") ?? "cpe";
      return await convertToQuestions("idioms", level, 10);
    }(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
      return QuizModel(
        "Idioms",
        "Idioms",
        60,
        initialTest: initialTest,
        endingTest: endingTest,
        initScore: 0,
        initMaxScore: 0,
        singleTextQuestion: true,
        page: Home(),
        description: "Idioms, expressions, and phrasal verbs.",
        oldName: "idioms",
        exerciseNumber: 0,
        exerciseString: "Idioms",
        questions: snapshot.data!,
      );
    },
  );
}
