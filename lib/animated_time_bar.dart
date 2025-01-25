import 'package:flutter/material.dart';

class AnimatedTimeBar extends StatefulWidget {
  final double totalTime;
  final double timeLeft;

  const AnimatedTimeBar({
    super.key,
    required this.totalTime,
    required this.timeLeft,
  });

  @override
  _AnimatedTimeBarState createState() => _AnimatedTimeBarState();
}

class _AnimatedTimeBarState extends State<AnimatedTimeBar> {
  double timePassed = 0;
  double animatedWidth = 0.0;
  double lastTimePassed = 0;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(milliseconds: 10), () {
      setState(() {
        animatedWidth = 1.0;
      });
    });
  }

  @override
  void didUpdateWidget(AnimatedTimeBar oldWidget) {
    timePassed = widget.totalTime - widget.timeLeft;
    if (timePassed != lastTimePassed) {
      setState(() {
        animatedWidth = 0.0;
      });
      Future.delayed(Duration(milliseconds: 10), () {
        setState(() {
          animatedWidth = 1.0;
        });
      });
    }
    lastTimePassed = timePassed;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    timePassed = widget.totalTime - widget.timeLeft;
    Size size = MediaQuery.of(context).size;
    return Align(
      alignment: Alignment.center,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(79),
        child: Container(
          width: size.width * 0.9,
          height: size.height * 0.005,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(widget.totalTime.toInt(), (index) {
              if (index == timePassed) {
                return Flexible(
                  flex: 1,
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 1010),
                    width: animatedWidth * size.width * 0.9 / widget.totalTime,
                    color: Theme.of(context).colorScheme.primaryContainer,
                    child: const Align(
                      alignment: Alignment.center,
                    ),
                  ),
                );
              } else if (index < timePassed) {
                return Flexible(
                  flex: 1,
                  child: Container(
                    color: Theme.of(context).colorScheme.primaryContainer,
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
