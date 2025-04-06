import 'package:flutter/material.dart';
import 'dart:math';
import '../../app_bar.dart';
import 'content.dart';
import 'package:flutter_quizzes/flutter_quizzes.dart';

class Poems extends StatefulWidget {
  const Poems({super.key});

  static Poems routeBuilder(
      BuildContext context, {
        required bool initialTest,
        required bool endingTest,
      }) {
    return Poems(
    );
  }

  @override
  State<Poems> createState() => _Poems();
}

var rng = Random();

class _Poems extends State<Poems> {
  int poemIndex = rng.nextInt(15);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: appBar(context, ""),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(
            left: size.width / 15,
            right: size.width / 15,
            bottom: size.height / 10,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: Text(
                    poems[poemIndex]["title"].toString(),
                    style: TextStyle(
                      fontSize: 0.07 * size.width,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 0.02 * size.height),
                Text(
                  "by ${poems[poemIndex]["author"].toString()}",
                  style: TextStyle(
                    fontSize: 0.05 * size.width,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
                createDivider(context),
                Text(
                  poems[poemIndex]["content"].toString(),
                  style: TextStyle(
                      fontSize: size.height / 60, height: size.height / 500,),
                  textAlign: TextAlign.justify,
                ),
                createDivider(context),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
