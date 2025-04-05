import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:flutter_quizzes/flutter_quizzes.dart';


double textScaleFactor(int textLength) {
  double val = 0.0056;
  val += 1 / (math.sqrt(math.sqrt(math.sqrt(textLength.toDouble()))) * 16);
  val = math.min(val, 0.049);
  val = math.max(val, 0.029);

  return val;
}

bool isCorrect(String? selectedAnswer, QuizModelAnswerLayout answerLayout, Map<String, QuizQuestionData> questions, String currentQuestionId) {
  if (answerLayout == QuizModelAnswerLayout.list ||
      answerLayout == QuizModelAnswerLayout.boxes) {
    if (selectedAnswer == null) {
      return false;
    }
    return questions[currentQuestionId]?.correct[selectedAnswer] ??
        false;
  } else if (answerLayout == QuizModelAnswerLayout.textInput) {
    return false;
  }
  return false;
}

ImageIcon buildAnswerIcon(
    BuildContext context,
    String answerLetter,
    bool coloredIcon,
    QuizModelAnswerLayout answerLayout,
    Map<String, QuizQuestionData> questions,
    String questionId,
    String answerId,
    ) {
  return ImageIcon(
    coloredIcon
        ? answerLetter == "A"
        ? AssetImage('assets/icons/a_filled.png')
        : answerLetter == "B"
        ? AssetImage('assets/icons/b_filled.png')
        : answerLetter == "C"
        ? AssetImage('assets/icons/c_filled.png')
        : AssetImage('assets/icons/d_filled.png')
        : answerLetter == "A"
        ? AssetImage('assets/icons/a_outlined.png')
        : answerLetter == "B"
        ? AssetImage('assets/icons/b_outlined.png')
        : answerLetter == "C"
        ? AssetImage('assets/icons/c_outlined.png')
        : AssetImage('assets/icons/d_outlined.png'),
    color: coloredIcon
        ? isCorrect(answerLetter, answerLayout, questions, questionId)
        ? Colors.green
        : Colors.red
        : Theme.of(context).colorScheme.onSurface,
    size: textScaleFactor(questions[questionId]!.question.length) *
        MediaQuery.of(context).size.width *
        1.7,
  );
}

Map<String, bool> getCorrectBoolArray(
    Map<String, QuizQuestionData> questions,
    Map<String, String> answers,
    ) {
  return {
    for (var answerId in answers.keys)
      answerId: questions[answerId] == null
          ? false
          : questions[answerId]!.correct[answers[answerId]] ?? false,
  };
}