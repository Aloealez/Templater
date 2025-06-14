import 'dart:math';
import 'package:brainace_pro/quiz/quiz_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quizzes/flutter_quizzes.dart';
import '../working_memory.dart';
import '../../buttons.dart';
import '../../app_bar.dart';

class Memory2 extends StatefulWidget {
  final bool initialTest;
  final bool endingTest;

  const Memory2(
    this.picked,
    this.defs,
    this.words, {
    this.initialTest = false,
    this.endingTest = false,
    super.key,
  });

  final List<Map<String, String>> picked;
  final List<String> words;
  final List<String> defs;

  @override
  State<Memory2> createState() => _Memory2();
}

class _Memory2 extends State<Memory2> {
  List<Map<String, String>> picked = [];
  List<String> defs = [];
  List<String> words = [];
  List<String> answers = [];
  int score = 0;

  List<TextEditingController> conList = List.generate(
    10,
    (index) => TextEditingController(),
  );

  SizedBox createFormFields(BuildContext context) {
    List<Widget> formFields = [];
    Size size = MediaQuery.of(context).size;

    for (int i = 0; i < 10; ++i) {
      formFields.add(
        SizedBox(
          height: 0.05 * size.height,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: SizedBox(
              width: 0.8 * size.width,
              child: TextFormField(
                controller: conList[i],
                enableSuggestions: false,
                onSaved: (String? value) {},
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 12.0),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return SizedBox(
      width: 0.8 * size.width,
      child: Column(
        children: formFields,
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    picked = widget.picked;
    words = [];

    for (int i = 0; i < picked.length; ++i) {
      words.add(picked[i].keys.first.toLowerCase());
    }

    for (int i = 0; i < picked.length - 1; ++i) {
      defs.add(picked[i].values.toList().first);
    }
  }

  int calcScore() {
    int score = 0;
    for (int i = 0; i < picked.length; ++i) {
      if (words.contains(conList[i].text)) ++score;
    }
    return score;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: appBar(context, ''),
      body: SingleChildScrollView(
        child: Container(
          width: size.width * 0.9,
          height: size.height * 0.9,
          margin: EdgeInsets.only(
            left: size.width / 10,
            right: size.width / 10,
            bottom: size.height / 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Memory',
                    style: TextStyle(fontSize: 0.06 * size.height),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 0.02 * size.height),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Exercise 1.1 - Learning',
                      style: TextStyle(fontSize: 0.025 * size.height),
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(height: 0.02 * size.height),
                    Text(
                      'Now write down as many words as you remember. ',
                      style: TextStyle(fontSize: 0.02 * size.height),
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
                SizedBox(height: 0.02 * size.height),
                createFormFields(context),
                Center(
                  child: SizedBox(
                    height: size.height * 0.05,
                    width: size.width * 0.75,
                    child: RedirectButton(
                      route: QuizModel(
                        'Memory {}',
                        'Memory',
                        60,
                        initialTest: widget.initialTest,
                        endingTest: widget.endingTest,
                        singleTextQuestion: true,
                        initScore: calcScore().toDouble(),
                        initMaxScore: 4,
                        page: widget.initialTest
                            ? const WorkingMemory(initialTest: true)
                            : widget.endingTest
                                ? const WorkingMemory(endingTest: true)
                                : const WorkingMemory(),
                        description: 'Exercise 1 - Learning',
                        oldName: 'learning_words',
                        exerciseNumber: 1,
                        exerciseString: 'Memory',
                        questions: {
                          for (int i = 0; i < 10; ++i)
                            '$i': () {
                              Map<String, String> answers = {};
                              for (String key in ['A', 'B', 'C', 'D']) {
                                int random = Random().nextInt(picked.length);
                                while (random == i || answers.values.contains(picked[random].values.first)) {
                                  random = Random().nextInt(picked.length);
                                }
                                answers[key] = picked[random].values.first;
                              }
                              answers[answers.keys.toList()[Random().nextInt(4)]] = picked[i].values.first;
                              Map<String, bool> correct = {
                                for (String key in answers.keys)
                                  key: answers[key] == picked[i].values.first,
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
                                question: 'Choose the definition: ${picked[i].keys.first}',
                              );
                            }(),
                        },
                      ),
                      text: 'Continue',
                      width: size.width,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
