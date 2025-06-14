import 'package:brainace_pro/builders/strong_concentration_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:yaml/yaml.dart';
import '../quiz/quiz_model.dart';
import 'package:flutter_quizzes/flutter_quizzes.dart';
import '../video_screen.dart';


FutureBuilder longTermConcentrationBuilder(int exerciseId, bool initialTest, bool endingTest) {
  return FutureBuilder(future: () async {
    final file = await rootBundle.loadString('assets/attention/long_term_concentration_test.yaml');
    return loadYaml(file)['tests'][exerciseId];
  }(), builder: (context, snapshot) {
    if (snapshot.connectionState != ConnectionState.done) {
      return Center(
        child: CupertinoActivityIndicator(),
      );
    }
    final tasks = snapshot.data['questions'];
    return VideoScreen(
      videoId: snapshot.data['video_id'],
      route: QuizModel(
        'Attention',
        'Attention',
        60,
        initialTest: initialTest,
        endingTest: endingTest,
        initScore: 0,
        singleTextQuestion: true,
        initMaxScore: 4,
        page: initialTest
            ? strongConcentrationBuilder(initialTest: true, endingTest: false)
            : endingTest
            ? strongConcentrationBuilder(initialTest: false, endingTest: true)
            : strongConcentrationBuilder(initialTest: false, endingTest: false),
        description: 'Exercise 2 - Long Term Concentration',
        oldName: 'long_term_concentration',
        exerciseNumber: 2,
        exerciseString: 'LongTermConcentrationVideo',
        questions: {
          for (int i = 0; i < tasks.length; ++i)
            '$i': () {
              Map<String, String> answers = {};
              answers = {
                'A': tasks[i]['answers'][0].toString(),
                'B': tasks[i]['answers'][1].toString(),
                if (tasks[i]['answers'].length >= 3) 'C': tasks[i]['answers'][2].toString(),
                if (tasks[i]['answers'].length >= 4) 'D': tasks[i]['answers'][3].toString(),
              };
              Map<String, bool> correct = {
                'A': tasks[i]['correct_answer'] == 0,
                'B': tasks[i]['correct_answer'] == 1,
                'C': tasks[i]['correct_answer'] == 2,
                'D': tasks[i]['correct_answer'] == 3,
              };
              return QuizQuestionData(
                answers,
                correct,
                {
                  'A': 1,
                  'B': 1,
                  'C': 1,
                  'D': 1,
                },
                question: "${tasks[i]["question"]}",
              );
            }(),
        },
      ),
    );
  },);
}