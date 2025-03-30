import 'package:flutter/material.dart';
import 'package:icon_decoration/icon_decoration.dart';
import 'package:page_transition/page_transition.dart';
import 'dart:math' as dart_math;

// Słownik dla aktywności w każdej sekcji
final Map<String, Widget Function(BuildContext)> sectionActivities = {
  "SAT Exam Prep": (context) => const ExampleScreen(title: "SAT Exam Prep"),
  "Memory Mastery": (context) => const ExampleScreen(title: "Memory Mastery"),
  "Focus Training": (context) => const ExampleScreen(title: "Focus Training"),
};

// Punkt wejściowy
void main() {
  runApp(const MyApp());
}

// Główna aplikacja
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const ActivitiesScreen(),
      theme: ThemeData(
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color(0xFF77528A),
          secondary: const Color(0xFF6F699D),
          onPrimary: Colors.white,
          shadow: Colors.black.withOpacity(0.5),
        ),
      ),
    );
  }
}

// Ekran główny z przyciskami aktywności
class ActivitiesScreen extends StatelessWidget {
  const ActivitiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Nagłówek gradientowy
            Text(
              "Welcome",
              style: TextStyle(
                fontSize: size.width / 8,
                fontWeight: FontWeight.bold,
                foreground: Paint()
                  ..shader = const LinearGradient(
                    colors: [
                      Color(0xFF77528A),
                      Color(0xFF6F699D),
                    ],
                  ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
              ),
            ),
            const SizedBox(height: 10),
            // Podtytuł
            Text(
              "Choose your activity\nand improve your skills!",
              style: TextStyle(
                fontSize: size.width / 24,
                color: Colors.white70,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            // Lista przycisków
            ActivityButton(
              context,
              img: "placeholder",
              text1: "SAT Exam Prep",
              text2: "Boost your score!",
              fontSize: 16,
              exerciseName: "SAT Exam Prep",
              leftColorGradient: const Color(0xFF77528A),
              rightColorGradient: const Color(0xFF6F699D),
              star: true,
              plan: ["SAT Exam Prep"],
            ),
            ActivityButton(
              context,
              img: "placeholder_dark",
              text1: "Memory Mastery",
              text2: "Train your brain",
              fontSize: 16,
              exerciseName: "Memory Mastery",
              leftColorGradient: const Color(0xFF6F699D),
              rightColorGradient: const Color(0xFF5E548E),
            ),
            ActivityButton(
              context,
              img: "placeholder",
              text1: "Focus Training",
              text2: "Stay sharp",
              fontSize: 16,
              exerciseName: "Focus Training",
              leftColorGradient: const Color(0xFF524A7E),
              rightColorGradient: const Color(0xFF3D3A6B),
              blocked: true,
            ),
          ],
        ),
      ),
    );
  }
}

// Komponent ActivityButton
class ActivityButton extends StatelessWidget {
  final String img;
  final String text1;
  final String text2;
  final double fontSize;
  final Widget? onTapRoute;
  final Color? leftColorGradient;
  final Color? rightColorGradient;
  final double zero;
  final bool blocked;
  final double textWidth;
  final bool title;
  final bool star;
  final bool forceStar;
  final String exerciseName;
  final String skill;
  final List<String> plan;

  ActivityButton(
    BuildContext context, {
    required this.img,
    required this.text1,
    required this.text2,
    required this.fontSize,
    this.onTapRoute,
    this.leftColorGradient,
    this.rightColorGradient,
    this.zero = 1,
    this.blocked = false,
    this.textWidth = 0.45,
    this.title = false,
    this.star = false,
    this.forceStar = false,
    this.exerciseName = "",
    this.skill = "",
    this.plan = const [],
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Color color1 = leftColorGradient ?? Theme.of(context).colorScheme.primary;
    Color color2 = rightColorGradient ?? Theme.of(context).colorScheme.secondary;

    Size size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: blocked
          ? null
          : () {
              if (sectionActivities[exerciseName] != null) {
                Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.fade,
                    child: sectionActivities[exerciseName]!(context),
                    reverseDuration: const Duration(milliseconds: 100),
                    opaque: false,
                  ),
                );
              }
            },
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[
                  color1,
                  color2,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.shadow,
                  spreadRadius: 4,
                  blurRadius: 6,
                  offset: const Offset(3, 3),
                ),
              ],
            ),
            height: 0.115 * size.height,
            child: Stack(
              children: [
                if ((star && plan.contains(exerciseName)) || forceStar)
                  Align(
                    alignment: const Alignment(0.98, -0.85),
                    child: Transform.rotate(
                      angle: dart_math.pi / 0.07,
                      child: DecoratedIcon(
                        icon: Icon(
                          Icons.star,
                          color: const Color.fromARGB(255, 255, 208, 0),
                          size: 0.05 * size.height,
                        ),
                        decoration: const IconDecoration(border: IconBorder()),
                      ),
                    ),
                  ),
                Align(
                  alignment: Alignment.center,
                  child: Row(
                    children: [
                      SizedBox(
                        height: 0.115 * size.height,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: FadeInImage(
                            placeholder: AssetImage('assets/$img.png'),
                            image: AssetImage('assets/$img.png'),
                            fit: BoxFit.cover,
                            fadeInDuration: const Duration(milliseconds: 200),
                          ),
                        ),
                      ),
                      SizedBox(width: 0.025 * size.width),
                      SizedBox(
                        width: size.width * textWidth,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              text1,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontSize: fontSize,
                                fontWeight: FontWeight.bold,
                                height: 1.2,
                              ),
                            ),
                            if (text2.isNotEmpty)
                              Text(
                                text2,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.onPrimary,
                                  fontSize: zero * fontSize,
                                  fontWeight: FontWeight.bold,
                                  height: 1.2,
                                ),
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
          SizedBox(height: 0.025 * size.height),
        ],
      ),
    );
  }
}

// Przykładowy ekran
class ExampleScreen extends StatelessWidget {
  final String title;

  const ExampleScreen({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(title),
        backgroundColor: const Color(0xFF77528A),
      ),
      body: Center(
        child: Text(
          "Welcome to $title!",
          style: const TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
    );
  }
}
