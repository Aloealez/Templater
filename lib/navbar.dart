import 'package:brainace_pro/activities/math_activities.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:page_transition/page_transition.dart';

class MyBottomNavigationBar extends StatefulWidget {
  const MyBottomNavigationBar({super.key});

  @override
  _MyBottomNavigationBarState createState() => _MyBottomNavigationBarState();
}

int _selectedIndex = 2;

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  late SharedPreferences prefs;

  Future<void> initSharedPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      Navigator.pop(context);
      Navigator.push(
        context,
        PageTransition(
          type: PageTransitionType.fade,
          duration: const Duration(milliseconds: 300),
          child: () {
            if (index == 0) {
              // return const Activities();
              return FutureBuilder(
                future: initSharedPrefs(),
                builder: (context, snapshot) {
                  return MathActivities();
                },
              );
            } else if (index == 1) {
              // return const Progress();
              // } else if (index == 3) {
              //   return const AnalysisScreen();
            } else if (index == 3) {
              // return const Settings();
            } else {
              // return FutureBuilder(
              //   future: initSharedPrefs(),
              //   builder: (context, snapshot) {
              //     if (snapshot.connectionState == ConnectionState.waiting) {
              //       return const CircularProgressIndicator();
              //     } else if (prefs.getString('skill') == 'sats') {
              //       return const Home();
              //     } else {
              //       return const Home();
              //     }
              //   },
              // );
            }
          }(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height / 12,
      color: Theme.of(context).colorScheme.primary,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Theme.of(context).colorScheme.secondary,
              width: 2,
            ),
          ),
        ),
        child: Theme(
          data: Theme.of(context).copyWith(
            splashFactory: NoSplash.splashFactory,
            highlightColor: Colors.transparent,
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Theme.of(context).colorScheme.surface,
            elevation: 0,
            selectedFontSize: 0,
            unselectedFontSize: 0,
            unselectedItemColor: Theme.of(context).colorScheme.secondary,
            selectedItemColor: Theme.of(context).colorScheme.onSurface,
            items: [
              buildMenuIcon(0, 'Activities'),
              buildMenuIcon(1, 'Progress'),
              buildMenuIcon(2, 'Home'),
              // buildMenuIcon(3, "Analysis"),
              buildMenuIcon(3, 'Settings'),
            ],
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            selectedIconTheme: IconThemeData(
              color: Theme.of(context).colorScheme.primaryContainer,
              size: 30,
            ),
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem buildMenuIcon(int index, String name) {
    Size size = MediaQuery.of(context).size;
    return BottomNavigationBarItem(
      icon: Padding(
        padding: EdgeInsets.only(
          top: size.height / 120,
        ),
        child: Stack(
          children: [
            ImageIcon(
              AssetImage(
                'assets/navbar_icons/${name.toLowerCase()}.png',
              ),
              // color: Theme.of(context).colorScheme.secondary,
              size: _selectedIndex == index ? 30 : 28,
              color: _selectedIndex == index
                  ? Theme.of(context).colorScheme.primaryContainer
                  : Theme.of(context).colorScheme.primary,
            ),
            SizedBox(height: 0.02 * size.height),
          ],
        ),
      ),
      label: '',
    );
  }
}
