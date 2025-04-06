import 'package:flutter/material.dart';
import '../../app_bar.dart';

class SudokuInfo extends StatefulWidget {
  const SudokuInfo({super.key});

  @override
  State<SudokuInfo> createState() => _SudokuInfo();
}

class _SudokuInfo extends State<SudokuInfo> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: appBar(context, ""),
      body: Container(
        margin: EdgeInsets.only(
          left: size.width / 15,
          right: size.width / 15,
          bottom: size.height / 10,
          top: size.height / 20,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            RichText(
              text: TextSpan(
                text:
                    'Fill a 9x9 grid so that each row, column, and 3x3 subgrid (also called a box or a region) contains all the digits from 1 to 9 without repeating any numbers within a row, column, or subgrid. ',
                style: TextStyle(
                  fontSize: size.height / 50,
                  color: Theme.of(context).colorScheme.onSurface,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            SizedBox(height: 0.02 * size.height),
            RichText(
              text: TextSpan(
                text: 'In this exercise ',
                style: TextStyle(
                  fontSize: size.height / 50,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                children: const <TextSpan>[
                  TextSpan(
                    text: 'time will be measured ',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  TextSpan(
                    text: 'as you complete a 9x9 sudoku puzzle. The puzzles will get harder as you progress.',
                  ),
                ],
              ),
            ),
            SizedBox(height: 0.02 * size.height),
            RichText(
              text: TextSpan(
                text: 'For each ',
                style: TextStyle(
                  fontSize: size.height / 50,
                  color: Theme.of(context).colorScheme.onSurface,
                  fontStyle: FontStyle.italic,
                ),
                children: const <TextSpan>[
                  TextSpan(
                    text: 'correctly filled puzzle ',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  TextSpan(text: 'completed under 15 minutes you will '),
                  TextSpan(
                    text: 'get 1 point, ',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  TextSpan(text: 'for each '),
                  TextSpan(
                    text: 'wrongly filled puzzle ',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  TextSpan(text: 'you will '),
                  TextSpan(
                    text: 'lose 1 point.',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
