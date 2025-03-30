import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const Activities(),
    );
  }
}

class Activities extends StatelessWidget {
  const Activities({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Welcome Title
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
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            // Subtitle
            Text(
              "Prepare for your SAT exam\nthe smart way!",
              style: TextStyle(
                fontSize: size.width / 22,
                color: Colors.white70,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            // Buttons
            ActivityButton(
              text1: "SAT Exam Prep",
              text2: "",
              fontSize: 18,
              gradientColor1: const Color(0xFF77528A),
              gradientColor2: const Color(0xFF6F699D),
              onTapRoute: const ExampleScreen(title: "SAT Exam Prep"),
            ),
            const SizedBox(height: 20),
            ActivityButton(
              text1: "Memory Mastery",
              text2: "",
              fontSize: 18,
              gradientColor1: const Color(0xFF6F699D),
              gradientColor2: const Color(0xFF5E548E),
              onTapRoute: const ExampleScreen(title: "Memory Mastery"),
            ),
            const SizedBox(height: 20),
            ActivityButton(
              text1: "Focus Training",
              text2: "",
              fontSize: 18,
              gradientColor1: const Color(0xFF524A7E),
              gradientColor2: const Color(0xFF3D3A6B),
              onTapRoute: const ExampleScreen(title: "Focus Training"),
            ),
          ],
        ),
      ),
    );
  }
}

class ActivityButton extends StatelessWidget {
  final String text1;
  final String text2;
  final double fontSize;
  final Widget? onTapRoute;
  final Color gradientColor1;
  final Color gradientColor2;

  const ActivityButton({
    required this.text1,
    required this.text2,
    required this.fontSize,
    this.onTapRoute,
    this.gradientColor1 = const Color(0xFF77528A),
    this.gradientColor2 = const Color(0xFF6F699D),
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onTapRoute != null) {
          Navigator.push(
            context,
            PageTransition(
              type: PageTransitionType.fade,
              child: onTapRoute!,
              reverseDuration: const Duration(milliseconds: 100),
            ),
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          gradient: LinearGradient(
            colors: [gradientColor1, gradientColor2],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(4, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text1,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (text2.isNotEmpty)
              Text(
                text2,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: fontSize * 0.9,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// Example Screen for Navigating
class ExampleScreen extends StatelessWidget {
  final String title;

  const ExampleScreen({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color(0xFF77528A),
        title: Text(
          title,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: Text(
          "Welcome to $title!",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}

