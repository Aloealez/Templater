import 'package:brainace_pro/title_page.dart';
import 'package:flutter/material.dart';
import '../buttons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../attention/short_term_concentration.dart';
import '../memory/learning_words/memory.dart';
import '../linguistic/listening_comprehension_video.dart';
import '../logical_thinking/riddles_info.dart';
import 'package:brainace_pro/app_bar.dart';

class Finish extends StatefulWidget {
  const Finish({
    super.key,
  });

  @override
  State<Finish> createState() => _Finish();
}

class _Finish extends State<Finish> {
  late SharedPreferences prefs;
  String skill = "";
  Widget functionToRun = const Memory(
    endingTest: true,
  );
  Future<void> getSkill() async {
    prefs = await SharedPreferences.getInstance();
    String newSkill = prefs.getString('skill')!;

    setState(() {
      skill = newSkill;
    });
  }

  @override
  void initState() {
    super.initState();
    getSkill().then((value) {
      if (skill == "attention") {
        functionToRun = const ShortTermConcentration(
          endingTest: true,
        );
      } else if (skill == "linguistic") {
        functionToRun = const ListeningComprehensionVideo(
          endingTest: true,
        );
      } else if (skill == "logical") {
        functionToRun = const Riddles(
          endingTest: true,
        );
      } else if (skill == "games") {
        functionToRun = const TitlePage(
          title: 'BrainAce.pro',
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return PopScope(
      canPop: false,
      child: (skill != "")
          ? Scaffold(
              appBar: appBar(context, ""),
              body: DecoratedBox(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: const AssetImage(
                        "assets/investing/success_background.gif",),
                    fit: BoxFit.cover,
                    opacity: ((Theme.of(context).brightness == Brightness.dark)
                        ? 0.3
                        : 0.4),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                        left: size.width / 10,
                        right: size.width / 10,
                        top: size.height / 10,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "CONGRATS",
                            style: TextStyle(fontSize: 0.1 * size.width),
                          ),
                          SizedBox(
                            height: 0.01 * size.height,
                          ),
                          Text(
                            "You have just finished",
                            style: TextStyle(fontSize: 0.05 * size.width),
                          ),
                          SizedBox(height: 0.01 * size.height),
                          Text(
                            "your 30 day",
                            style: TextStyle(fontSize: 0.05 * size.width),
                          ),
                          SizedBox(height: 0.01 * size.height),
                          Text(
                            "Brain Improvement Program",
                            style: TextStyle(fontSize: 0.05 * size.width),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Center(
                      child: SizedBox(
                        height: size.height * 0.05,
                        width: size.width * 0.75,
                        child: RedirectButton(
                          route: functionToRun,
                          text: (skill == "games")
                              ? "Continue"
                              : 'Begin The Final Test',
                          width: size.width,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: size.height / 10,
                    ),
                  ],
                ),
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
