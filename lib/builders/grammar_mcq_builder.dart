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
      // String file = await rootBundle.loadString('assets/linguistic/grammar_mcq_test.yaml');
      // dynamic tasks = getRandomElements(loadYaml(file)["questions"], 10);
      // print("tasks: $tasks");
      // Map<String, QuizQuestionData> questions = {
      //   for (int i = 0; i < tasks.length; ++i)
      //     "$i": await () async {
      //       List<String> shuffledAnswers =
      //       List<String>.from(tasks[i]["answers"]);
      //       shuffledAnswers.shuffle();
      //       Map<String, String> answers = {
      //         "A": shuffledAnswers[0].toString(),
      //         "B": shuffledAnswers[1].toString(),
      //         if (tasks[i]["answers"].length >= 3)
      //           "C": shuffledAnswers[2].toString(),
      //         if (tasks[i]["answers"].length >= 4)
      //           "D": shuffledAnswers[3].toString(),
      //       };
      //       Map<String, bool> correct = {
      //         "A": answers["A"] == tasks[i]["answers"][tasks[i]["correct_answer"]],
      //         "B": answers["B"] == tasks[i]["answers"][tasks[i]["correct_answer"]],
      //         "C": tasks[i]["answers"].length >= 3 ? answers["C"] == tasks[i]["answers"][tasks[i]["correct_answer"]] : false,
      //         "D": tasks[i]["answers"].length >= 4 ? answers["D"] == tasks[i]["answers"][tasks[i]["correct_answer"]] : false,
      //       };
      //       print("answers: $answers");
      //       return QuizQuestionData(
      //         answers,
      //         correct,
      //         {
      //           "A": 1,
      //           "B": 1,
      //           "C": 1,
      //           "D": 1,
      //         },
      //         question: "${tasks[i]["question"]}",
      //       );
      //     }(),
      // };
      // return questions;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String level = prefs.getString("level") ?? "cpe";
      return await convertToQuestions("grammar", level, 10);
    }(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
      return QuizModel(
        "Grammar",
        "Grammar",
        60,
        initialTest: initialTest,
        endingTest: endingTest,
        initScore: 0,
        initMaxScore: 0,
        page: Home(),
        description: "Grammar MCQ Test",
        oldName: "grammar_mcq",
        exerciseNumber: 0,
        exerciseString: "Grammar",
        questions: snapshot.data!,
      );
    },
  );
}
