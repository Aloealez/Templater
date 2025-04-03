import 'package:audioplayers/audioplayers.dart';
import 'package:brainace_pro/attention/equations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quizzes/flutter_quizzes.dart';
import '../home.dart';
import '../quiz/quiz_model.dart';


FutureBuilder strongConcentrationBuilder({required bool initialTest, required bool endingTest}) {
  return FutureBuilder (future: () async {
    equations.shuffle();
    return { for (int i = 0; i < 12; i++)
      "${i + 1}." : QuizQuestionData(
        {"T": equations[i][1].toString()},
        {"T": true},
        {
        "T": 1,
        },
        question: equations[i][0].toString(),
      ),
    };
  }(), builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }
    return QuizModel(
      "Attention",
      "Attention",
      120,
      answerLayout : QuizModelAnswerLayout.textInput,
      centerTitle: true,
      showMultipleQuestions: true,
      progressBar: false,
      timeBar: true,
      singleTextQuestion: true,
      inlineTaskAndAnswers: true,
      inputTextNumbersOnly: true,
      hintText: "",
      music: AssetSource("attention/distracting_music.mp3"),
      initialTest: initialTest,
      endingTest: endingTest,
      initScore: 0,
      initMaxScore: 0,
      page: Home(),
      description: "Exercise 3 - Strong Concentration",
      oldName: "strong_concentration",
      exerciseNumber: 0,
      exerciseString: "StrongConcentrationDesc",
      questions: snapshot.data!,
    );
  },
  );
}