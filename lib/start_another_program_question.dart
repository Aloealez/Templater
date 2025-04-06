import 'package:flutter/material.dart';
import 'improvement_selection.dart';

class StartAnotherProgram extends StatefulWidget {
  const StartAnotherProgram({super.key});

  @override
  State<StartAnotherProgram> createState() => _StartAnotherProgramState();
}

Widget timeButton(BuildContext context, String txt) {
  Size size = MediaQuery.of(context).size;

  return InkWell(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ImprovementSelection(),
        ),
      );
    },
    child: Container(
      width: size.width / 3,
      height: size.height / 15,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.secondary,
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
          txt,
          style: TextStyle(
            fontSize: size.width / 16,
            color: Theme.of(context).colorScheme.surface,
          ),
        ),
      ),
    ),
  );
}

class _StartAnotherProgramState extends State<StartAnotherProgram> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(
          left: size.width / 10,
          right: size.width / 10,
          top: size.height / 10,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              "Would you like to continue the same 30 Day Brain Improvement Program?",
              style: TextStyle(
                fontSize: size.width / 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                timeButton(context, "No"),
                timeButton(context, "Yes"),
              ],
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
