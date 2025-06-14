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
      List<String> lastScores = prefs.getStringList('riddle_of_the_day_scores') ?? ['0'];
      String date = DateFormat('yyyy-MM-dd').format(DateTime.now());
      Map<String, QuizQuestionData>? todayQuestion;
      String? error;

      // Check if the last date is different from today
      if (prefs.getString('lastDateTime_riddle_of_the_day') != date) {
        await prefs.setString('lastDateTime_riddle_of_the_day', date);

        // Fetch a new question ID
        try {
          String todayQuestionId = (await getRandomQuestions('riddle_of_the_day', 'default', 1)).keys.last;
          await prefs.setString('todayQuestionId_riddle_of_the_day', todayQuestionId);
        } catch (e) {
          error = 'Failed to fetch a new riddle. Please try again later.';
          return [null, lastScores, error, false];
        }
      }

      String todayQuestionId = prefs.getString('todayQuestionId_riddle_of_the_day') ?? '-1';

      // Load questions from asset
      String data;
      try {
        data = await loadQuestionsAsset('riddle_of_the_day', 'default');
      } catch (e) {
        error = 'Failed to load riddles. Please check your connection.';
        return [null, lastScores, error, false];
      }

      Map<String, dynamic> questions = jsonDecode(data);
      todayQuestion = await convertToQuestions(questions);

      // Debugging output
      print('Available question IDs: ${questions.keys}');
      print('Today\'s question ID: $todayQuestionId');

      // Check if the question ID exists
      if (todayQuestion.containsKey(todayQuestionId)) {
        todayQuestion = {
          todayQuestionId: todayQuestion[todayQuestionId]!,
        };
      } else {
        todayQuestion = null;
        error = 'No riddle found for today. Please try again later.';
      }

      String lastDoneDate = prefs.getString('lastDone_riddle_of_the_day') ?? '';
      bool alreadyDone = lastDoneDate == date;
      if (alreadyDone) {
        return [null, lastScores, null, true]; // true means already done
      }
      return [todayQuestion, lastScores, error, false];
    }(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
      // Handle error state
      if (snapshot.data != null && snapshot.data!.length > 2 && snapshot.data![2] != null) {
        return Center(
          child: Text(snapshot.data![2], style: TextStyle(color: Colors.red)),
        );
      }
      // Only show ProgressScreen if already done
      if (snapshot.data != null && snapshot.data!.length > 3 && snapshot.data![3] == true) {
        return ProgressScreen(maxScore: snapshot.data![1].length.toDouble(), exercise: 'RiddleOfTheDay');
      }
      // If no question and not already done, show error
      if (snapshot.data![0] == null) {
        return Center(
          child: Text('No riddle is available for today.', style: TextStyle(color: Colors.red)),
        );
      }
      // Otherwise, show the quiz
      return QuizModel(
        'Riddle Of The Day',
        'RiddleOfTheDay',
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
        description: 'Riddle Of The Day',
        oldName: 'riddle_of_the_day',
        exerciseNumber: 0,
        exerciseString: 'RiddleOfTheDay',
        questions: snapshot.data![0],
        onEnd: (score, maxScore, x, y) async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          String date = DateFormat('yyyy-MM-dd').format(DateTime.now());
          await prefs.setString('lastDone_riddle_of_the_day', date);
        },
      );
    },
  );
}