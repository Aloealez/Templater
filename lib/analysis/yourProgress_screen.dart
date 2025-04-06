import 'package:flutter/material.dart';
import 'package:brainace_pro/app_bar.dart';

class Progress extends StatefulWidget {
  const Progress({super.key});

  @override
  _ProgressState createState() => _ProgressState();
}

class _ProgressState extends State<Progress> {
  int selectedIndex = 1;

  void toggleContainer(int index) {
    setState(() {
      selectedIndex = selectedIndex == index ? -1 : index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, "Your Progress"),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildAnimatedContainer(0, "Mathematics"),
            const SizedBox(height: 20),
            buildAnimatedContainer(1, "Reading & Writing"),
          ],
        ),
      ),
    );
  }

  Widget buildAnimatedContainer(int index, String title) {
    bool isOpen = selectedIndex == index;

    return GestureDetector(
      onTap: () => toggleContainer(index),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 400),
        curve: Curves.easeInOut,
        width: 300, // Expands width when clicked
        height: isOpen ? 290 : 60, // Expands height when clicked
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6A0DAD), Color(0xFF8A2BE2)], // Purple gradient
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: ClipRRect(
          // Prevents overflow
          borderRadius: BorderRadius.circular(20),
          child: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (isOpen) ...[
                    const SizedBox(height: 12),
                    buildProgressBar("Algebra", 54),
                    buildProgressBar("Advanced Math", 72),
                    buildProgressBar("Geometry & Trigonometry", 41),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildProgressBar(String title, int percentage) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: Colors.white, fontSize: 16)),
          const SizedBox(height: 6),
          Stack(
            children: [
              AnimatedContainer(
                duration: Duration(milliseconds: 400),
                height: 20,
                width: 280 * (percentage / 100),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
          Text("$percentage% Correct",
              style: TextStyle(color: Colors.white70, fontSize: 12),),
        ],
      ),
    );
  }
}
