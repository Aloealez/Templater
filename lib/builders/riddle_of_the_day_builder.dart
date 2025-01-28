import 'dart:convert';

import 'package:brainace_pro/score_n_progress/progress_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bta_functions/flutter_bta_functions.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

      String date = DateFormat('yyyy-MM-dd').format(DateTime.now());
      Map<String, QuizQuestionData>? todayQuestion;

      if (prefs.getString("lastDateTime_riddle_of_the_day") != date) {
        await prefs.setString("lastDateTime_riddle_of_the_day", date);

        String todayQuestionId = (await getRandomQuestions("riddle_of_the_day", "default", 1)).keys.last;
        await prefs.setString("todayQuestionId_riddle_of_the_day", todayQuestionId);
      }
      String todayQuestionId = prefs.getString("todayQuestionId_riddle_of_the_day") ?? "-1";

      String data = await loadQuestionsAsset("riddle_of_the_day", "default");
      Map<String, dynamic> questions = jsonDecode(data);
      todayQuestion = (await convertToQuestions(questions));
      todayQuestion = {
        todayQuestionId: todayQuestion[todayQuestionId]!,
      };

      String lastDoneDate = prefs.getString("lastDone_riddle_of_the_day") ?? "";
      if (lastDoneDate == date) {
        todayQuestion = null;
      }
      return [todayQuestion, lastScores];
    }(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
      if (snapshot.data![0] == null) {
        return ProgressScreen(maxScore: snapshot.data![1].length.toDouble(), exercise: "RiddleOfTheDay");
      }
      return QuizModel(
        "Riddle Of The Day",
        "RiddleOfTheDay",
        60 * 15,
        answerLayout: QuizModelAnswerLayout.textInput,
        centerTitle: true,
        timeBar: true,
        progressBar: false,
        singleTextQuestion: true,
        initialTest: initialTest,
        endingTest: endingTest,
        initScore: double.parse(snapshot.data![1].last),
        initMaxScore: 0,
        page: Home(),
        description: "Riddle Of The Day",
        oldName: "riddle_of_the_day",
        exerciseNumber: 0,
        exerciseString: "RiddleOfTheDay",
        questions: snapshot.data![0],
        onEnd: (score, maxScore, x, y) async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          String date = DateFormat('yyyy-MM-dd').format(DateTime.now());
          await prefs.setString("lastDone_riddle_of_the_day", date);
        },
      );
    },
  );
}
