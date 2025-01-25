import 'package:flutter/material.dart';
import '../../activities/activity_button.dart';
import '../../app_bar.dart';
import 'book_description.dart';

class Business extends StatefulWidget {
  const Business({super.key});

  @override
  State<Business> createState() => _Business();
}

class _Business extends State<Business> {
  Widget createActivity2(
    BuildContext context,
    String img,
    String txt1,
    String txt2,
    Widget route, {
    double fontSize = 1,
  }) {
    Size size = MediaQuery.of(context).size;
    return ActivityButton(
      context,
      img: "attention/reading/$img",
      text1: txt1,
      text2: txt2,
      fontSize: 0.025 * size.height * fontSize,
      onTapRoute: route,
      zero: 0.8,
      textWidth: 0.4,
      title: true,
    );
  }

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
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  "BUSINESS",
                  style: TextStyle(
                    fontSize: size.width / 8,
                    fontWeight: FontWeight.w500,
                    height: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  "& MONEY",
                  style: TextStyle(
                    fontSize: size.width / 18,
                    height: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            SizedBox(height: 0.03 * size.height),
            Expanded(
              child: ListView(
                children: [
                  Container(
                    margin: EdgeInsets.only(
                      left: size.width / 20,
                      right: size.width / 20,
                    ),
                    child: Column(
                      children: [
                        createActivity2(
                          context,
                          "business/the_richest_man_in_babylon",
                          "The Richest Man in Babylon",
                          "by George Samuel Clason",
                          const BookDescriptionPage(
                            title: "The Richest Man in Babylon",
                            author: "George Samuel Clason",
                            imageName: "covers/babylon",
                            audienceReview: "4.6",
                            genre: "",
                            time: "2.5 h",
                            description:
                                "\"The Richest Man in Babylon\" by George Samuel Clason offers timeless financial wisdom through a collection of parables set in ancient Babylon. It imparts valuable lessons on personal finance, emphasizing principles like saving, investing, and wise money management to achieve lasting wealth and financial freedom.",
                            withGenre: false,
                          ),
                          fontSize: 0.9,
                        ),
                        createActivity2(
                          context,
                          "business/rich_dad_poor_dad",
                          "Rich Dad Poor Dad",
                          "by Robert T. Kiyosaki",
                          const BookDescriptionPage(
                            title: "Rich Dad Poor Dad",
                            author: "Robert T. Kiyosaki",
                            imageName: "covers/dad",
                            audienceReview: "4.6",
                            genre: "",
                            time: "4 h 50 m",
                            description:
                                "\"Rich Dad Poor Dad: What the Rich Teach Their Kids About Money That the Poor and Middle Class Do Not!\" by Robert T. Kiyosaki contrasts the financial philosophies of two father figures—one rich, one poor. Kiyosaki shares insights into building wealth, investing wisely, and cultivating a mindset geared towards financial independence, challenging conventional beliefs about money and success.",
                            withGenre: false,
                          ),
                          fontSize: 0.9,
                        ),
                        createActivity2(
                          context,
                          "business/the_intelligent_investor",
                          "The Intelligent Investor",
                          "by Benjamin Graham",
                          const BookDescriptionPage(
                            title: "The Intelligent Investor",
                            author: "Benjamin Graham",
                            imageName: "covers/investor",
                            audienceReview: "4.7",
                            genre: "",
                            time: "11 h",
                            description:
                                "\"The Intelligent Investor\" by Benjamin Graham is a seminal work on value investing, advocating for a disciplined, rational approach to stock market investing. Graham's principles, including the importance of fundamental analysis, margin of safety, and long-term thinking, continue to shape the strategies of investors worldwide.",
                            withGenre: false,
                          ),
                          fontSize: 0.9,
                        ),
                        createActivity2(
                          context,
                          "business/principles",
                          "Principles: Life and Work",
                          "by Ray Dalio",
                          const BookDescriptionPage(
                            title: "Principles: Life and Work",
                            author: "Ray Dalio",
                            imageName: "covers/principles",
                            audienceReview: "4.5",
                            genre: "",
                            time: "10 h",
                            description:
                                "\"Principles: Life and Work\" by Ray Dalio outlines the author's principles for success in both personal and professional life, distilled from his experiences as a highly successful investor and entrepreneur. Dalio emphasizes the importance of radical transparency, open-mindedness, and a systematic approach to decision-making to achieve meaningful outcomes.",
                            withGenre: false,
                          ),
                          fontSize: 0.9,
                        ),
                        createActivity2(
                          context,
                          "business/influence",
                          "Influence: The Psychology of Persuasion",
                          "by Robert B. Cialdini",
                          const BookDescriptionPage(
                            title: "Influence: The Psychology of Persuasion",
                            author: "Robert B. Cialdini",
                            imageName: "covers/influence",
                            audienceReview: "4.2",
                            genre: "",
                            time: "5 h 40 min",
                            description:
                                "\"Influence: The Psychology of Persuasion\" by Robert B. Cialdini explores the psychology behind why people say \"yes\" and the techniques used to influence others' behaviors. Cialdini identifies six universal principles of persuasion—such as reciprocity, scarcity, and authority—and illustrates their application through real-world examples, helping readers understand and resist manipulation.",
                            withGenre: false,
                          ),
                          fontSize: 0.9,
                        ),
                        createActivity2(
                          context,
                          "business/the_magic_of_thinking_big",
                          "The Magic Of Thinking Big",
                          "by David J. Schwartz",
                          const BookDescriptionPage(
                            title: "The Magic Of Thinking Big",
                            author: "David J. Schwartz",
                            imageName: "covers/magic",
                            audienceReview: "4.7",
                            genre: "",
                            time: "4 h",
                            description:
                                "\"The Magic of Thinking Big\" by David J. Schwartz promotes the power of positive thinking and self-belief in achieving personal and professional success. Schwartz encourages readers to overcome self-limiting beliefs, set ambitious goals, and cultivate a mindset of confidence and resilience to unlock their full potential and accomplish their dreams.",
                            withGenre: false,
                          ),
                          fontSize: 0.9,
                        ),
                      ],
                    ),
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
