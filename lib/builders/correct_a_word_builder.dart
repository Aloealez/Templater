import 'package:brainace_pro/builders/strong_concentration_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yaml/yaml.dart';
import 'package:flutter_bta_functions/flutter_bta_functions.dart';
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
      // String file = await rootBundle.loadString('assets/linguistic/correct_a_word.yml');
      // final tasks = loadYaml(file)["words"][0]["correct"];
      // final incorrectWords = loadYaml(file)["words"][1]["incorrect"];
      // print("tasks: $tasks");
      // Map<String, QuizQuestionData> questions = {
      //   for (int i = 0; i < tasks.length; ++i)
      //     "$i": () {
      //       Map<String, String> answers = {
      //         "A": incorrectWords[i].toString(),
      //         "B": tasks[i].toString(),
      //       };
      //       Map<String, bool> correct = {
      //         "A": false,
      //         "B": true,
      //       };
      //       print("answers: $answers");
      //       return QuizQuestionData(
      //         answers,
      //         correct,
      //         {
      //           "A": 1,
      //           "B": 0,
      //         },
      //         question: "${incorrectWords[i]}",
      //       );
      //     }(),
      // };
      // questions = getRandomElementsMap(questions, 10);
      // print("before return questions: $questions");
      // return questions;
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
        "Linguistic",
        "Linguistic",
        120,
        answerLayout : QuizModelAnswerLayout.textInput,
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
