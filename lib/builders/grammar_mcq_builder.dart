import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../home.dart';
import '../quiz/quiz_model.dart';
import 'package:flutter_quizzes/flutter_quizzes.dart';

FutureBuilder grammarMcqBuilder(
    BuildContext context, {
      required bool initialTest,
      required bool endingTest,
      required int exerciseId,
    }) {
  return FutureBuilder(
    future: () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String level = prefs.getString('level') ?? 'cpe';
      Map<String, QuizQuestionData> questions = await convertToRandomQuestions('grammar', level, 10);
      for (String key in questions.keys) {
        questions[key]?.question += '\n\nWhich choice completes the text, so that it conforms to the rules of standard written English?';
      }
      return questions;
    }(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
      return QuizModel(
        'Grammar',
        'Grammar',
        60,
        initialTest: initialTest,
        endingTest: endingTest,
        singleTextQuestion: true,
        initScore: 0,
        initMaxScore: 0,
        page: Home(),
        description: 'Grammar MCQ Test',
        oldName: 'grammar_mcq',
        exerciseNumber: 0,
        exerciseString: 'Grammar',
        questions: snapshot.data!,
      );
    },
  );
}
