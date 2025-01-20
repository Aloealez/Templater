import 'package:brainace_pro/builders/strong_concentration_builder.dart';
import 'package:flutter_quizzes/flutter_quizzes.dart';
import 'package:dictionaryx/dictionary_msa_json_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yaml/yaml.dart';
import 'package:flutter_bta_functions/flutter_bta_functions.dart';
import '../home.dart';
import '../quiz/quiz_model.dart';

FutureBuilder spellingMistakesBuilder(
  BuildContext context, {
  required bool initialTest,
  required bool endingTest,
}) {
  return FutureBuilder(
    future: () async {
      // String file = await rootBundle.loadString('assets/linguistic/spelling_mistakes.yaml');
      // final dMSAJson = DictionaryMSAFlutter();
      // dynamic tasks = getRandomElements(loadYaml(file)["questions"], 10);
      // print("tasks: $tasks");
      // Map<String, QuizQuestionData> questions = {
      //   for (int i = 0; i < tasks.length; ++i)
      //     "$i": await () async {
      //       List<String> shuffledAnswers =
      //           List<String>.from(tasks[i]["answers"]);
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
      //         "A": await dMSAJson.hasEntry(shuffledAnswers[0]),
      //         "B": await dMSAJson.hasEntry(shuffledAnswers[1]),
      //         "C": tasks[i]["answers"].length >= 3
      //             ? await dMSAJson.hasEntry(shuffledAnswers[2])
      //             : false,
      //         "D": tasks[i]["answers"].length >= 4
      //             ? await dMSAJson.hasEntry(shuffledAnswers[3])
      //             : false,
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
      return await convertToQuestions("spelling_mistakes", level, 10);
    }(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
      return QuizModel(
        "Linguistic",
        "Linguistic",
        60,
        answerLayout: QuizModelAnswerLayout.boxes,
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
