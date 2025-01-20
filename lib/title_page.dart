import 'package:brainace_pro/settings/tos.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'buttons.dart';
import 'home.dart';
import 'dart:math';

class TitlePage extends StatefulWidget {
  const TitlePage({super.key, required this.title});

  final String title;

  @override
  State<TitlePage> createState() => _TitlePageState();
}

class _TitlePageState extends State<TitlePage>
    with SingleTickerProviderStateMixin {
  late SharedPreferences prefs;
  bool firstTime = false;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    );
    // )..repeat(reverse: false);
    _animation = Tween<double>(begin: 0.0, end: 2.0).animate(_controller);

    initData();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> initData() async {
    prefs = await SharedPreferences.getInstance();
    var plan = prefs.getStringList('basePlanDay1');
    setState(() {
      if (plan == null) {
        firstTime = true;
      }
    });
  }

  Future<void> initSharedPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    _controller.forward(from: 0.0);

    return Scaffold(
      body: Center(
        child: Container(
          margin: EdgeInsets.only(
            left: size.width / 10,
            right: size.width / 10,
          ),
          child: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment(0, -0.79),
                child: Text(
                  "BrainAce.pro",
                  style: TextStyle(
                    fontSize: size.width / 10,
                    fontWeight: FontWeight.w500,
                    height: 1,
                    color: Theme.of(context).colorScheme.primaryContainer,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Align(
                alignment: Alignment(0, -0.64),
                child: Text(
                  "Train Your Brain With AI",
                  style: TextStyle(fontSize: size.width / 16),
                ),
              ),
              Align(
                alignment: Alignment(0, 0.13),
                child: Container(
                  margin: EdgeInsets.all(size.width / 14.0),
                  child: AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return ShaderMask(
                        shaderCallback: (rect) {
                          return LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            stops: [
                              max(_animation.value - 1, 0),
                              min(_animation.value, 1),
                            ],
                            colors: [Color(0xFFFB2EBA),
                              Theme.of(context).colorScheme.secondary,
                            ],
                          ).createShader(rect); //Color(0xFFFB2EBA) is the pink color of the brain  //Theme.of(context).colorScheme.secondary is the secondary color of the app
                        },
                        blendMode: BlendMode.modulate,
                        child: Image.asset('assets/brain.png'),
                      );
                    },
                  ),
                ),
              ),
              Align(
                alignment: Alignment(0, 0.81),
                child: SizedBox(
                  height: size.height * 0.06,
                  width: size.width * 0.72,
                  child: firstTime
                      ? StartButton(
                    text: "Choose A Program",
                    width: size.width,
                    tooltip: 'Smart Decision!',
                  )
                      : RedirectButton(
                    route: FutureBuilder(
                      future: initSharedPrefs(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (prefs.getString('skill') == 'sats') {
                          return const Home();
                        } else {
                          return const Home();
                        }
                      },
                    ),
                    text: 'Continue',
                    width: size.width,
                  ),
                ),
              ),
              Align(
                alignment: Alignment(0, 0.93),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: Theme.of(context).textTheme.bodyMedium,

                    children: <TextSpan>[
                      TextSpan(
                        text: "By using our App, you agree to our\n",
                        style: TextStyle(
                          fontSize: 0.015 * size.height,
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.4),
                        ),
                      ),
                      TextSpan(
                        text: "Terms of Service",
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontSize: 0.015 * size.height,
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.4),
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const TermsOfService(),
                              ),
                            );
                          },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}