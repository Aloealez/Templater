import 'package:brainace_pro/home.dart';
import 'package:brainace_pro/main.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import '/navbar.dart';
import 'customize_theme.dart';
import 'tos.dart';
import 'contact.dart';
import 'functions.dart';
import '../score_n_progress/show_improvement.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _Settings();
}

class _Settings extends State<Settings> {
  List<bool> highlighted = [false, false, false, false, false, false, false];

  Widget element(
      BuildContext context,
      Widget? route,
      String text,
      int index, {
        void Function()? onTap,
      }) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        if (onTap != null) {
          onTap();
        }
        if (index == 2) {
          popUp(
            context,
            'By restarting the program, you will return to the welcome screen. Your ',
            'scores will be lost.',
            '',
            'Would you like to restart the App?',
            restartApp,
          );
        } else if (index == 3) {
          popUp(
            context,
            'By ending the program, you will ',
            'receive a final test, ',
            'and then you can continue or go back to home.',
            'Do you want to end the Program now?',
            endProgram,
          );
        } else if (index == 4) {
          Site.launch();
        } else if (route != null) {
          Navigator.push(
            context,
            PageTransition(
              child: route,
              type: PageTransitionType.fade,
            ),
          );
        }
      },
      onTapUp: (details) {
        setState(() {
          highlighted[index] = false;
        });
      },
      onTapDown: (details) {
        setState(() {
          highlighted[index] = true;
        });
      },
      onTapCancel: () {
        setState(() {
          highlighted[index] = false;
        });
      },
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: highlighted[index]
                    ? Theme.of(context).colorScheme.primaryContainer
                    : Theme.of(context).colorScheme.primary,
                width: 4.0,
              ),
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(2137.0),
            ),
            width: double.infinity,
            height: size.height * 0.07,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: highlighted[index]
                            ? Theme.of(context).colorScheme.primaryContainer
                            : Theme.of(context).colorScheme.primary,
                        width: 4.0,
                      ),
                    ),
                    height: size.height * 0.07,
                    width: size.height * 0.07,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Image.asset(
                        "assets/settings/${text.replaceAll(" ", "_").toLowerCase()}.png",
                        fit: BoxFit.fill,
                        gaplessPlayback: true,
                        color: highlighted[index]
                            ? Theme.of(context).colorScheme.primaryContainer
                            : Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: size.width * 0.04),
                Text(
                  text,
                  style: TextStyle(fontSize: size.width / 20),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(
            left: size.width / 10,
            right: size.width / 10,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 0.1 * size.height),
              Center(
                child: Text(
                  "Settings",
                  style: TextStyle(
                    fontSize: size.width / 8,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 0.05 * size.height),
              Column(
                children: [
                  element(context, const TermsOfService(), "Terms of Use", 0),
                  SizedBox(height: size.height * 0.03),
                  element(context, const Contact(), "Contact Us", 1),
                  SizedBox(height: size.height * 0.03),
                  element(context, null, "Reset The App", 2),
                  SizedBox(height: size.height * 0.03),
                  element(
                    context,
                    const ShowImprovement(
                      title: "Attention",
                      description: "Exercise 2 - Long Term Concentration",
                      exercise: 2,
                      yourScore: 1.0,
                      maximum: 10,
                      page: Home(),
                    ),
                    "End The Program",
                    3,
                  ),
                  SizedBox(height: size.height * 0.03),
                  element(context, const SizedBox(), "Our Website", 4),
                  SizedBox(height: size.height * 0.03),
                  element(context, null, "Switch Theme", 5, onTap: () {
                    MyApp.of(context).switchTheme();
                  },),
                  SizedBox(height: size.height * 0.03),
                  element(context, null, "Customize Colors", 6, onTap: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        child: const CustomizeTheme(),
                        type: PageTransitionType.fade,
                      ),
                    );
                  },),
                  SizedBox(height: size.height * 0.03),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const MyBottomNavigationBar(),
    );
  }
}
