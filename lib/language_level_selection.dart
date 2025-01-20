import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'time_selection.dart';


class LanguageLevelSelection extends StatefulWidget {
  const LanguageLevelSelection({super.key});

  @override
  State<LanguageLevelSelection> createState() => _LanguageLevelSelectionState();
}

class _LanguageLevelSelectionState extends State<LanguageLevelSelection> {
  int? selectedOption;

  Widget levelSelectionButton(BuildContext context, String levelId, String levelName) {
    Size size = MediaQuery.of(context).size;

    return InkWell(
      onTap: () {
        SharedPreferences.getInstance().then((prefs) {
          prefs.setString('level', levelId);
        });

        // Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const TimeSelection(),
          ),
        );
      },
      child: Container(
        width: size.width * 0.6,
        height: size.height / 9,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[
              Theme
                  .of(context)
                  .colorScheme
                  .primary,
              Theme
                  .of(context)
                  .colorScheme
                  .secondary,
            ],
            tileMode: TileMode.decal,
          ),
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
      body: Center(
        child: Container(
          margin: EdgeInsets.only(
            left: size.width / 40,
            right: size.width / 40,
            top: size.height / 10,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                "Select Your",
                style: TextStyle(
                  fontSize: size.width / 13,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 0.01 * size.height),
              Text(
                "English Level",
                style: TextStyle(
                  fontSize: size.width / 13,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 0.07 * size.height),
              levelSelectionButton(context, "pet", "B1 - Intermediate"),
              SizedBox(height: 0.05 * size.height),
              levelSelectionButton(context, "fce", "B2 - Upper-\nIntermediate"),
              SizedBox(height: 0.05 * size.height),
              levelSelectionButton(context, "cae", "C1 - Advanced"),
              SizedBox(height: 0.05 * size.height),
              levelSelectionButton(context, "cpe", "Native Speaker"),
            ],
          ),
        ),
      ),
    );
  }
}
