import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

class Activities extends StatefulWidget {
  const Activities({super.key});

  @override
  _Activities createState() => _Activities();
}

class _Activities extends State<Activities> {
  List<String> plan = [];
  int day = 1;
  late SharedPreferences prefs;
  String skill = "attention";

  Future<void> getPlan() async {
    prefs = await SharedPreferences.getInstance();
    List<String> newPlan = prefs.getStringList("basePlanDay$day") ?? [];
    if (newPlan.isNotEmpty) {
      setState(() {
        plan = newPlan;
      });
    }
  }

  Future<void> getSkill() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      skill = prefs.getString('skill') ?? "attention";
    });
  }

  Future<void> calcDay() async {
    prefs = await SharedPreferences.getInstance();
    String beginningDate = prefs.getString('beginning_date') ?? '';
    if (beginningDate.isNotEmpty) {
      DateTime firstDay = DateTime.parse(beginningDate);
      DateTime today = DateTime.now();
      setState(() {
        day = today.difference(firstDay).inDays + 1;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getPlan();
    getSkill();
    calcDay();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color(0xFF77528A),
        title: const Text(
          'Moje Aktywności',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Text(
                "Your Activities",
                style: TextStyle(
                  fontSize: size.width / 9,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  ActivityButton(
                    text1: "SAT Exam Prep",
                    text2: "Improve your skills!",
                    fontSize: 18.0,
                    gradientColor1: const Color(0xFF77528A),
                    gradientColor2: const Color(0xFF6F699D),
                    onTapRoute: ExampleScreen(title: "SAT Exam Prep"),
                  ),
                  const SizedBox(height: 20),
                  ActivityButton(
                    text1: "Memory Mastery",
                    text2: "Sharpen your memory!",
                    fontSize: 18.0,
                    gradientColor1: const Color(0xFF6F699D),
                    gradientColor2: const Color(0xFF5E548E),
                    onTapRoute: ExampleScreen(title: "Memory Mastery"),
                  ),
                  const SizedBox(height: 20),
                  ActivityButton(
                    text1: "Focus Training",
                    text2: "Enhance concentration",
                    fontSize: 18.0,
                    gradientColor1: const Color(0xFF524A7E),
                    gradientColor2: const Color(0xFF3D3A6B),
                    onTapRoute: ExampleScreen(title: "Focus Training"),
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
