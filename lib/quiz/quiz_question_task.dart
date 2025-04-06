import 'package:flutter_html_as_text/flutter_html_as_text.dart';
import 'package:flutter_quizzes/flutter_quizzes.dart';
import 'package:flutter/material.dart';

class QuizQuestionTask extends StatefulWidget {
  final QuizQuestionData question;

  const QuizQuestionTask({super.key,
    required this.question,
});

  @override
  State<QuizQuestionTask> createState() => _QuizQuestionTaskState();
}

class _QuizQuestionTaskState extends State<QuizQuestionTask> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    bool doubleText = widget.question.text != null && widget.question.text2 != null;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.question.introduction != null)
          HtmlAsTextSpan(widget.question.introduction!, fontSize: 0.0175 * size.height),
        if (widget.question.introduction != null) SizedBox(height: 0.005 * size.height),
        if (doubleText)
          Padding(
            padding: EdgeInsets.only(left: 0.01 * size.width),
            child: Text(
              "Text 1",
              style: TextStyle(fontSize: 0.015 * size.height, fontWeight: FontWeight.w500),
            ),
          ),
        if (widget.question.text != null)
          Padding(
            padding: EdgeInsets.only(left: 0.03 * size.width),
            // child: RichText(
            //   text: parseHtmlToTextSpan(context, question.text!, fontSize: 0.0175 * size.height),
            // ),
            child: HtmlAsTextSpan(widget.question.text!, fontSize: 0.0175 * size.height),
          ),
        if (doubleText) SizedBox(height: 0.015 * size.height),
        if (doubleText)
          Padding(
            padding: EdgeInsets.only(left: 0.01 * size.width),
            child: Text(
              "Text 2",
              style: TextStyle(fontSize: 0.015 * size.height, fontWeight: FontWeight.w500),
            ),
          ),
        if (doubleText)
          Padding(
            padding: EdgeInsets.only(left: 0.03 * size.width),
            child: HtmlAsTextSpan(widget.question.text2!, fontSize: 0.0175 * size.height),
          ),
        SizedBox(height: 0.02 * size.height),
        HtmlAsTextSpan("<b>${widget.question.question}</b>", fontSize: 0.0175 * size.height),
      ],
    );
  }
}
