import 'package:flutter/material.dart';
import '../app_bar.dart';
import 'package:yaml/yaml.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import '../buttons.dart';
import '../quiz/quiz_model.dart';
import 'package:flutter_quizzes/flutter_quizzes.dart';
import '/home.dart';
import '../title_page.dart';

class ReadingComprehension extends StatefulWidget {
  const ReadingComprehension({
    super.key,
    this.initialTest = false,
    this.endingTest = false,
  });

  final bool initialTest;
  final bool endingTest;

  static ReadingComprehension routeBuilder(
      BuildContext context, {
        required bool initialTest,
        required bool endingTest,
      }) {
    return ReadingComprehension(
      initialTest: initialTest,
      endingTest: endingTest,
    );
  }

  @override
  State<ReadingComprehension> createState() => _ReadingComprehension();
}

class _ReadingComprehension extends State<ReadingComprehension> {
  String title = '';
  String author = '';
  String text = '';
  var rng = Random();
  dynamic tasks;


  void readData() async {
    try {
      // List<String> newQuestions = [];
      // List<int> newCorrect = [];
      // List<List<String>> newAnswers = [];
      int test = rng.nextInt(11);

      final file = await rootBundle.loadString('assets/linguistic/reading_comprehension.yaml');
      tasks = loadYaml(file)['tests'][test];
      // for (var i = 0; i < tasks[0]["questions"].length; i++) {
        // newQuestions.add(tasks[0]["questions"][i]["question"]);
        // newCorrect.add(tasks[0]["questions"][i]["correct_answer"]);

        // newAnswers.add([]);
        // for (var answer in tasks[0]["questions"][i]["answers"]) {
        //   newAnswers[newAnswers.length - 1].add(answer.toString());
        // }
      // }

      setState(() {
        title = tasks[0]['title'];
        author = tasks[0]['author'];
        text = tasks[0]['text'];
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    readData();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return tasks == null
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            appBar: appBar(context, ''),
            body: Container(
              width: size.width * 0.9,
              height: size.height * 0.9,
              margin: EdgeInsets.only(
                left: size.width / 10,
                right: size.width / 10,
              ),
              child: RawScrollbar(
                thumbColor: Theme.of(context).colorScheme.primary,
                radius: const Radius.circular(20),
                thickness: 5,
                child: SingleChildScrollView(
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            title.toString(),
                            style: TextStyle(
                              fontSize: size.width / 25,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            'by $author',
                            style: TextStyle(fontSize: size.width / 30),
                          ),
                          SizedBox(
                            height: size.height / 30,
                          ),
                          Text(
                            text,
                            style: TextStyle(fontSize: size.height / 50),
                          ),
                        ],
                      ),
                      SizedBox(height: size.height / 10),
                      Center(
                        child: SizedBox(
                          height: size.height * 0.05,
                          width: size.width * 0.75,
                          child: RedirectButton(
                            text: 'Continue',
                            width: size.width,
                            onClick: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => QuizModel(
                                    'Linguistic',
                                    'Linguistic',
                                    60,
                                    initialTest: widget.initialTest,
                                    endingTest: widget.endingTest,
                                    initScore: 0,
                                    initMaxScore: 0,
                                    page: widget.initialTest
                                        ? const Home()
                                        : widget.endingTest
                                        ? const TitlePage(title: 'BrainAce.pro',)
                                        : const Home(),
                                    description: 'Exercise 2 - Reading Comprehension',
                                    oldName: 'reading_comprehension',
                                    exerciseNumber: 2,
                                    exerciseString: 'ReadingComprehension',
                                    questions: {
                                      for (int i = 0; i < tasks[0]['questions'].length; ++i)
                                        '$i': () {
                                          Map<String, String> answers = {};
                                          answers = {
                                            'A': tasks[0]['questions'][i]['answers'][0].toString(),
                                            'B': tasks[0]['questions'][i]['answers'][1].toString(),
                                            if (tasks[0]['questions'][i]['answers'].length >= 3) 'C': tasks[0]['questions'][i]['answers'][2].toString(),
                                            if (tasks[0]['questions'][i]['answers'].length >= 4) 'D': tasks[0]['questions'][i]['answers'][3].toString(),
                                          };
                                          Map<String, bool> correct = {
                                            'A': tasks[0]['questions'][i]['correct_answer'] == 0,
                                            'B': tasks[0]['questions'][i]['correct_answer'] == 1,
                                            'C': tasks[0]['questions'][i]['correct_answer'] == 2,
                                            'D': tasks[0]['questions'][i]['correct_answer'] == 3,
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
                                            question: "${tasks[0]["questions"][i]["question"]}",
                                          );
                                        }(),
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: size.height / 10),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
