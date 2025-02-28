import 'package:brainace_pro/score_n_progress/finish_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:brainace_pro/title_page.dart';
import 'package:url_launcher/url_launcher.dart';

import '../main.dart';

Future<void> popUp(
    BuildContext context,
    String txt,
    String txtBold,
    String txt2,
    String question,
    Function fn,
    ) async {
  Size size = MediaQuery.of(context).size;
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        scrollable: true,
        content: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            child: Column(
              children: <Widget>[
                RichText(
                  text: TextSpan(
                    text: txt,
                    style: TextStyle(
                      fontSize: size.width / 20,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: txtBold,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: size.width / 20,
                        ),
                      ),
                      TextSpan(text: txt2),
                      TextSpan(text: '\n\n$question'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(
                    Theme.of(context).colorScheme.primary,
                  ),
                ),
                child: SizedBox(
                  width: size.width / 8,
                  child: Center(
                    child: Text(
                      "No",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: size.width / 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  fn(context);
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(
                    Theme.of(context).colorScheme.primary,
                  ),
                ),
                child: SizedBox(
                  width: size.width / 8,
                  child: Center(
                    child: Text(
                      "Yes",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: size.width / 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    },
  );
}

void endProgram(BuildContext context) {
  // Instead of resetting, just navigate to the final screen
  SharedPreferences.getInstance().then((prefs) {
    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const Finish(),
        ),
      );
    }
  });
}

Future<void> restartAppButton(BuildContext context) async {
  Size size = MediaQuery.of(context).size;
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        scrollable: true,
        content: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            child: Column(
              children: <Widget>[
                RichText(
                  text: TextSpan(
                    text:
                    'By restarting the program, you will return to the welcome screen. Your ',
                    style: TextStyle(
                      fontSize: size.width / 20,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'scores will be lost.',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: size.width / 20,
                        ),
                      ),
                      const TextSpan(text: '\n\nDo you want to continue?'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(
                    Theme.of(context).colorScheme.primary,
                  ),
                ),
                child: SizedBox(
                  width: size.width / 8,
                  child: Center(
                    child: Text(
                      "No",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: size.width / 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  SharedPreferences.getInstance().then((prefs) {
                    prefs.clear();
                    if (context.mounted) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                          const TitlePage(title: 'BrainAce.pro'),
                        ),
                      );
                    }
                  });
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(
                    Theme.of(context).colorScheme.primary,
                  ),
                ),
                child: SizedBox(
                  width: size.width / 8,
                  child: Center(
                    child: Text(
                      "Yes",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: size.width / 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    },
  );
}

void restartApp(BuildContext context) {
  SharedPreferences.getInstance().then((prefs) {
    prefs.clear();
    // Reload theme so the new user starts fresh
    if (context.mounted) {
      MyApp.of(context).reloadTheme();
    }
    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const TitlePage(title: 'BrainAce.pro'),
        ),
      );
    }
  });
}

class Site {
  static void launch() {
    launchUrl(
      Uri.parse(
        "https://braintrain-by-wk.shorthandstories.com/thebraintrainapp/index.html#article",
      ),
    );
  }
}
