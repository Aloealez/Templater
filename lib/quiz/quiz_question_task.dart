import 'package:flutter_html_as_text/flutter_html_as_text.dart';
import 'package:flutter_quizzes/flutter_quizzes.dart';
import 'package:flutter/material.dart';

class QuizQuestionTask extends StatefulWidget {
  final QuizQuestionData question;

  const QuizQuestionTask({
    super.key,
    required this.question,
  });

  @override
  State<QuizQuestionTask> createState() => _QuizQuestionTaskState();
}

class _QuizQuestionTaskState extends State<QuizQuestionTask> {
  bool showIntroduction = true;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    bool _hasText(String? value) => value != null && value.trim().isNotEmpty;

    final hasIntro = _hasText(widget.question.introduction);
    final hasText1 = _hasText(widget.question.text);
    final hasText2 = _hasText(widget.question.text2);
    final isCrossText = hasText1 && hasText2;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Intro section
        if (showIntroduction && hasIntro) ...[
          HtmlAsTextSpan(
            widget.question.introduction!,
            fontSize: 0.0175 * size.height,
          ),
          SizedBox(height: 0.005 * size.height),
        ],

        // Text 1 section
        if (hasText1) ...[
          if (isCrossText)
            Padding(
              padding: EdgeInsets.only(left: 0.01 * size.width),
              child: Text(
                "Text 1",
                style: TextStyle(
                  fontSize: 0.015 * size.height,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          Padding(
            padding: EdgeInsets.only(
              top: (!hasIntro && !isCrossText) ? 0 : 0.005 * size.height,
              left:
                  isCrossText || hasIntro ? 0.03 * size.width : 0 * size.width,
            ),
            child: HtmlAsTextSpan(
              widget.question.text!,
              fontSize: 0.0175 * size.height,
            ),
          ),
          SizedBox(height: 0.015 * size.height),
        ],

        // Text 2 section
        if (hasText2) ...[
          if (isCrossText)
            Padding(
              padding: EdgeInsets.only(left: 0.01 * size.width),
              child: Text(
                "Text 2",
                style: TextStyle(
                  fontSize: 0.015 * size.height,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          Padding(
            padding: EdgeInsets.only(
              left: 0.03 * size.width,
              top: 0.005 * size.height,
            ),
            child: HtmlAsTextSpan(
              widget.question.text2!,
              fontSize: 0.0175 * size.height,
            ),
          ),
          SizedBox(height: 0.015 * size.height),
        ],

        // Final Question
        HtmlAsTextSpan(
          "<b>${widget.question.question}</b>",
          fontSize: 0.0175 * size.height,
        ),
      ],
    );
  }
}
