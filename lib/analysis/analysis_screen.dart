import 'package:flutter/material.dart';
import 'dart:async';
import '/navbar.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:math';
import 'package:intl/intl.dart';
import 'package:brainace_pro/buttons.dart';


class AnalysisScreen extends StatefulWidget {
  // parametr percent steruje wyświetlaniem punktów w procentach lub jako zwykłe punkty
  // userPoints wyniosłam do konstruktora, by można było podawać wynik z zewnątrz
  final bool percent;
  final double userPoints;

  const AnalysisScreen({
    super.key,
    required this.percent,
    required this.userPoints,
  });

  @override
  State<AnalysisScreen> createState() => _AnalysisScreen();
}

class _AnalysisScreen extends State<AnalysisScreen> {
  late double userLevel;
  bool isTextVisible = false;


  late List<_ChartData> data;
  late TooltipBehavior _tooltip;

  List<double> normalDistr(double start, double end, double step) {
    double sigma = 1.5;
    double mu = 0;

    List<double> res = List.generate(
      ((end - start + 1) / step).ceil(),
          (index) {
        double x = start + index * step;
        return (1 / (sigma * sqrt(2 * pi))) *
            exp((-1 * (x - mu) * (x - mu)) / (2 * sigma * sigma));
      },
    );
    return res;
  }

  double getDailyUserLevel() {
    final String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final int seed = today.hashCode;
    final Random random = Random(seed);
    return (random.nextInt(151) + 150) / 1000; // np. 0.15–0.30
  }

  @override
  void initState() {
    super.initState();
    userLevel = getDailyUserLevel();

    // Opóźnione włączenie animacji z fade-in
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        isTextVisible = true;
      });
    });

    data = List.generate(
      200,
          (index) => _ChartData(
        index.toString(),
        normalDistr(-5, 5, 0.05)[index],
      ),
    );

    _tooltip = TooltipBehavior(enable: false);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(
          left: size.width / 10,
          right: size.width / 10,
        ),
        child: Stack(
          children: <Widget>[
            Align(
              alignment: const Alignment(0, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: size.height / 7,
                    child: Column(
                      children: [
                        AnimatedOpacity(
                          // Tekst "Great Job 🥳"
                          opacity: isTextVisible ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 300),
                          child: Text(
                            "Great Job 🥳",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: size.width / 12,
                              color: Theme.of(context).colorScheme.primaryFixedDim,
                            ),
                          ),
                        ),
                        AnimatedOpacity(
                          // Tekst "You got [x points]" lub "You got [x%]"
                          opacity: isTextVisible ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 300),
                          child: Text(
                            widget.percent
                                ? "You got [${widget.userPoints.toStringAsFixed(1)}%]."
                                : "You got [${widget.userPoints.toStringAsFixed(0)}] points.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: size.width / 15,
                              color: Theme.of(context).colorScheme.primaryFixedDim,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: size.height / 5,
                    child: SfCartesianChart(
                      primaryXAxis: CategoryAxis(
                        majorTickLines: const MajorTickLines(size: 0),
                        axisLine: AxisLine(
                          width: 2,
                          color: Theme.of(context).colorScheme.primaryFixedDim,
                        ),
                        labelStyle: const TextStyle(
                          fontSize: 0,
                        ),
                      ),
                      primaryYAxis: NumericAxis(
                        minimum: 0,
                        maximum: 0.4,
                        interval: 100,
                        majorTickLines: const MajorTickLines(size: 0),
                        axisLine: const AxisLine(
                          width: 0,
                        ),
                        labelStyle: const TextStyle(
                          fontSize: 0,
                        ),
                      ),
                      tooltipBehavior: _tooltip,
                      series: <CartesianSeries<_ChartData, String>>[
                        AreaSeries<_ChartData, String>(
                          dataSource: data
                              .sublist(0, (data.length * userLevel).floor()),
                          xValueMapper: (_ChartData data, _) => data.x,
                          yValueMapper: (_ChartData data, _) => data.y,
                          name: 'Gold',
                          color: Theme.of(context)
                              .colorScheme
                              .secondaryContainer
                              .withAlpha(79),
                        ),
                        LineSeries<_ChartData, String>(
                          dataSource: data,
                          xValueMapper: (_ChartData data, _) => data.x,
                          yValueMapper: (_ChartData data, _) => data.y,
                          name: 'Gold',
                          color: Theme.of(context).colorScheme.primaryFixedDim,
                          width: 2,
                        ),
                        LineSeries<_ChartData, String>(
                          dataSource: [
                            _ChartData(
                              data[(data.length * userLevel).floor()].x,
                              0,
                            ),
                            _ChartData(
                              data[(data.length * userLevel).floor()].x,
                              data[(data.length * userLevel).floor()].y,
                            ),
                          ],
                          xValueMapper: (_ChartData data, _) => data.x,
                          yValueMapper: (_ChartData data, _) => data.y,
                          name: 'Gold',
                          color: Theme.of(context).colorScheme.primaryFixedDim,
                          width: 2,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: size.height / 20,
                  ),
                  SizedBox(
                    height: size.height / 4,
                    width: size.width / 1.5,
                    child: Column(
                      children: [
                        AnimatedOpacity(
                          opacity: isTextVisible ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 300),
                          child: Text(
                            "You got a better score than ${(userLevel * 100).toStringAsFixed(1)}% of the users.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: size.width / 20,
                              color: Theme.of(context).colorScheme.primaryFixedDim,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: size.height / 20,
                        ),
                        AnimatedOpacity(
                          opacity: isTextVisible ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 300),
                          child: Text(
                            "${(100 - (userLevel * 100)).toStringAsFixed(1)}% of the app users got a better score than you.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: size.width / 20,
                              color: Theme.of(context).colorScheme.primaryFixedDim,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: size.height / 20,
                  ),
                ],
              ),
            ),
            // Przycisk "Continue"
            Positioned(
              bottom: 50,
              left: 0,
              right: 0,
              child: Center(
                child: SizedBox(
                  width: size.width * 0.75,
                  height: size.height * 0.05,
                  child: RedirectButton(
                    text: 'Continue',
                    width: size.width,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const MyBottomNavigationBar(),
    );
  }
}

class _ChartData {
  _ChartData(this.x, this.y);

  final String x;
  final double y;
}
