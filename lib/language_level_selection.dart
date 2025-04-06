import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_bar.dart';
import 'time_selection.dart';

class LanguageLevelSelection extends StatefulWidget {
  const LanguageLevelSelection({super.key});

  @override
  State<LanguageLevelSelection> createState() => _LanguageLevelSelectionState();
}

class _LanguageLevelSelectionState extends State<LanguageLevelSelection> {
  int? selectedOption;

  Widget levelSelectionButton(
    BuildContext context,
    String levelId,
    String levelName, {
    Color? color,
  }) {
    Size size = MediaQuery.of(context).size;

    return InkWell(
      onTap: () {
        SharedPreferences.getInstance().then((prefs) {
          prefs.setString('level', levelId);
        });

        // Navigator.pop(context);
        Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.fade,
            child: const TimeSelection(),
            reverseDuration: const Duration(milliseconds: 100),
            opaque: false,
          ),
        );
      },
      child: Container(
        width: size.width * 0.75,
        height: size.height / 12,
        decoration: BoxDecoration(
          color: color ?? Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.shadow,
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(5, 5),
            ),
          ],
        ),
        child: Center(
          child: Text(
            levelName,
            style: TextStyle(
              fontSize: size.width / 19,
              color: Theme.of(context).colorScheme.onSecondary,
              shadows: <Shadow>[
                Shadow(
                  offset: const Offset(2.0, 2.0),
                  blurRadius: 3.0,
                  color: Theme.of(context).colorScheme.shadow,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: appBar(context, ""),
      body: Center(
        child: Container(
          margin: EdgeInsets.only(
            left: size.width / 40,
            right: size.width / 40,
            top: size.height / 69,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                "Select Your",
                style: TextStyle(
                  fontSize: size.width / 13,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 0.01 * size.height),
              Text(
                "English Level",
                style: TextStyle(
                  fontSize: size.width / 13,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.onSurface,
                    height: 0.7
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 0.07 * size.height),
              levelSelectionButton(
                context,
                "cpe",
                "Native Speaker",
                color: Theme.of(context).colorScheme.tertiary,
              ),
              SizedBox(height: 0.03 * size.height),
              levelSelectionButton(
                context,
                "cae",
                "Advanced (C1)",
                color: Theme.of(context).colorScheme.primary,
              ),
              SizedBox(height: 0.03 * size.height),
              levelSelectionButton(
                context,
                "pet",
                "Intermediate (B1+)",
                color: Theme.of(context).colorScheme.primary,
              ),
              SizedBox(height: 0.03 * size.height),
              levelSelectionButton(
                context,
                "fce",
                "Beginner (A1-A2)",
                color: Theme.of(context).colorScheme.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
