import 'package:flutter/material.dart';
import 'package:brainace_pro/app_bar.dart';

// add SharedPrefrence
// add labels of greate catogary on line No => (note: These are the Mathematics one [85, 86, 87])
// add labels of greate catogary on line No => (note: These are the R&W one [147, 148, 149])
// now add the correct percentage of the above labels which is besides the label in those lines
// now lets move to Weak catogary
// add labels of greate catogary on line No => (note: These are the Mathematics one [310, 311, 312])
// add labels of greate catogary on line No => (note: These are the R&W one [373, 374, 149])
// now add the correct percentage of the above labels which is besides the label in those lines

class CombinedProgress extends StatelessWidget {
  final bool Progress;
  final bool Weak;

  const CombinedProgress({
    super.key,
    required this.Progress,
    required this.Weak,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Progress
            ? const ProgressWidget()
            : Weak
                ? const WeakWidget()
                : const Text('No data selected'),
      ),
    );
  }
}

class ProgressWidget extends StatefulWidget {
  const ProgressWidget({super.key});

  @override
  _ProgressState createState() => _ProgressState();
}

class WeakWidget extends StatefulWidget {
  const WeakWidget({super.key});

  @override
  _WeakState createState() => _WeakState();
}

class _ProgressState extends State<ProgressWidget> {
  int selectedIndex = 0;

  void toggleContainer(int index) {
    setState(() {
      selectedIndex = selectedIndex == index ? -1 : index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, 'Your Progress'),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildAnimatedContainer(0, 'Mathematics'),
            const SizedBox(height: 20),
            buildAnimatedContainer2(1, 'Reading & Writing'),
          ],
        ),
      ),
    );
  }

  Widget buildAnimatedContainer(int index, String title) {
    bool isOpen = selectedIndex == index;

    return GestureDetector(
      onTap: () => toggleContainer(0),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 400),
        curve: Curves.easeInOut,
        width: 300,
        height: isOpen ? 280 : 60,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(20),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(
                          color: Colors.white,
                          width: 2,
                        ),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (isOpen) ...[
                          const SizedBox(height: 12),
                          buildProgressBar('Algebra', 54),
                          buildProgressBar('Advanced Math', 72),
                          buildProgressBar('Geometry &\nTrigonometry', 100),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildAnimatedContainer2(int index, String title) {
    bool isOpen = selectedIndex == index;

    return GestureDetector(
      onTap: () => toggleContainer(1),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 400),
        curve: Curves.easeInOut,
        width: 300,
        height: isOpen ? 290 : 60,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(20),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(
                          color: Colors.white,
                          width: 2,
                        ),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (isOpen) ...[
                          const SizedBox(height: 12),
                          buildProgressBar('Reading', 54),
                          buildProgressBar('Summary', 72),
                          buildProgressBar('Geometry &\nTrigonometry', 100),
                        ],
                      ],
                    ),
                  ),
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
          Container(
            margin: EdgeInsets.only(left: 8),
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'openSans',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              AnimatedContainer(
                duration: Duration(milliseconds: 400),
                height: 20,
                width: 170 * (percentage / 100),
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 10),
              Text(
                '$percentage% Correct',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _WeakState extends State<WeakWidget> {
  int selectedIndex = 3;

  void toggleContainer(int index) {
    setState(() {
      selectedIndex = selectedIndex == index ? -1 : index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, 'Your Progress'),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildAnimatedContainer(3, 'Mathematics'),
            const SizedBox(height: 20),
            buildAnimatedContainer2(4, 'Reading & Writing'),
          ],
        ),
      ),
    );
  }

  Widget buildAnimatedContainer(int index, String title) {
    bool isOpen = selectedIndex == index;

    return GestureDetector(
      onTap: () => toggleContainer(3),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 400),
        curve: Curves.easeInOut,
        width: 300,
        height: isOpen ? 280 : 60,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(20),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(
                          color: Colors.white,
                          width: 2,
                        ),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (isOpen) ...[
                          const SizedBox(height: 12),
                          buildProgressBar('Algebra', 54),
                          buildProgressBar('Advanced Math', 72),
                          buildProgressBar('Geometry &\nTrigonometry', 100),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildAnimatedContainer2(int index, String title) {
    bool isOpen = selectedIndex == index;

    return GestureDetector(
      onTap: () => toggleContainer(4),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 400),
        curve: Curves.easeInOut,
        width: 300,
        height: isOpen ? 290 : 60,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(20),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(
                          color: Colors.white,
                          width: 2,
                        ),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (isOpen) ...[
                          const SizedBox(height: 12),
                          buildProgressBar('Reading', 54),
                          buildProgressBar('Summary', 72),
                          buildProgressBar('Geometry &\nTrigonometry', 100),
                        ],
                      ],
                    ),
                  ),
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
          Container(
            margin: EdgeInsets.only(left: 8),
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'openSans',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              AnimatedContainer(
                duration: Duration(milliseconds: 400),
                height: 20,
                width: 170 * (percentage / 100),
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 10),
              Text(
                '$percentage% Correct',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
