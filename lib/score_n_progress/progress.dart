import 'package:flutter/material.dart';
import 'package:circular_chart_flutter/circular_chart_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../margins.dart';
import '../navbar.dart';
import 'dart:math';

class Progress extends StatefulWidget {
  const Progress({super.key});
  @override
  State<Progress> createState() => _Progress();
}

class _Progress extends State<Progress> {
  late SharedPreferences prefs;

  List<GlobalKey<AnimatedCircularChartState>> keys =
      List.generate(31, (index) => GlobalKey<AnimatedCircularChartState>());

  List<double> summ = List.generate(31, (index) => 60.0);
  List<double> value = List.generate(31, (index) => 60.0);
  List<double> value2 = List.generate(31, (index) => 40.0);
  List<double> value3 = List.generate(31, (index) => 0.0);
  List<double> value32 = List.generate(31, (index) => 60.0);
  Color? labelColor = Colors.blue[200];

  int day = 0;
  int trainingTime = 0;

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

  Future<void> getTrainingTime() async {
    prefs = await SharedPreferences.getInstance();
    int newTrainingTime = prefs.getInt('training_time')!;

    setState(() {
      trainingTime = newTrainingTime;
    });
  }

  Future<void> getValues() async {
    prefs = await SharedPreferences.getInstance();
    for (int i = 1; i <= 30; ++i) {
      int points = prefs.getInt('pointsDay$i') ?? 0;
      int procent = int.parse((points / trainingTime * 100).toStringAsFixed(0));

      setState(() {
        value[i] = min(procent.toDouble(), 100);
        value2[i] = 100 - value[i];
        List<CircularStackEntry> data = _generateChartData(i);
        keys[i].currentState!.updateData(data);
      });
    }
  }

  Future<void> getValues2() async {
    prefs = await SharedPreferences.getInstance();
    Future.delayed(const Duration(milliseconds: 500), () {
      for (int i = 1; i <= 30; ++i) {
        int points = prefs.getInt('pointsDay$i') ?? 0;
        int procent =
            int.parse((points / trainingTime * 100).toStringAsFixed(0));

        setState(() {
          if (procent >= 200) {
            value[i] = 100;
            value2[i] = 0;
            value3[i] = 100;
          } else {
            value[i] = min(procent.toDouble(), 100);
            value2[i] = 100 - value[i];
            value3[i] = (procent > 100) ? procent % 100 : 0;
          }

          List<CircularStackEntry> data = _generateChartData(i);
          keys[i].currentState!.updateData(data);
        });
      }
    });
  }

  List<CircularStackEntry> _generateChartData(int dayNum) {
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
            value3[dayNum],
            dialColor3,
            rankKey: 'percentage3',
          ),
          CircularSegmentEntry(
            value[dayNum],
            dialColor,
            rankKey: 'percentage1',
          ),
          CircularSegmentEntry(
            value2[dayNum],
            dialColor2,
            rankKey: 'percentage4',
          ),
        ],
        rankKey: 'percentage4',
      ),
    ];
    return data;
  }

  Future<void> readMemory() async {
    await calcDay();
    await getTrainingTime();
    await getValues();
    await getValues2();
  }

  @override
  void initState() {
    super.initState();

    readMemory();

    //_increment1(1);
    //_increment2(1);
    for (int i = 1; i <= 30; ++i) {}
  }

  SizedBox buildChart(BuildContext context, int dayNum) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      width: 60,
      height: 60,
      child: AnimatedCircularChart(
        key: keys[dayNum],
        size: const Size(80.0, 80.0),
        initialChartData: _generateChartData(dayNum),
        holeRadius: 10,
        chartType: CircularChartType.Radial,
        edgeStyle: SegmentEdgeStyle.round,
        percentageValues: true,
        holeLabel: dayNum.toString(),
        labelStyle: TextStyle(
          fontSize: 0.022 * size.height,
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Column buildChartRow(BuildContext context, int i) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            for (int j = 1; j <= 5; ++j) buildChart(context, (i - 1) * 5 + j),
          ],
        ),
        SizedBox(height: 0.02 * size.height),
      ],
    );
  }

  Column buildChartColumn(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        for (int i = 1; i <= 6; ++i) buildChartRow(context, i),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        margin: activitiesMargins(size),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: Text(
                    "Your 30 Days",
                    style: TextStyle(
                      fontSize: size.width / 9,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Center(
                  child: Text(
                    "100% Means That All The Tasks Were Completed",
                    style: TextStyle(fontSize: size.width / 22),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            SizedBox(height: 0.05 * size.height),
            buildChartColumn(context),
          ],
        ),
      ),
      bottomNavigationBar: const MyBottomNavigationBar(),
    );
  }
}
