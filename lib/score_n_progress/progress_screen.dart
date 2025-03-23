import 'package:brainace_pro/base_plan_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import '../app_bar.dart';
import 'package:brainace_pro/widgets/port_home_tasks_widget.dart';
import 'package:brainace_pro/widgets/port_home_tasks_widget_config.dart';
import 'package:home_widget/home_widget.dart';
import 'package:brainace_pro/activities_for_each_section.dart';

import '../home.dart';

class ProgressScreen extends StatefulWidget {
  final bool points;
  final double? userScore;
  final double? maxScore;
  final String txt;
  final String pointAlternative;
  final String exercise;

  const ProgressScreen({
    super.key,
    this.points = true,
    this.userScore,
    this.maxScore,
    required this.exercise,
    this.txt = "You Received",
    this.pointAlternative = "Points",
    final bool showAsPercentage = false,

  });

  @override
  _ProgressScreen createState() => _ProgressScreen();
}

class ChartData {
  ChartData(this.day, this.score);

  final DateTime day;
  final double score;
}

class _ProgressScreen extends State<ProgressScreen>
    with SingleTickerProviderStateMixin {
  int? _tappedIndex;
  late SharedPreferences prefs;
  late List<ChartData> chartData = <ChartData>[];
  late ConfettiController _confettiController;
  int day = 0;
  bool newScores = false;
  double lastUserScore = 0;
  double lastMaxScore = 1;

  @override
  void initState() {
    newScores = widget.userScore != null;
    lastUserScore = widget.userScore ?? 0;
    super.initState();
    readMemory();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 1));
    _confettiController.play();

    WidgetsBinding.instance.addPostFrameCallback((timestamp) {
      PortHomeTasksWidgetConfig.initialize().then((value) async {
        callHomeWidgetUpdate();
      });
    });
  }

  Future<void> readMemory() async {
    await calcDay();
    await initMemory();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

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

  Future<void> initMemory() async {
    prefs = await SharedPreferences.getInstance();
    List<ChartData> newChartData = <ChartData>[];

    if (widget.maxScore != null) {
      prefs.setString("lastMaxScore_${widget.exercise}", widget.maxScore.toString());
      lastMaxScore = widget.maxScore!;
    } else {
      lastMaxScore = double.parse(prefs.getString("lastMaxScore_${widget.exercise}") ?? "1");
    }

    List<String> timestamps = prefs.getStringList(
          "timestamps_${widget.exercise}",
        ) ??
        [];
    List<String> scores = prefs.getStringList(
          "${widget.exercise}_scores",
        ) ??
        [];

    if (newScores) {
      timestamps.add(DateTime.now().millisecondsSinceEpoch.toString());
      scores.add(widget.userScore.toString());
    }

    print("scores: $scores");
    print("timestamps: $timestamps");
    if (scores.isNotEmpty) {
      lastUserScore = double.parse(scores.last);
    } else {
      lastUserScore = 0;
    }

    if (newScores) {
      prefs.setStringList("timestamps_${widget.exercise}", timestamps);
      prefs.setStringList("${widget.exercise}_scores", scores);
    }

    for (int i = 0; i < scores.length; i++) {
      newChartData.add(
        ChartData(
          DateTime.fromMillisecondsSinceEpoch(int.parse(timestamps[i])),
          double.parse(scores[i]),
        ),
      );
    }

    if (newScores) {
      await prefs.setString("${widget.exercise}TickedDay$day", "1");
    }

    callHomeWidgetUpdate();

    if (newScores) {
      setState(() {
        chartData = newChartData;
      });
    }
  }

  Future<void> callHomeWidgetUpdate() async {
    BasePlanData basePlanData = BasePlanData();
    await basePlanData.initState();

    List<String> widgetItems = [];
    for (int i = 0; i < basePlanData.plan.length; i++) {
      widgetItems.add(
        "${basePlanData.basePlanTicked[i] == "1" ? "◉" : "○"}:${sectionNames[basePlanData.plan[i]]}",
      );
      print(
        "plan[$i] ${basePlanData.plan[i]} ${sectionNames[basePlanData.plan[i]]} ${basePlanData.basePlanTicked[i]}",
      );
    }

    HomeWidget.saveWidgetData("plan_title", "BeSmart List");
    HomeWidget.saveWidgetData("plan_tasks", widgetItems.join(','));
    HomeWidget.updateWidget(
      androidName: "TodoHomeScreenWidget",
    );

    // here it should be different, why?
    if (mounted) {
      PortHomeTasksWidgetConfig.update(
        context,
        PortHomeTasksWidget(
          plan: basePlanData.plan,
          basePlanTicked: basePlanData.basePlanTicked,
          sectionNames: sectionNames,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    print(
        "widget.exercise: ${widget.exercise} widget.userScore: ${widget.userScore} maxScore: ${lastMaxScore}");
    Size size = MediaQuery.of(context).size;
    print("widget.userScore: ${widget.userScore}");

    DateTimeAxis xAxis = DateTimeAxis(
      isVisible: false,
      rangePadding: ChartRangePadding.none,
      minimum: chartData.isNotEmpty
          ? _getCustomMin(chartData.first.day, chartData.length)
          : null,
      maximum: chartData.isNotEmpty
          ? _getCustomMax(chartData.last.day, chartData.length)
          : null,
    );

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Stack(
          children: [
            appBar(context, ""),
            Positioned.fill(
              top: kToolbarHeight,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                gravity: 0.1,
                emissionFrequency: 0.075,
                numberOfParticles: 100,
                maxBlastForce: 80,
                blastDirection: 1,
                colors: const [
                  Colors.green,
                  Colors.blue,
                  Colors.pink,
                  Colors.orange,
                  Colors.purple,
                  Colors.yellow,
                  Colors.teal,
                ],
              ),
            ),
          ],
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(
          left: size.width / 10,
          right: size.width / 10,
          top: size.height / 9,
        ),
        child: Stack(
          children: <Widget>[
            Align(
              alignment: const Alignment(0, 0),
              child: Column(
                children: [
                  Text(
                    "Great Job 🥳",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: size.width / 12,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(
                    height: size.height / 60,
                  ),
                  SizedBox(
                    width: size.width / 1.75,
                    child: Text(
                      "Your Accuracy Is Now Equal To ${(lastUserScore * 100 / lastMaxScore).round()}%",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: size.width / 18,
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: size.height / 25),
                  SizedBox(
                    height: size.height * 0.35,
                    child: chartData.isEmpty
                        ? const Center(child: CircularProgressIndicator())
                        : SfCartesianChart(
                            primaryXAxis: DateTimeCategoryAxis(
                              isVisible: false,
                              rangePadding: ChartRangePadding.none,
                            ),
                            primaryYAxis: NumericAxis(
                              isVisible: false,
                            ),
                            series: <CartesianSeries>[
                              // Warstwa 1
                              LineSeries<ChartData, DateTime>(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryFixedDim
                                    .withOpacity(0.02),
                                width: 35,
                                dataSource: chartData,
                                xValueMapper: (ChartData data, _) => data.day,
                                yValueMapper: (ChartData data, _) => data.score,
                              ),
                              // Warstwa 2
                              LineSeries<ChartData, DateTime>(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryFixedDim
                                    .withOpacity(0.03),
                                width: 25,
                                dataSource: chartData,
                                xValueMapper: (ChartData data, _) => data.day,
                                yValueMapper: (ChartData data, _) => data.score,
                              ),
                              // Warstwa 3
                              LineSeries<ChartData, DateTime>(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryFixedDim
                                    .withOpacity(0.04),
                                width: 20,
                                dataSource: chartData,
                                xValueMapper: (ChartData data, _) => data.day,
                                yValueMapper: (ChartData data, _) => data.score,
                              ),
                              // Warstwa 4
                              LineSeries<ChartData, DateTime>(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryFixedDim
                                    .withOpacity(0.05),
                                width: 15,
                                dataSource: chartData,
                                xValueMapper: (ChartData data, _) => data.day,
                                yValueMapper: (ChartData data, _) => data.score,
                              ),
                              // Warstwa 5
                              LineSeries<ChartData, DateTime>(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryFixedDim
                                    .withOpacity(0.06),
                                width: 10,
                                dataSource: chartData,
                                xValueMapper: (ChartData data, _) => data.day,
                                yValueMapper: (ChartData data, _) => data.score,
                              ),
                              LineSeries<ChartData, DateTime>(
                                onPointTap: (ChartPointDetails details) {
                                  debugPrint("onPointTap wywołany! index = ${details.pointIndex}");
                                  final int? index = details.pointIndex;
                                  if (index != null &&
                                      index > 0 &&
                                      index < chartData.length - 1) {
                                    setState(() {
                                      _tappedIndex = index;
                                    });
                                    Future.delayed(const Duration(seconds: 1),
                                        () {
                                      if (mounted && _tappedIndex == index) {
                                        setState(() {
                                          _tappedIndex = null;
                                        });
                                      }
                                    });
                                  }
                                },
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryFixedDim,
                                width: 5,
                                dataSource: chartData,
                                xValueMapper: (ChartData data, _) => data.day,
                                yValueMapper: (ChartData data, _) => data.score,
                                markerSettings: MarkerSettings(
                                  isVisible: true,
                                  shape: DataMarkerType.circle,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primaryFixedDim,
                                  width: 12,
                                  height: 12,
                                ),
                                dataLabelSettings: const DataLabelSettings(
                                  isVisible: true,
                                  labelAlignment:
                                      ChartDataLabelAlignment.bottom,
                                  offset: Offset(0, -5),
                                  textStyle: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                dataLabelMapper: (ChartData data, int index) {
                                  if (index == 0) {
                                    final day =
                                        data.day.day.toString().padLeft(2, '0');
                                    final month = data.day.month
                                        .toString()
                                        .padLeft(2, '0');
                                    return "${(data.score.round() / lastMaxScore * 100).round()}%\n$day.$month";
                                  } else if (index == chartData.length - 1) {
                                    return "${(data.score.round() / lastMaxScore * 100).round()}%\nNow";
                                  } else if (_tappedIndex == index) {
                                    final day =
                                        data.day.day.toString().padLeft(2, '0');
                                    final month = data.day.month
                                        .toString()
                                        .padLeft(2, '0');
                                    return "${(data.score.round() / lastMaxScore * 100).round()}%\n$day.$month";
                                  }
                                  return "";
                                },
                              ),
                            ],
                          ),
                  ),
                  SizedBox(height: size.height / 25),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 1 dzień wstecz, jeśli mamy > niż 1 punkt
  DateTime _getCustomMin(DateTime firstDay, int length) {
    if (length > 1) {
      return firstDay.subtract(const Duration(days: 1));
    }
    return firstDay; // jeśli tylko 1 punkt, nic nie odejmujemy
  }

  /// 1 dzień do przodu, jeśli mamy > niż 1 punkt
  DateTime _getCustomMax(DateTime lastDay, int length) {
    if (length > 1) {
      return lastDay.add(const Duration(days: 1));
    }
    return lastDay; // jeśli tylko 1 punkt, nic nie dodajemy
  }
}
