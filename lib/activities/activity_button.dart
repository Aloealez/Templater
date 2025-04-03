import 'package:brainace_pro/activities_for_each_section.dart';
import 'package:flutter/material.dart';
import 'package:icon_decoration/icon_decoration.dart';
import 'package:page_transition/page_transition.dart';
import 'dart:math' as dart_math;

class ActivityButton extends StatelessWidget {
  final String img;
  final String text1;
  final String text2;
  final double fontSize;
  final Widget? onTapRoute;
  final Color? leftColorGradient;
  final Color? rightColorGradient;
  final double zero;
  final bool blocked;
  final double textWidth;
  final bool title;
  final bool star;
  final bool forceStar;
  final String exerciseName;
  final String skill;
  final List<String> plan;

  const ActivityButton(
      BuildContext context, {
        required this.img,
        required this.text1,
        required this.text2,
        required this.fontSize,
        this.onTapRoute,
        this.leftColorGradient,
        this.rightColorGradient,
        this.zero = 1,
        this.blocked = false,
        this.textWidth = 0.45,
        this.title = false,
        this.star = false,
        this.forceStar = false,
        this.exerciseName = "",
        this.skill = "",
        this.plan = const [],
        super.key,
      });


  @override
  Widget build(BuildContext context) {
    Color color1 = leftColorGradient != null ? leftColorGradient! : Theme.of(context).colorScheme.primary;
    Color color2 = rightColorGradient != null ? rightColorGradient! : Theme.of(context).colorScheme.secondary;

    Size size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        if (blocked) {
          return;
        }
        if (sectionActivities[exerciseName] != null) {
          Navigator.push(
            context,
            PageTransition(
              type: PageTransitionType.fade,
              child: sectionActivities[exerciseName]!(context),
              reverseDuration: const Duration(milliseconds: 100),
              opaque: false,
            ),
          );
        } else if (onTapRoute != null) {
          Navigator.push(
            context,
            PageTransition(
              type: PageTransitionType.fade,
              child: onTapRoute,
              reverseDuration: const Duration(milliseconds: 100),
              opaque: false,
            ),
          );
        }
      },
      child:
      Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[
                  color1,
                  color2,
                ],
                tileMode: TileMode.decal,
              ),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.shadow,
                  spreadRadius: 4,
                  blurRadius: 6,
                  offset: const Offset(3, 3),
                ),
              ],
            ),
            height: 0.115 * size.height,
            child: Stack(
              children: [
                if ((star && plan.contains(exerciseName)) || forceStar)
                  Align(
                    alignment: Alignment(0.98, -0.85),
                    child: Icon(
                      Icons.star_rounded,
                      color: const Color.fromARGB(255, 255, 208, 0),
                      size: 0.036 * size.height,
                    ),
                  ),
                Align(
                  alignment: Alignment.center,
                  child: Row(
                    children: [
                      SizedBox(
                        height: 0.115 * size.height,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: FadeInImage(
                            placeholder: (Theme.of(context).brightness == Brightness.light)
                                ? const AssetImage('assets/placeholder.png')
                                : const AssetImage('assets/placeholder_dark.png'),
                            image: AssetImage('assets/$img.png'),
                            fit: BoxFit.cover,
                            fadeInDuration: const Duration(milliseconds: 200),
                          ),
                        ),
                      ),
                      SizedBox(width: 0.025 * size.width),
                      SizedBox(
                        width: size.width * textWidth,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              text1,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontSize: fontSize,
                                fontWeight: FontWeight.bold,
                                height: 1.2,
                                fontStyle: (title) ? FontStyle.italic : FontStyle.normal,
                              ),
                            ),
                            text2 == ""
                                ? const SizedBox(width: 0, height: 0)
                                : Text(
                              text2,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontSize: zero * fontSize,
                                fontWeight: FontWeight.bold,
                                height: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 0.025 * size.height),
        ],
      ),
    );
  }
}

