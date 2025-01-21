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
  Color? animationColor = Colors.green;
  double timePassed = 0;
  double animatedWidth = 0.0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    timePassed = widget.totalTime - widget.timeLeft;
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
            children: List.generate(widget.totalTime.toInt(), (index) {
              if (index == timePassed) {
                print("Equal");
                setState(() {
                  animatedWidth = 0.0;
                });
                // animationColor = null;
                Future.delayed(Duration(milliseconds:  300), () {
                  setState(() {
                    animatedWidth = 1.0;
                    animationColor = Theme.of(context).colorScheme.primaryContainer;
                  });
                });
                return Flexible(
                  flex: 1,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 700),
                    width: animatedWidth * timePassed * size.width * 0.9 / widget.totalTime,
                    color: Colors.green,
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
