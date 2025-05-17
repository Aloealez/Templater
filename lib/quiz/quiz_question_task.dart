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
    bool _hasIntroduction(String? intro) {
      // Returns true if intro is not null and not empty or whitespace only
      return intro != null && intro.trim().isNotEmpty;
    }

    bool doubleText =
        widget.question.text != null && widget.question.text2 != null;

    // Check if the introduction is empty or null
    bool hasIntroduction = _hasIntroduction(widget.question.introduction);
    final double leftPadding =
        hasIntroduction ? 0.03 * size.width : 0 * size.width;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // First section - introduction text, may be null
        if (showIntroduction && widget.question.introduction != null)
          HtmlAsTextSpan(
            widget.question.introduction!,
            fontSize: 0.0175 * size.height,
          ),
        if (showIntroduction && widget.question.introduction != null)
          SizedBox(height: 0.005 * size.height),

        // Optional "Text 1" label if doubleText is true
        if (doubleText)
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

        // Second section - primary text - conditionally padded
        if (widget.question.text != null)
          Padding(
            padding: EdgeInsets.only(left: leftPadding),
            child: HtmlAsTextSpan(
              widget.question.text!,
              fontSize: 0.0175 * size.height,
            ),
          ),

        if (doubleText) SizedBox(height: 0.015 * size.height),

        // Optional "Text 2" label if doubleText is true
        if (doubleText)
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

        // Third section - secondary text - paddings same logic
        if (doubleText)
          Padding(
            padding: EdgeInsets.only(
              left: showIntroduction ? 0.03 * size.width : 0.01 * size.width,
            ),
            child: HtmlAsTextSpan(
              widget.question.text2!,
              fontSize: 0.0175 * size.height,
            ),
          ),

        SizedBox(height: 0.02 * size.height),

        // Final question text (bold)
        HtmlAsTextSpan(
          "<b>${widget.question.question}</b>",
          fontSize: 0.0175 * size.height,
        ),
      ],
    );
  }
}
