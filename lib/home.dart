import 'dart:async';
import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:circular_chart_flutter/circular_chart_flutter.dart';
import 'package:intl/intl.dart';
import 'navbar.dart';
import 'activities_for_each_section.dart';
import 'package:flutter_quizzes/flutter_quizzes.dart';
import 'dart:math';
import 'score_n_progress/finish_screen.dart';
import '/memory/faces.dart';
import 'package:brainace_pro/notification.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _Home();
}

class _Home extends State<Home> {
  late SharedPreferences prefs;
  String skill = "";
  int trainingTime = 0;
  var rng = Random();
  List<String> plan = [];
  List<String> basePlanTicked = ["0", "0", "0", "0"];
  int day = 1;
  List<bool> wellBeingTicked = [false, false, false, false];
  int points = 0;
  int procent = 0;
  int streakDays = 0;
  bool streakInDanger = false;

  double summ = 100.0;
  double value = 40.0;
  double value2 = 60.0;
  double value3 = 00.0;
  double value32 = 50.0;

  Future<void> calcDay() async {
    DateTime firstDay = DateTime.now();
    DateTime today = DateTime.now();
    prefs = await SharedPreferences.getInstance();
    if (prefs.getString('beginning_date') != null) {
      firstDay = DateTime.parse(prefs.getString('beginning_date')!);
    }

    setState(() {
      day = today.difference(firstDay).inDays + 1;
    });
  }

  Future<void> checkAndUpdateStreak() async {
    final prefs = await SharedPreferences.getInstance();
    int currentDay = day;

    if (currentDay > 1) {
      List<String>? yesterdayPlan = prefs.getStringList("basePlanDay${currentDay - 1}");
      bool allDoneYesterday = yesterdayPlan != null &&
          yesterdayPlan.isNotEmpty &&
          yesterdayPlan.every((task) =>
          prefs.getString("${task}TickedDay${currentDay - 1}") == "1");
      if (!allDoneYesterday) {
        await prefs.setInt('streak_days', 0);
      }
    }

    bool allDoneToday = plan.isNotEmpty &&
        plan.every((task) => prefs.getString("${task}TickedDay$currentDay") == "1");

    streakInDanger = !allDoneToday;

    int currentStreak = prefs.getInt('streak_days') ?? 0;
    if (allDoneToday) {
      int lastUpdateDay = prefs.getInt('last_update_day') ?? 0;
      if (lastUpdateDay != currentDay) {
        currentStreak++;
        await prefs.setInt('streak_days', currentStreak);
        await prefs.setInt('last_update_day', currentDay);
      }
    }
    streakDays = currentStreak;
    setState(() {});
  }


  void calcValues() {
    setState(() {
      procent = int.parse((points / trainingTime * 100).toStringAsFixed(0));
      if (procent >= 200) {
        value = 100;
        value2 = 0;
        value3 = 100;
      } else {
        value = min(procent.toDouble(), 100);
        value2 = 100 - value;
        value3 = (procent > 100) ? procent % 100 : 0;
      }
      List<CircularStackEntry> data = _generateChartData();
      // key.currentState!.updateData(data);
    });
  }

  Future<void> setWellBeingTicked() async {
    prefs = await SharedPreferences.getInstance();

    List<String> newWellBeingTickedString = ["0", "0", "0", "0"];

    for (int i = 0; i < wellBeingTicked.length; i++) {
      newWellBeingTickedString[i] = (wellBeingTicked[i] ? "1" : "0");
    }
    prefs.setStringList("wellBeingTickedDay$day", newWellBeingTickedString);
  }

  Future<void> getWellBeingTicked() async {
    prefs = await SharedPreferences.getInstance();

    int newPoints = points;

    List<String> newWellBeingTickedString =
        prefs.getStringList('wellBeingTickedDay$day') ?? [];
    List<bool> newWellBeingTicked = [false, false, false, false];

    for (int i = 0; i < newWellBeingTickedString.length; i++) {
      newWellBeingTicked[i] =
      (newWellBeingTickedString[i] == "1" ? true : false);
      if (newWellBeingTicked[i]) {
        newPoints += wellbeingTimes[wellbeing[i]]!;
      }
    }
    if (newWellBeingTicked.isEmpty) {
      newWellBeingTicked = [false, false, false, false];
    }

    setState(() {
      wellBeingTicked = newWellBeingTicked;
      points = newPoints;
    });
  }

  var skillBaseList = [
    [Faces, "Faces", 10],
  ];

  Future<void> getSkill() async {
    prefs = await SharedPreferences.getInstance();
    String newSkill = prefs.getString('skill')!;
    int newTrainingTime = prefs.getInt('training_time')!;

    setState(() {
      skill = newSkill;
      trainingTime = newTrainingTime;
    });
  }

  Future<void> createPlan() async {
    prefs = await SharedPreferences.getInstance();
    List<String> newPlan = prefs.getStringList("basePlanDay$day") ?? [];
    print("poczatek newPlan: $newPlan");
    print("skill: $skill");
    if (newPlan.isNotEmpty) {
      setState(() {
        plan = newPlan;
      });
      return;
    }
    print("skillbaseLists: $skillBaseLists");
    skillBaseList = List.from(skillBaseLists[skill]!);
    print("skillBaseList: $skillBaseList");
    int currentTime = 0;

    if (skill == "sats") {
      List<String> questionSubcategoriesPointsStr = prefs
          .getStringList("scores_questionsLast") ??
          List<String>.generate(
              SatsQuestionSubcategoriesRW.typesList.length, (index) => "-1");
      List<String> questionsSubcategories =
      List.from(SatsQuestionSubcategoriesRW.typesList);
      Map<String, double> questionsSubcategoriesPoints = {
        for (int i = 0; i < questionSubcategoriesPointsStr.length; i++)
          SatsQuestionSubcategoriesRW.typesList[i]:
          double.parse(questionSubcategoriesPointsStr[i]),
      };
      questionsSubcategories.sort((a, b) {
        if (questionsSubcategoriesPoints[a]! >
            questionsSubcategoriesPoints[b]!) {
          return 1;
        } else if (questionsSubcategoriesPoints[a]! <
            questionsSubcategoriesPoints[b]!) {
          return -1;
        } else {
          return 0;
        }
      });
      int timePerRWQuestion = 5;
      for (int i = 0;
      i < questionsSubcategories.length && currentTime < trainingTime;
      i++) {
        newPlan.add(questionsSubcategories[i]);
        currentTime += timePerRWQuestion;
      }
    }

    if (skill == 'linguistic') {
      int x = rng.nextInt(4);
      if (x == 0) {
        int el = 2;
        newPlan.add(skillBaseList[el].toList()[1].toString());
        currentTime += skillBaseList[el].toList()[2] as int;
        skillBaseList.removeAt(el);
      } else if (x == 1) {
        int el = 3;
        newPlan.add(skillBaseList[el].toList()[1].toString());
        currentTime += skillBaseList[el].toList()[2] as int;
        skillBaseList.removeAt(el);
      }
    }

    while (currentTime < trainingTime) {
      int el = rng.nextInt(skillBaseList.length);
      newPlan.add(skillBaseList[el].toList()[1].toString());
      currentTime += skillBaseList[el].toList()[2] as int;
      skillBaseList.removeAt(el);
    }
    print("newPlan: $newPlan");
    prefs.setStringList("basePlanDay$day", newPlan);
    setState(() {
      plan = newPlan;
    });
  }

  Future<void> getBasePlanTicked() async {
    prefs = await SharedPreferences.getInstance();
    List<String> newBasePlanTicked = List.filled(plan.length, "0");
    int newPoints = points;

    print("plan: $plan");
    print("basePlanTicked: $basePlanTicked");

    for (int i = 0; i < plan.length; ++i) {
      print("plan[i] ${plan[i]}");
      newBasePlanTicked[i] = prefs.getString("${plan[i]}TickedDay$day") ?? "0";
      if (newBasePlanTicked[i] == "1") {
        newPoints += sectionTimes[plan[i]]!;
      }
    }
    if (basePlanTicked != newBasePlanTicked) {
      setState(() {
        basePlanTicked = newBasePlanTicked;
        points = newPoints;
        calcValues();
      });
    }
  }

  void getPoints() {
    int newPoints = points;
    for (int i = 0; i < wellBeingTicked.length; ++i) {
      if (wellBeingTicked[i]) newPoints += wellbeingTimes[wellbeing[1]]!;
    }
    setState(() {
      points = newPoints;
      calcValues();
    });
  }

  Future<void> readMemory() async {
    await calcDay();
    if (day >= 30) {
      if (mounted) {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const Finish(),
          ),
        );
      }
    }
    await getSkill();
    await getWellBeingTicked();
    await createPlan();
    await getBasePlanTicked();

    await checkAndUpdateStreak();
  }


  Future<void> updateEmoji() async {
    prefs = await SharedPreferences.getInstance();

    List<String> emojis = ["😄", "😁", "😊", "😀", "🥰", "🙂"];
    DateTime currentDate = DateTime.now();

    String? lastUpdateDateStr = prefs.getString('last_emoji_update_date');
    DateTime? lastUpdateDate =
    lastUpdateDateStr != null ? DateTime.parse(lastUpdateDateStr) : null;

    if (lastUpdateDate == null ||
        currentDate.difference(lastUpdateDate).inDays >= 1) {
      String newEmoji = emojis[rng.nextInt(emojis.length)];

      await prefs.setString('wellbeing_emoji', newEmoji);
      await prefs.setString(
          'last_emoji_update_date', currentDate.toIso8601String());

      setState(() {});
    }
  }

  Future<String> getEmoji() async {
    prefs = await SharedPreferences.getInstance();
    return prefs.getString('wellbeing_emoji') ?? "😄";
  }

  @override
  void initState() {
    print("Init state home");
    NotificationService.scheduleAllNotifications();

    WidgetsBinding.instance.addPostFrameCallback((timestamp) {
      PortHomeTasksWidgetConfig.initialize().then((value) async {
        callHomeWidgetUpdate();
      });
    });
    super.initState();
    readMemory();
    updateEmoji();
  }

  Future<void> updatePoints() async {
    prefs = await SharedPreferences.getInstance();
    prefs.setInt("pointsDay$day", points);
  }

  Widget createBaseProgram(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    int minutes = 0;
    for (int i = 0; i < plan.length; ++i) {
      minutes += sectionTimes[plan[i]]!;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Base Plan - $minutes Minutes",
          style: TextStyle(
            fontSize: size.width / 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 0.01 * size.height),
        for (int i = 0; i < plan.length; i++)
          Column(
            children: [
              InkWell(
                onTap: () {
                  print("currentplanObj ${plan[i]}");
                  if (sectionActivities[plan[i]] != null) {
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.fade,
                        child: (sectionActivities[plan[i]]!(context)),
                        reverseDuration: const Duration(milliseconds: 100),
                        opaque: false,
                      ),
                    );
                  }
                },
                child: Row(
                  children: [
                    SizedBox(
                      width: size.width / 15,
                      child: Icon(
                        (basePlanTicked[i] == "1")
                            ? Icons.circle
                            : Icons.circle_outlined,
                        size: size.width / 14.7,
                        color: const Color(0xfff66fd3),
                      ),
                    ),
                    SizedBox(width: size.width / 35),
                    Flexible(
                      child: Text(
                        "${sectionNames[plan[i]]} - ${sectionTimes[plan[i]]} min",
                        style: TextStyle(
                          fontSize: size.width / 22,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 0.01 * size.height),
            ],
          ),
      ],
    );
  }

  void callHomeWidgetUpdate() {
    List<String> widgetItems = [];
    for (int i = 0; i < plan.length; i++) {
      widgetItems.add(
          "${basePlanTicked[i] == "1" ? "◉" : "○"}:${sectionNames[plan[i]]}");
      print(
          "plan[$i] ${plan[i]} ${sectionNames[plan[i]]} ${basePlanTicked[i]}");
    }

    HomeWidget.saveWidgetData("plan_title", "To - Do List");
    HomeWidget.saveWidgetData("plan_title", "BeSmart List");
    HomeWidget.saveWidgetData("plan_tasks", widgetItems.join(','));
    HomeWidget.updateWidget(
      androidName: "TodoHomeScreenWidget",
    );

    PortHomeTasksWidgetConfig.update(
      context,
      PortHomeTasksWidget(
        plan: plan,
        basePlanTicked: basePlanTicked,
        sectionNames: sectionNames,
      ),
    );
  }

  Widget createWellBeing(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return FutureBuilder<String>(
      future: getEmoji(),
      builder: (context, snapshot) {
        String emoji = snapshot.data ?? "😄";
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Optional - Well Being $emoji",
              style: TextStyle(
                fontSize: size.width / 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 0.01 * size.height),
            for (int i = 0; i < wellbeing.length; i++)
              InkWell(
                onTap: () {
                  setState(() {
                    wellBeingTicked[i] = !wellBeingTicked[i];
                    if (wellBeingTicked[i]) {
                      points += wellbeingTimes[wellbeing[i]]!;
                    } else {
                      points -= wellbeingTimes[wellbeing[i]]!;
                    }
                    calcValues();
                  });
                  setWellBeingTicked();
                  updatePoints();
                },
                child: Column(
                  children: [
                    SizedBox(
                      height: size.width / 15,
                      child: Row(
                        children: [
                          SizedBox(
                            width: size.width / 12,
                            child: Icon(
                              wellBeingTicked[i]
                                  ? Icons.circle
                                  : Icons.circle_outlined,
                              size: size.width / 15,
                              color: const Color(0xff51ceda),
                            ),
                          ),
                          SizedBox(width: size.width / 40),
                          Flexible(
                            child: Text(
                              wellbeing[i],
                              style: TextStyle(
                                fontSize: size.width / 22,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 0.01 * size.height),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }

  List<CircularStackEntry> _generateChartData() {
    Color? dialColor = Theme.of(context).colorScheme.secondary;
    Color? dialColor2 =
    Theme.of(context).colorScheme.secondary.withOpacity(0.2);
    Color? dialColor3 = (Theme.of(context).brightness == Brightness.light)
        ? const Color.fromARGB(255, 255, 136, 255)
        : const Color.fromARGB(255, 211, 54, 198);

    List<CircularStackEntry> data = <CircularStackEntry>[
      CircularStackEntry(
        <CircularSegmentEntry>[
          CircularSegmentEntry(
            value3,
            dialColor3,
            rankKey: 'percentage3',
          ),
          CircularSegmentEntry(
            value,
            dialColor,
            rankKey: 'percentage1',
          ),
          CircularSegmentEntry(
            value2,
            dialColor2,
            rankKey: 'percentage4',
          ),
        ],
        rankKey: 'percentage4',
      ),
    ];
    return data;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    updatePoints();

    DateTime now = DateTime.now();
    var formatter = DateFormat('E. dd MMM');
    String formattedDate = formatter.format(now);

    return Scaffold(
      body: RawScrollbar(
        thumbColor: Theme.of(context).colorScheme.primary,
        radius: const Radius.circular(40),
        thickness: 5,
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(
              left: size.width / 10,
              right: size.width / 10,
              top: size.height / 10,
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
                        "Your Plan",
                        style: TextStyle(
                          fontSize: size.width / 6,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 0 * size.height),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Day $day - ${formattedDate.toString()}",
                            style: TextStyle(
                              fontSize: size.width / 22,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'OpenSauceTwo',
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(width: 0.03 * size.width),
                          Container(
                            padding: EdgeInsets.only(
                              left: size.width / 30,
                              right: size.width / 30,
                              top: size.height / 200,
                              bottom: size.height / 200,
                            ),
                            decoration: BoxDecoration(
                              color: streakInDanger
                                  ? const Color(0xff6a0d0a)
                                  : const Color(0xff06523f),
                              borderRadius: BorderRadius.circular(24.0),
                            ),
                            child: Text(
                              "$streakDays ${streakDays == 1 ? "Day" : "Days"}",
                              style: TextStyle(
                                fontSize: size.width / 22,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 0.05 * size.height),
                createBaseProgram(context),
                SizedBox(height: 0.04 * size.height),
                createWellBeing(context),
                SizedBox(height: 0.069 * size.height),
              ],
            ),
          ) ,
        ),
      ),
      bottomNavigationBar: const MyBottomNavigationBar(),
    );
  }
}