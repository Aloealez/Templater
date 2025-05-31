import 'dart:async';

import './widgets/port_home_tasks_widget.dart';
import 'widgets/port_home_tasks_widget_config.dart';
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
import '/memory/faces.dart';
import 'package:brainace_pro/notification.dart';
import 'main.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _Home();
}

class _Home extends State<Home> with RouteAware {
  SharedPreferences? prefs;
  String skill = '';
  String skillSats = '';
  int trainingTime = 0;
  var rng = Random();
  List<String> plan = [];
  List<String> basePlanTicked = ['0', '0', '0', '0'];
  int day = 1;
  List<bool> wellBeingTicked = [false, false, false, false];
  int points = 0;
  int procent = 0;
  int streakDays = 0;
  bool streakInDanger = false;
  double auria = 0.0;

  double summ = 100.0;
  double value = 40.0;
  double value2 = 60.0;
  double value3 = 0.0;
  double value32 = 50.0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    super.didPopNext();

    NotificationService.scheduleAllNotifications();

    // Update any widget tasks
    WidgetsBinding.instance.addPostFrameCallback((timestamp) {
      PortHomeTasksWidgetConfig.initialize().then((value) {
        callHomeWidgetUpdate();
      });
    });

    readMemory();
    updateEmoji();
    updatePoints();
  }

  Future<void> calcDay() async {
    DateTime firstDay = DateTime.now();
    DateTime today = DateTime.now();
    prefs ??= await SharedPreferences.getInstance();
    auria = prefs?.getDouble('auria') ?? 0.0;
    if (prefs == null) {
      throw Exception('Failed to initialize SharedPreferences');
    }
    if (prefs?.getString('beginning_date') != null) {
      firstDay = DateTime.parse(prefs!.getString('beginning_date')!);
    }

    setState(() {
      // how many days have passed since the first day
      day = today.difference(firstDay).inDays + 1;
    });
  }

  Future<void> checkAndUpdateStreak() async {
    int currentDay = day; // Use the 'day' variable or calculate currentDay
    int lastUpdateDay = prefs?.getInt('last_update_day') ?? 0;
    int currentStreak = prefs?.getInt('streak_days') ?? 0;

    bool allDoneToday = plan.isNotEmpty &&
        plan.every(
          (task) => prefs?.getString('${task}TickedDay$currentDay') == '1',
        );

    setState(() {
      streakInDanger = !allDoneToday;
    });

    if (currentDay > 1) {
      List<String>? yesterdayPlan =
          prefs?.getStringList('basePlanDay${currentDay - 1}');
      bool allDoneYesterday = yesterdayPlan != null &&
          yesterdayPlan.isNotEmpty &&
          yesterdayPlan.every(
            (task) =>
                prefs?.getString('${task}TickedDay${currentDay - 1}') == '1',
          );

      if (!allDoneYesterday && !allDoneToday) {
      } else if (!allDoneYesterday && allDoneToday) {
        if (lastUpdateDay != currentDay) {
          await prefs?.setInt('last_update_day', currentDay);
        }
      } else if (allDoneYesterday) {
        if (allDoneToday && lastUpdateDay != currentDay) {
          currentStreak++;
          await prefs?.setInt('streak_days', currentStreak);
          await prefs?.setInt('last_update_day', currentDay);
        }
      }
    } else if (currentDay == 1 && allDoneToday) {
      if (lastUpdateDay != currentDay) {
        currentStreak = 1;
        await prefs?.setInt('streak_days', currentStreak);
        await prefs?.setInt('last_update_day', currentDay);
      }
    }

    setState(() {
      streakDays = currentStreak;
    });
  }

  void calcValues() {
    setState(() {
      procent = trainingTime == 0
          ? 0
          : int.parse((points / trainingTime * 100).toStringAsFixed(0));
      if (procent >= 200) {
        value = 100;
        value2 = 0;
        value3 = 100;
      } else {
        value = procent.toDouble().clamp(0, 100);
        value2 = 100 - value;
        value3 = (procent > 100) ? procent % 100 : 0;
      }
    });
  }

  Future<void> setWellBeingTicked() async {
    prefs = await SharedPreferences.getInstance();

    List<String> newWellBeingTickedString = ['0', '0', '0', '0'];

    for (int i = 0; i < wellBeingTicked.length; i++) {
      newWellBeingTickedString[i] = (wellBeingTicked[i] ? '1' : '0');
    }
    prefs?.setStringList('wellBeingTickedDay$day', newWellBeingTickedString);
  }

  var skillBaseList = [
    [Faces, 'Faces', 10],
  ];

  Future<void> getSkill() async {
    prefs = await SharedPreferences.getInstance();
    String newSkill = prefs?.getString('skill') ?? '';
    String newSkillSats = prefs?.getString('skill_sats') ?? '';
    int newTrainingTime = prefs?.getInt('training_time') ?? 0;

    setState(() {
      skill = newSkill;
      skillSats = newSkillSats;
      trainingTime = newTrainingTime;
    });
  }

  Future<void> createPlan() async {
    prefs = await SharedPreferences.getInstance();
    List<String> newPlan = prefs?.getStringList('basePlanDay$day') ?? [];

    // If we've already stored the plan for today, just use it
    if (newPlan.isNotEmpty) {
      setState(() {
        plan = newPlan;
      });
      return;
    }

    // Otherwise, generate a new plan
    int currentTime = 0;
    skillBaseList = List.from(skillBaseLists[skill]!);

    // Example for "sats" skill
    if (skill == 'sats') {
      List<String> questionSubcategoriesPointsStr =
          prefs?.getStringList('scores_questionsLast') ??
              List<String>.generate(
                SatsQuestionSubcategories.typesList.length,
                (index) => '-1',
              );
      List<String> questionsSubcategories;
      questionsSubcategories = List.from(SatsQuestionSubcategories.typesList);
      Map<String, double> questionsSubcategoriesPoints = {
        for (int i = 0; i < questionSubcategoriesPointsStr.length; i++)
          SatsQuestionSubcategories.typesList[i]:
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

      int timePerSatQuestion = 5;
      if (skillSats == 'both') {
        int currentMathTime = 0;
        int currentRWTime = 0;
        for (int i = 0;
            i < questionsSubcategories.length && currentTime < trainingTime;
            i++) {
          if (SatsQuestionSubcategories.typesList
              .sublist(10)
              .contains(questionsSubcategories[i])) {
            if (currentMathTime < trainingTime / 2) {
              newPlan.add(questionsSubcategories[i]);
              currentTime += timePerSatQuestion;
              currentMathTime += timePerSatQuestion;
            }
          } else if (SatsQuestionSubcategories.typesList
              .sublist(0, 10)
              .contains(questionsSubcategories[i])) {
            if (currentRWTime < trainingTime / 2) {
              newPlan.add(questionsSubcategories[i]);
              currentTime += timePerSatQuestion;
              currentRWTime += timePerSatQuestion;
            }
          }
        }
      } else {
        for (int i = 0;
            i < questionsSubcategories.length && currentTime < trainingTime;
            i++) {
          if (skillSats == 'math' &&
              SatsQuestionSubcategories.typesList
                  .sublist(10)
                  .contains(questionsSubcategories[i])) {
            newPlan.add(questionsSubcategories[i]);
            currentTime += timePerSatQuestion;
          } else if (skillSats == 'rw' &&
              SatsQuestionSubcategories.typesList
                  .sublist(0, 10)
                  .contains(questionsSubcategories[i])) {
            newPlan.add(questionsSubcategories[i]);
            currentTime += timePerSatQuestion;
          }
        }
      }
    }

    // Example for "linguistic" skill
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

    // Fill up the rest of the training time with random tasks from skillBaseList
    while (currentTime < trainingTime && skillBaseList.isNotEmpty) {
      int el = rng.nextInt(skillBaseList.length);
      newPlan.add(skillBaseList[el].toList()[1].toString());
      currentTime += skillBaseList[el].toList()[2] as int;
      skillBaseList.removeAt(el);
    }

    prefs?.setStringList('basePlanDay$day', newPlan);
    setState(() {
      plan = newPlan;
    });
  }

  Future<void> getBasePlanTicked() async {
    prefs = await SharedPreferences.getInstance();
    List<String> newBasePlanTicked = List.filled(plan.length, '0');
    int newPoints = 0;

    for (int i = 0; i < plan.length; ++i) {
      newBasePlanTicked[i] = prefs?.getString('${plan[i]}TickedDay$day') ?? '0';
      if (newBasePlanTicked[i] == '1') {
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
      if (wellBeingTicked[i]) newPoints += wellbeingTimes[wellbeing[i]]!;
    }
    setState(() {
      points = newPoints;
      calcValues();
    });
  }

  Future<void> readMemory() async {
    await calcDay();

    // If day < 30, continue the normal plan logic
    await getSkill();
    await createPlan();
    await getBasePlanTicked();

    await checkAndUpdateStreak();
  }

  Future<void> updateEmoji() async {
    prefs = await SharedPreferences.getInstance();

    List<String> emojis = ['😄', '😁', '😊', '😀', '🥰', '🙂'];
    DateTime currentDate = DateTime.now();

    String? lastUpdateDateStr = prefs?.getString('last_emoji_update_date');
    DateTime? lastUpdateDate =
        lastUpdateDateStr != null ? DateTime.parse(lastUpdateDateStr) : null;

    if (lastUpdateDate == null ||
        currentDate.difference(lastUpdateDate).inDays >= 1) {
      String newEmoji = emojis[rng.nextInt(emojis.length)];

      await prefs?.setString('wellbeing_emoji', newEmoji);
      await prefs?.setString(
        'last_emoji_update_date',
        currentDate.toIso8601String(),
      );

      setState(() {});
    }
  }

  Future<String> getEmoji() async {
    prefs = await SharedPreferences.getInstance();
    return prefs?.getString('wellbeing_emoji') ?? '😄';
  }

  @override
  void initState() {
    NotificationService.scheduleAllNotifications();

    // Update any widget tasks
    WidgetsBinding.instance.addPostFrameCallback((timestamp) {
      PortHomeTasksWidgetConfig.initialize().then((value) {
        callHomeWidgetUpdate();
      });
    });

    super.initState();
    readMemory();
    updateEmoji();
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  Future<void> updatePoints() async {
    calcValues();
    prefs = await SharedPreferences.getInstance();
    prefs?.setInt('pointsDay$day', points);
  }

  Widget createBaseProgram(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    int minutes = 0;
    for (int i = 0; i < plan.length; ++i) {
      if ((skillSats == 'both' &&
              SatsQuestionSubcategories.typesList
                  .sublist(0, 10)
                  .contains(plan[i])) ||
          skillSats != 'both') {
        minutes += sectionTimes[plan[i]]!;
      }
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        () {
          return Column(
            children: [
              for (int i = 0; i < plan.length; i++)
                if ((skillSats == 'both' &&
                        SatsQuestionSubcategories.typesList
                            .sublist(0, 10)
                            .contains(plan[i])) ||
                    skillSats != 'both')
                  Column(
                    children: [
                      InkWell(
                        onTap: () {
                          if (sectionActivities[plan[i]] != null) {
                            Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.fade,
                                child: (sectionActivities[plan[i]]!(context)),
                                reverseDuration:
                                    const Duration(milliseconds: 100),
                                opaque: false,
                              ),
                            );
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: size.width / 50,
                            horizontal: size.width / 200,
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xff240b2b),
                            border: Border.all(color: Color(0xff2d1f38)),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                width: size.width / 10,
                                child: Icon(
                                  (basePlanTicked[i] == '1')
                                      ? Icons.square_rounded
                                      : Icons.crop_square_outlined,
                                  size: size.width / 14.7,
                                  color: const Color(0xff653378),
                                ),
                              ),
                              SizedBox(width: size.width / 35),
                              Flexible(
                                child: Text(
                                  '${sectionNames[plan[i]]}',
                                  style: TextStyle(
                                    decoration: (basePlanTicked[i] == '1')
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none,
                                    color: (basePlanTicked[i] == '1')
                                        ? Colors.grey
                                        : Colors.white,
                                    fontSize: size.width / 22,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 0.01 * size.height),
                    ],
                  ),
            ],
          );
        }(),
      ],
    );
  }

  void callHomeWidgetUpdate() {
    List<String> widgetItems = [];
    for (int i = 0; i < plan.length; i++) {
      widgetItems.add(
        "${basePlanTicked[i] == "1" ? "◉" : "○"}:${sectionNames[plan[i]]}",
      );
    }

    HomeWidget.saveWidgetData('plan_title', 'BeSmart List');
    HomeWidget.saveWidgetData('plan_tasks', widgetItems.join(','));
    HomeWidget.updateWidget(
      androidName: 'TodoHomeScreenWidget',
    );

    // For larger devices
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
    int minutes = 0;
    for (int i = 0; i < plan.length; ++i) {
      if (skillSats == 'both' &&
          SatsQuestionSubcategories.typesList.sublist(10).contains(plan[i])) {
        minutes += sectionTimes[plan[i]]!;
      }
    }
    return FutureBuilder<String>(
      future: getEmoji(),
      builder: (context, snapshot) {
        String emoji = snapshot.data ?? '😄';
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            () {
              if (skillSats == 'both') {
                return Column(
                  children: [
                    for (int i = 0; i < plan.length; i++)
                      if (skillSats == 'both' &&
                          SatsQuestionSubcategories.typesList
                              .sublist(10)
                              .contains(plan[i]))
                        InkWell(
                          onTap: () {
                            if (sectionActivities[plan[i]] != null) {
                              Navigator.push(
                                context,
                                PageTransition(
                                  type: PageTransitionType.fade,
                                  child: (sectionActivities[plan[i]]!(context)),
                                  reverseDuration:
                                      const Duration(milliseconds: 100),
                                  opaque: false,
                                ),
                              );
                            }
                          },
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: size.width / 50,
                                  horizontal: size.width / 200,
                                ),
                                decoration: BoxDecoration(
                                  color: Color(0xff0b162a),
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(color: Color(0xff1a202e)),
                                ),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: size.width / 10,
                                      child: Icon(
                                        (basePlanTicked[i] == '1')
                                            ? Icons.square_rounded
                                            : Icons.crop_square_rounded,
                                        size: size.width / 14.7,
                                        color: const Color(0xff364377),
                                      ),
                                    ),
                                    SizedBox(width: size.width / 40),
                                    Flexible(
                                      child: Text(
                                        '${sectionNames[plan[i]]}',
                                        style: TextStyle(
                                          decoration: (basePlanTicked[i] == '1')
                                              ? TextDecoration.lineThrough
                                              : TextDecoration.none,
                                          color: (basePlanTicked[i] == '1')
                                              ? Colors.grey
                                              : Colors.white,
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
              } else {
                return Container();
              }
            }(),
          ],
        );
      },
    );
  }

  List<CircularStackEntry> _generateChartData() {
    Color? dialColor = Theme.of(context).colorScheme.secondary;
    Color? dialColor2 = dialColor.withOpacity(0.2);
    Color? dialColor3 = (Theme.of(context).brightness == Brightness.light)
        ? const Color.fromARGB(255, 255, 136, 255)
        : const Color.fromARGB(255, 211, 54, 198);

    return [
      CircularStackEntry(
        [
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
            rankKey: 'percentage2',
          ),
        ],
        rankKey: 'main',
      ),
    ];
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
                Center(
                  child: Text(
                    'Plan For Today',
                    style: TextStyle(
                      fontSize: size.width / 9,
                      letterSpacing: 1.5,
                      height: 0.9,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 0.025 * size.height),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // streak
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: size.width / 50,
                          vertical: size.height / 200,
                        ),
                        decoration: BoxDecoration(
                          color: streakInDanger
                              ? const Color(0xff6a0d0a)
                              : const Color(0xff06523f),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Text.rich(
                          TextSpan(
                            children: [
                              WidgetSpan(
                                child: Icon(
                                  Icons.local_fire_department,
                                  color: streakInDanger
                                      ? const Color(0xfff8b4b4)
                                      : const Color(0xff59cfb7),
                                  size: size.width / 20,
                                ),
                              ),
                              WidgetSpan(child: SizedBox(width: 5)),
                              TextSpan(
                                text: streakDays > 0
                                    ? "$streakDays ${streakDays == 1 ? "Day" : "Days"}"
                                    : '0 days',
                                style: TextStyle(
                                  fontSize: size.width / 25,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: size.width * 0.001,
                                  color: streakInDanger
                                      ? const Color(0xfff8b4b4)
                                      : const Color(0xff59cfb7),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 0.03 * size.width),
                      // completed in percentage
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: size.width / 50,
                          vertical: size.height / 200,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xff0b2971),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Text.rich(
                          TextSpan(
                            children: [
                              WidgetSpan(
                                child: Icon(
                                  Icons.check_circle,
                                  color: Color(0xff4961c5),
                                  size: size.width / 20,
                                ),
                              ),
                              WidgetSpan(child: SizedBox(width: 5)),
                              TextSpan(
                                text: '$procent%',
                                style: TextStyle(
                                  fontSize: size.width / 25,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xff4961c5),
                                  letterSpacing: size.width * 0.001,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 0.03 * size.width),
                      // Coins
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: size.width / 30,
                          vertical: size.height / 200,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xff0a6d59),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Text.rich(
                          TextSpan(
                            children: [
                              WidgetSpan(
                                child: Icon(
                                  Icons.currency_exchange_rounded,
                                  color: Color(0xff59cfb7),
                                  size: size.width / 20,
                                ),
                              ),
                              WidgetSpan(child: SizedBox(width: 5)),
                              TextSpan(
                                text: '${auria.floor()} Auria',
                                style: TextStyle(
                                  fontSize: size.width / 25,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xff59cfb7),
                                  letterSpacing: size.width * 0.001,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 0.05 * size.height),
                createBaseProgram(context),
                createWellBeing(context),
                SizedBox(height: 0.069 * size.height),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const MyBottomNavigationBar(),
    );
  }
}
