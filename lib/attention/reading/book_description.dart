import 'package:flutter/material.dart';
import 'package:brainace_pro/app_bar.dart';

class BookDescriptionPage extends StatelessWidget {
  final String title;
  final String author;
  final String imageName;
  final String audienceReview;
  final String genre;
  final String time;
  final String description;
  final bool withGenre;

  const BookDescriptionPage({
    super.key,
    required this.title,
    required this.author,
    required this.imageName,
    required this.audienceReview,
    required this.genre,
    required this.time,
    required this.description,
    this.withGenre = true,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: appBar(context, ""),
      body: Container(
        margin: EdgeInsets.symmetric(
          horizontal: size.width / 10,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: size.height / 40),
              Text(
                title,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: size.height / 64),
              Text(
                author.toUpperCase(),
                style: const TextStyle(fontSize: 18),
              ),
              SizedBox(height: size.height / 32),
              Row(
                children: [
                  SizedBox(
                    width: size.width / 3,
                    child: Image.asset(
                      'assets/attention/reading/$imageName.png',
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: size.width / 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(
                              vertical: 10,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Text(
                                  "Reviews",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  "$audienceReview/5",
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(
                              vertical: 10,
                            ),
                            child: withGenre
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Genre",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        genre,
                                        style: const TextStyle(fontSize: 18),
                                      ),
                                    ],
                                  )
                                : const SizedBox.shrink(),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(
                              vertical: 10,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Text(
                                  "Time",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  time,
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Text(
                description,
                style: const TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
