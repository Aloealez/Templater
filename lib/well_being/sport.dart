import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../app_bar.dart';

class Sport extends StatefulWidget {
  const Sport({super.key});

  @override
  State<Sport> createState() => _Sport();
}

GestureDetector createDay(
  BuildContext context,
  int dayNum,
  String text, [
  String? videoId,
]) {
  Future<void> launchURL(String url) async {
    await launchUrl(Uri.parse(url));
  }

  Size size = MediaQuery.of(context).size;
  return GestureDetector(
    onTap: () {
      if (videoId == null) return;
      final youtubeUrl = 'https://www.youtube.com/watch?v=$videoId';
      launchURL(youtubeUrl);
    },
    child: Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
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
          height: videoId != null ? 0.13 * size.height : 0.07 * size.height,
          width: 0.8 * size.width,
          child: Row(
            children: [
              SizedBox(width: 0.05 * size.width),
              if (videoId != null)
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  height: 0.08 * size.height,
                  width: 0.15 * size.height,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    child: Image.network(
                      'https://img.youtube.com/vi/$videoId/0.jpg',
                      fit: BoxFit.fitWidth,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Center(
                                child: Icon(
                                  Icons.clear,
                                  color: Colors.red,
                                  size: 48,
                                ),
                              ),
                              SizedBox(height: 8),
                              Center(
                                child: Text(
                                  'Check internet connection',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              SizedBox(width: 0.03 * size.width),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    text: '',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: size.width / 22,
                      height: 1.2,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Day ${dayNum.toString()}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: text),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 0.01 * size.width),
            ],
          ),
        ),
        SizedBox(height: 0.015 * size.height),
      ],
    ),
  );
}

class _Sport extends State<Sport> {
  /*Future<void> launchURL(String url) async {
    await launchUrl(Uri.parse(url));
  }*/

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: appBar(context, ""),
      body: Container(
        margin: EdgeInsets.only(
          left: size.width / 20,
          right: size.width / 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: Text(
                    "Sport",
                    style: TextStyle(
                      fontSize: size.width / 8,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Center(
                  child: Text(
                    "10 DAY PLAN",
                    style: TextStyle(fontSize: size.width / 17),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            SizedBox(height: 0.02 * size.height),
            Expanded(
              child: ListView(
                children: [
                  Container(
                    margin: EdgeInsets.only(
                      left: size.width / 15,
                      right: size.width / 15,
                    ),
                    child: Column(
                      children: [
                        Text(
                          "When exercising remember about: ",
                          style: TextStyle(
                            fontSize: size.width / 22,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        Row(
                          children: [
                            const Text(
                              "\u2022",
                              style: TextStyle(fontSize: 30, height: 0.8),
                            ),
                            SizedBox(width: 0.02 * size.width),
                            Text(
                              'Variety',
                              style: TextStyle(
                                fontSize: 0.022 * size.height,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                                height: 1,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Text(
                              "\u2022",
                              style: TextStyle(fontSize: 30, height: 0.8),
                            ),
                            SizedBox(width: 0.02 * size.width),
                            Text(
                              'Consistency',
                              style: TextStyle(
                                fontSize: 0.022 * size.height,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                                height: 1,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 0.02 * size.height),
                  createDay(context, 1, ' - Outdoor Walk'),
                  createDay(
                    context,
                    2,
                    ' - Strenght Full Body Workout',
                    'LdFgFco_8p8',
                  ),
                  createDay(context, 3, ' - 30 min Outdoor Run'),
                  createDay(context, 4, ' - Outdoor Walk'),
                  createDay(
                    context,
                    5,
                    ' - Strenght Abs And Glutes Workout',
                    'O2f93wRCNmo',
                  ),
                  createDay(context, 6, ' - Outdoor Walk'),
                  createDay(
                    context,
                    7,
                    ' - High Intensity Cardio Workout',
                    'qnkBM6xsv0Q',
                  ),
                  createDay(context, 8, ' - Outdoor Walk'),
                  createDay(context, 9, ' - 30 min Outdoor Run'),
                  createDay(
                    context,
                    10,
                    ' - Strenght Abs And Glutes Workout',
                    'MDnOqSh5M0E',
                  ),
                  SizedBox(height: 0.1 * size.height),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
