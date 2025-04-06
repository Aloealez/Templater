import 'package:flutter/material.dart';
import '../app_bar.dart';

class SelfReflection extends StatefulWidget {
  const SelfReflection({super.key});

  @override
  State<SelfReflection> createState() => _SelfReflection();
}

class _SelfReflection extends State<SelfReflection> {
  Column buildPoint(
    BuildContext context,
    String img,
    String txt1,
    String txt2,
  ) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              height: 0.1 * size.width,
              child: Image.asset('assets/self_reflection/$img.png'),
            ),
            SizedBox(width: size.width / 25),
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 0.019 * size.height,
                    height: 1.2,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: txt1,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextSpan(
                      text: txt2,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 0.015 * size.height),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: appBar(context, ""),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(
            left: size.width / 10,
            right: size.width / 10,
            top: size.height / 30,
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
                      "SELF-REFLECTION",
                      style: TextStyle(
                        fontSize: size.width / 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Center(
                    child: Text(
                      'SHORT GUIDE',
                      style: TextStyle(fontSize: size.width / 22),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 0.04 * size.height),
                ],
              ),
              RichText(
                textAlign: TextAlign.left,
                text: TextSpan(
                  text:
                      'When you engage in self-reflection regularly, you can better understand yourself, your values, and your goals, ',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontStyle: FontStyle.italic,
                    fontSize: size.width / 25,
                    height: 1.2,
                  ),
                  children: const <TextSpan>[
                    TextSpan(
                      text:
                          'leading to personal growth and a greater sense of fulfillment.',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              SizedBox(height: size.height / 20),
              Text(
                '5 THINGS TO START WITH',
                style: TextStyle(fontSize: 0.025 * size.height),
              ),
              SizedBox(height: size.height / 50),
              Column(
                children: [
                  buildPoint(
                    context,
                    'gratitude',
                    'Gratitude',
                    ': Each day, before going to sleep, take a moment to reflect on one positive aspect of your day. Consider what steps you can take to make the following day even better.',
                  ),
                  buildPoint(
                    context,
                    'good_deed',
                    'Good Deed',
                    ': Make it a daily practice to perform a good deed.',
                  ),
                  buildPoint(
                    context,
                    'goal_setting',
                    'Goal Setting',
                    ': Upon waking up, select one goal for the day and jot it down. In the evening, review your progress to see if you achieved it.',
                  ),
                  buildPoint(
                    context,
                    'hobbies',
                    'Hobbies',
                    ': Dedicate at least 30 minutes of your day to pursuing your hobbies.',
                  ),
                  buildPoint(
                    context,
                    'digital_detox',
                    'Digital Detox',
                    ': Avoid using any digital devices for 30 minutes after waking up and 30 minutes before going to sleep.',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
