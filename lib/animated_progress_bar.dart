import 'package:flutter/material.dart';

class AnimatedProgressBar extends StatefulWidget {
  final int answerCount;
  final Map<String, bool> answers;

  const AnimatedProgressBar({
    super.key,
    required this.answerCount,
    required this.answers,
  });

  @override
  _AnimatedProgressBarState createState() => _AnimatedProgressBarState();
}

class _AnimatedProgressBarState extends State<AnimatedProgressBar> {
  int answeredCount = 0;
  int previousAnsweredCount = 0;
  int lastAnswer = -1;
  double animatedWidth = 0.0;

  @override
  void didUpdateWidget(AnimatedProgressBar oldWidget) {
    answeredCount = widget.answers.length;
    if (answeredCount != previousAnsweredCount) {
      setState(() {
        lastAnswer++;
        animatedWidth = 0.0;
      });
      Future.delayed(Duration(milliseconds: 10), () {
        setState(() {
          animatedWidth = 1.0;
        });
      });
      // WidgetsBinding.instance.addPostFrameCallback((_) {
      //   setState(() {
      //     animatedWidth = 1.0;
      //   });
      // });
    }
    previousAnsweredCount = answeredCount;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Align(
      alignment: Alignment.center,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(7),
        child: Container(
          width: size.width * 0.9,
          height: size.height * 0.005,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(widget.answerCount, (index) {
              if (index == lastAnswer) {
                return Flexible(
                  flex: 1,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    width: animatedWidth * size.width * 0.9 / widget.answerCount,
                    color: widget.answers.values.elementAt(index)
                        ? Colors.green
                        : Colors.red,
                    child: const Align(
                      alignment: Alignment.center,
                    ),
                  ),
                );
              } else if (index <= lastAnswer) {
                return Flexible(
                  flex: 1,
                  child: Container(
                    color: widget.answers.values.elementAt(index)
                            ? Colors.green
                            : Colors.red,
                    child: const Align(
                      alignment: Alignment.center,
                    ),
                  ),
                );
              } else  {
                return Flexible(
                  flex: 1,
                  child: Container(
                    color: null,
                    child: const Align(
                      alignment: Alignment.center,
                    ),
                  ),
                );
              }
            }),
          ),
        ),
      ),
    );
  }
}
