import 'package:flutter/material.dart';
import '../../activities/activity_button.dart';
import '../../app_bar.dart';
import 'book_description.dart';

class PersonalDevelopment extends StatefulWidget {
  const PersonalDevelopment({super.key});

  @override
  State<PersonalDevelopment> createState() => _PersonalDevelopment();
}

class _PersonalDevelopment extends State<PersonalDevelopment> {
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
      color1: Theme.of(context).colorScheme.primary,
      color2: Theme.of(context).colorScheme.secondary,
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
                  "PERSONAL",
                  style: TextStyle(
                    fontSize: size.width / 8,
                    fontWeight: FontWeight.w500,
                    height: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  "DEVELOPMENT",
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
                          "personal_development/how_to_win_friends",
                          "How to Win Friends and Influence People",
                          "by Dale Carnegie",
                          const BookDescriptionPage(
                            title: "How to Win Friends and Influence People",
                            author: "Dale Carnegie",
                            imageName: "covers/friends",
                            audienceReview: "4.7",
                            genre: "",
                            time: "5.3 h",
                            description:
                                "\"How to Win Friends and Influence People\" by Dale Carnegie is a classic self-help book that offers practical advice on interpersonal skills and effective communication. Carnegie's principles focus on building positive relationships, understanding others' perspectives, and influencing behavior through empathy, appreciation, and constructive interaction.",
                            withGenre: false,
                          ),
                          fontSize: 0.85,
                        ),
                        createActivity2(
                          context,
                          "personal_development/the_power_of_habit",
                          "The Power of Habit: Why We Do What We Do in Life and Business",
                          "by Charles Duhigg",
                          const BookDescriptionPage(
                            title:
                                "The Power of Habit: Why We Do What We Do in Life and Business",
                            author: "Charles Duhigg",
                            imageName: "covers/habit",
                            audienceReview: "4.7",
                            genre: "",
                            time: "7 h",
                            description:
                                "\"The Power of Habit: Why We Do What We Do in Life and Business\" by Charles Duhigg explores the science behind habits and how they shape our lives. Duhigg delves into the neurological mechanisms of habit formation, providing insights into how habits can be changed or transformed. Through real-life examples and case studies, he demonstrates the power of habit in driving personal and professional success.",
                            withGenre: false,
                          ),
                          fontSize: 0.7,
                        ),
                        createActivity2(
                          context,
                          "personal_development/the_power_of_now",
                          "The Power of Now: A Guide to Spiritual Enlightenment",
                          "by Eckhart Tolle",
                          const BookDescriptionPage(
                            title:
                                "The Power of Now: A Guide to Spiritual Enlightenment",
                            author: "Eckhart Tolle",
                            imageName: "covers/now",
                            audienceReview: "4.6",
                            genre: "",
                            time: "3.5 h",
                            description:
                                "\"The Power of Now: A Guide to Spiritual Enlightenment\" by Eckhart Tolle offers a transformative perspective on mindfulness and living in the present moment. Tolle explores the concept of ego, the nature of consciousness, and the liberation that comes from transcending the mind's incessant chatter. By embracing the power of now, Tolle suggests that individuals can find inner peace and enlightenment.",
                            withGenre: false,
                          ),
                          fontSize: 0.8,
                        ),
                        createActivity2(
                          context,
                          "personal_development/the_subtle_art",
                          "The Subtle Art of Not Giving a F*ck",
                          "by Mark Manson",
                          const BookDescriptionPage(
                            title: "The Subtle Art of Not Giving a F*ck",
                            author: "Mark Manson",
                            imageName: "covers/fuck",
                            audienceReview: "4.3",
                            genre: "",
                            time: "3.5 h",
                            description:
                                "\"The Subtle Art of Not Giving a F*ck\" by Mark Manson challenges conventional self-help tropes by advocating for a more honest and pragmatic approach to life. Manson encourages readers to prioritize what truly matters to them, let go of societal expectations, and embrace discomfort as a pathway to growth and fulfillment. Through humor and candid storytelling, he offers refreshing insights on how to live a more authentic and meaningful life.",
                            withGenre: false,
                          ),
                          fontSize: 0.9,
                        ),
                        createActivity2(
                          context,
                          "personal_development/atomic_habits",
                          "Atomic Habits",
                          "by James Clear",
                          const BookDescriptionPage(
                            title: "Atomic Habits",
                            author: "James Clear",
                            imageName: "covers/atomic",
                            audienceReview: "4.7",
                            genre: "",
                            time: "5.5 h",
                            description:
                                "\"Atomic Habits\" by James Clear provides a comprehensive framework for building and sustaining positive habits while breaking bad ones. Clear emphasizes the power of small, incremental changes—atomic habits—to create significant transformations over time. By understanding the science of habit formation and implementing practical strategies, readers can design systems for continuous improvement and achieve their goals with precision and consistency.",
                            withGenre: false,
                          ),
                        ),
                        createActivity2(
                          context,
                          "personal_development/sapiens",
                          "Sapiens: A Brief History of Humankind",
                          "by Yuval Noah Harari",
                          const BookDescriptionPage(
                            title: "Sapiens: A Brief History of Humankind",
                            author: "Yuval Noah Harari",
                            imageName: "covers/sapiens",
                            audienceReview: "4.6",
                            genre: "",
                            time: "4 h 50 m",
                            description:
                                "\"Rich Dad Poor Dad: What the Rich Teach Their Kids About Money That the Poor and Middle Class Do Not!\" by Robert T. Kiyosaki contrasts the financial philosophies of two father figures—one rich, one poor. Kiyosaki shares insights into building wealth, investing wisely, and cultivating a mindset geared towards financial independence, challenging conventional beliefs about money and success.",
                            withGenre: false,
                          ),
                          fontSize: 0.8,
                        ),
                        createActivity2(
                          context,
                          "covers/minecraft",
                          "Recursion Depth Exceeded",
                          "by Satoshi Nakamoto",
                          const BookDescriptionPage(
                            title: "The Art of Living",
                            author: "Satoshi Nakamoto",
                            imageName: "covers/minecraft",
                            audienceReview: "6",
                            genre: "",
                            time: "yet unknown",
                            description:
                            "",
                            withGenre: false,
                          ),
                          fontSize: 0.8,
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
