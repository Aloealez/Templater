import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../buttons.dart';
import 'dart:math' as math;

class InitialScoreScreen extends StatefulWidget {
  final String title;
  final String description;
  final int exercise;
  final double userScore;
  final double maxScore;
  final Widget? page;
  final bool clearAllWindows;

  const InitialScoreScreen({
    super.key,
    required this.title,
    required this.description,
    required this.exercise,
    required this.userScore,
    required this.maxScore,
    required this.page,
    this.clearAllWindows = false,
  });

  @override
  State<InitialScoreScreen> createState() => _InitialScoreScreenState();
}

class _InitialScoreScreenState extends State<InitialScoreScreen> {
  bool isTextVisible = false;
  late List<_ChartData> data;
  late TooltipBehavior _tooltip;
  late double userLevel;

  int selectedOption = 0;
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    userLevel = widget.userScore / widget.maxScore;

    initMemory();
    saveScore();

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

  Future<void> initMemory() async {
    setState(() {});
  }

  Future<void> saveScore() async {
    prefs = await SharedPreferences.getInstance();
    prefs.setDouble(
      'initialTest_${widget.title}_${widget.exercise}',
      widget.userScore,
    );
  }

  List<double> normalDistr(double start, double end, double step) {
    double sigma = 1.8;
    double mu = 0;

    return List.generate(
      ((end - start + 1) / step).ceil(),
          (index) {
        final x = start + index * step;
        return (1 / (sigma * math.sqrt(2 * math.pi))) *
            math.exp(-((x - mu) * (x - mu)) / (2 * sigma * sigma));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    print("dataLength: ${data.length}, userLevel: $userLevel");

    // 1) Find the apex (peak) of the distribution at x=0 (roughly mid index).
    //   We'll use the actual maximum 'y' among all points for a perfect match.
    final double maxY = data.map((d) => d.y).reduce(math.max);
    final apexIndex = data.indexWhere((d) => d.y == maxY);
    // 2) The baseline point has x=apexIndex, but y=0 (x=0 along X-axis).
    //   That means we’ll pair the apex (x=0, y=maxY) with (x=0, y=0).
    //   We already have each data point’s x as a String, so we’ll keep it consistent.

    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        margin: EdgeInsets.only(
          left: size.width / 10,
          right: size.width / 10,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: size.height * 0.15),
            AnimatedOpacity(
              opacity: isTextVisible ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              child: Text(
                "Amazing!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'OleoScriptSwashCaps',
                  fontSize: size.width / 6,
                  fontWeight: FontWeight.bold,
                  foreground: Paint()
                    ..shader = const LinearGradient(
                      colors: [Color(0xffA7E2FF), Color(0xffDC92FF)],
                    ).createShader(
                      const Rect.fromLTWH(0, 0, 200, 70),
                    ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            AnimatedOpacity(
              opacity: isTextVisible ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              child: Text(
                "You got ${widget.userScore.toStringAsFixed(0)} "
                    "out of ${widget.maxScore.toStringAsFixed(0)} questions right.",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),


            SizedBox(
                width: size.width * 0.75,
                height: size.height * 0.4,
                child:
                Stack(
                  children: [
                    Align(
                      alignment: Alignment(0, 0),
                      child: SfCartesianChart(
                        plotAreaBorderWidth: 0,
                        primaryXAxis: CategoryAxis(
                          majorTickLines: const MajorTickLines(size: 0),
                          majorGridLines: const MajorGridLines(width: 0),
                          axisLine: AxisLine(
                            width: 0,
                            color: Theme.of(context)
                                .colorScheme
                                .primaryFixedDim,
                          ),
                          labelStyle: const TextStyle(fontSize: 0),
                        ),
                        primaryYAxis: NumericAxis(
                          minimum: 0,
                          maximum: 0.4,
                          interval: 100,
                          majorTickLines: const MajorTickLines(size: 0),
                          majorGridLines: const MajorGridLines(width: 0),
                          axisLine: const AxisLine(width: 0),
                          labelStyle: const TextStyle(fontSize: 0),
                        ),
                        tooltipBehavior: _tooltip,
                        series: <CartesianSeries<_ChartData, String>>[
                          // Purple fill from left up to apex
                          AreaSeries<_ChartData, String>(
                            dataSource: data.sublist(0, (math.min(data.length - 1, data.length * userLevel)).floor()),
                            xValueMapper: (_ChartData data, _) => data.x,
                            yValueMapper: (_ChartData data, _) => data.y,
                            name: 'Gold',
                            color: Theme.of(context).colorScheme.secondaryContainer.withAlpha(79),
                            // pointColorMapper: (_ChartData data, _) => Theme.of(context).colorScheme.primaryFixedDim.withAlpha(79),
                          ),
                          LineSeries<_ChartData, String>(
                            // dataSource: data.sublist((data.length * userLevel).floor() - 1),
                            dataSource: data,
                            xValueMapper: (_ChartData data, _) => data.x,
                            yValueMapper: (_ChartData data, _) => data.y,
                            name: 'Gold',
                            color: Theme.of(context).colorScheme.primaryFixedDim,
                            width: 3,
                          ),
                          LineSeries<_ChartData, String>(
                            dataSource: [
                              _ChartData(data[(math.min(data.length - 1, data.length * userLevel)).round()].x, 0),
                              _ChartData(data[(math.min(data.length - 1, data.length * userLevel)).round()].x, data[(math.min(data.length - 1, data.length * userLevel)).round()].y),
                            ],
                            xValueMapper: (_ChartData data, _) => data.x,
                            yValueMapper: (_ChartData data, _) => data.y,
                            name: 'Gold',
                            color: Theme.of(context).colorScheme.primaryFixedDim,
                            width: 3,
                          ),
                          LineSeries<_ChartData, String>(
                            dataSource: [_ChartData(data.first.x, 0), _ChartData(data.last.x, 0)],
                            xValueMapper: (_ChartData data, _) => data.x,
                            yValueMapper: (_ChartData data, _) => data.y,
                            name: 'Gold',
                            color: Theme.of(context).colorScheme.primaryFixedDim,
                            width: 5.5,
                          ),
                          ScatterSeries<_ChartData, String>(
                            dataSource: [
                              _ChartData(data[(data.length * 0.63).toInt()].x, data[(data.length * 0.63).toInt()].y, 'Good Score'),
                            ],
                            xValueMapper: (_ChartData d, _) => d.x,
                            yValueMapper: (_ChartData d, _) => d.y,
                            dataLabelMapper: (_ChartData d, _) => d.label,
                            markerSettings: const MarkerSettings(
                              isVisible: true,
                              shape: DataMarkerType.circle,
                              // White circle
                              color: Colors.white,
                              borderColor: Colors.white,
                            ),
                            dataLabelSettings: const DataLabelSettings(
                              isVisible: true,
                              textStyle: TextStyle(
                                color: Colors.white,
                              ),
                              labelAlignment: ChartDataLabelAlignment.top,
                            ),
                          ),
                          ScatterSeries<_ChartData, String>(
                            dataSource: [
                              _ChartData(data[math.min(data.length - 1, data.length * userLevel).floor()].x, 0, 'Your Score'),
                            ],
                            xValueMapper: (_ChartData d, _) => d.x,
                            yValueMapper: (_ChartData d, _) => d.y,
                            dataLabelMapper: (_ChartData d, _) => d.label,
                            markerSettings: const MarkerSettings(
                              isVisible: true,
                              shape: DataMarkerType.circle,
                              color: Colors.white,
                              borderColor: Colors.white,
                            ),
                            dataLabelSettings: const DataLabelSettings(
                              isVisible: true,
                              // offset: Offset(0, -15),
                              textStyle: TextStyle(
                                color: Colors.white,
                              ),
                              labelAlignment: ChartDataLabelAlignment.top,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                )
            ),
            Spacer(),
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
                    route: widget.page,
                    clearAllWindows: widget.clearAllWindows,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: size.height * 0.05,),
          ],
        ),
      ),
    );
  }
}

// Extended to store an optional label
class _ChartData {
  _ChartData(this.x, this.y, [this.label]);
  final String x;
  final double y;
  final String? label;
}
