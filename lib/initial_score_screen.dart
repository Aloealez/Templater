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

  // Future<Map<int, double>> getMeanScores() async {
  //   String data = await rootBundle.loadString('assets/${widget.title.toLowerCase()}/mean_scores.xml');
  //   var xdoc = xml.XmlDocument.parse(data);
  //   Map<int, double> meanScores = {};
  //
  //   xdoc.findAllElements("mean_score").forEach((element) {
  //     int exercise = int.parse(element.findElements('exercise').first.innerText);
  //     meanScores[exercise] = 0.8 * widget.maxScore;
  //   });
  //
  //   return meanScores;
  // }

  // Map<int, double> meanScores = {};

  @override
  void initState() {
    super.initState();
    userLevel = widget.userScore / widget.maxScore;

    initMemory();
    saveScore();

    Future.delayed(Duration(milliseconds: 300), () {
      setState(() {
        isTextVisible = true;
      });
    });
    data = List.generate(200, (index) => _ChartData(index.toString(), normalDistr(-5, 5, 0.05)[index]));
    _tooltip = TooltipBehavior(enable: false);
    super.initState();
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
    double sigma = 1.5;
    double mu = 0;

    List<double> res = List.generate(((end - start + 1) / step).ceil(), (index) {
      double x = start + index * step;
      return (1 / (sigma * math.sqrt(2 * math.pi))) * math.exp((-(x - mu) * (x - mu)) / (2 * sigma * sigma));
    });
    return res;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    print("dataLength: ${data.length}, userLevel: $userLevel");

    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(
          left: size.width / 10,
          right: size.width / 10,
        ),
        child: Stack(
          children: <Widget>[
            // Align(
            //   alignment: Alignment(0, -0.93),
            //   child: RichText(
            //     text: TextSpan(
            //       style: TextStyle(
            //         color: Theme.of(context).colorScheme.onSurface,
            //       ),
            //       children: [
            //         TextSpan(
            //           text: widget.title,
            //           style: TextStyle(
            //             fontSize: size.width / 8,
            //           ),
            //         ),
            //       ],
            //     ),
            //     textAlign: TextAlign.center,
            //   ),
            // ),
            // Align(
            //   alignment: Alignment(0, -0.8),
            //   child: Text(
            //     widget.description,
            //     style: TextStyle(fontSize: size.width / 22),
            //   ),
            // ),
            Align(
              alignment: Alignment(0, 0.15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: size.height / 7,
                    child: Column (
                      children: [
                        AnimatedOpacity( //Great Job text
                          opacity: isTextVisible ? 1.0 : 0.0,
                          duration: Duration(milliseconds: 300),
                          child: Text(
                            "Great Job 🥳",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: size.width / 12,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ),
                        AnimatedOpacity( //You got [points] points
                          opacity: isTextVisible ? 1.0 : 0.0,
                          duration: Duration(milliseconds: 300),
                          child: Text(
                            "You got ${widget.userScore.toStringAsFixed(0)} points.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: size.width / 15,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: size.height / 5,
                    child: SfCartesianChart (
                      primaryXAxis: CategoryAxis(
                        majorTickLines: MajorTickLines(size: 0),
                        axisLine: AxisLine(
                          width: 2,
                          color: Theme.of(context).colorScheme.primaryFixedDim,
                        ),
                        labelStyle: TextStyle(
                          fontSize: 0,
                        ),
                      ),
                      primaryYAxis: NumericAxis(minimum: 0, maximum: 0.4, interval: 100,
                        majorTickLines: MajorTickLines(size: 0),
                        axisLine: AxisLine(
                          width: 0,
                        ),
                        labelStyle: TextStyle(
                          fontSize: 0,
                        ),
                      ),
                      tooltipBehavior: _tooltip,
                      series: <CartesianSeries<_ChartData, String>>[
                        AreaSeries<_ChartData, String>(
                          dataSource: data.sublist(0, (math.min(data.length - 1, data.length * userLevel)).floor()),
                          xValueMapper: (_ChartData data, _) => data.x,
                          yValueMapper: (_ChartData data, _) => data.y,
                          name: 'Gold',
                          color: Theme.of(context).colorScheme.secondaryContainer.withAlpha(79),
                        ),
                        LineSeries<_ChartData, String>(
                          // dataSource: data.sublist((data.length * userLevel).floor() - 1),
                          dataSource: data,
                          xValueMapper: (_ChartData data, _) => data.x,
                          yValueMapper: (_ChartData data, _) => data.y,
                          name: 'Gold',
                          color: Theme.of(context).colorScheme.primaryFixedDim,
                          width: 2,
                        ),
                        LineSeries<_ChartData, String>(
                          dataSource: [
                            _ChartData(data[(math.min(data.length - 1, data.length * userLevel)).floor()].x, 0),
                            _ChartData(data[(math.min(data.length - 1, data.length * userLevel)).floor()].x, data[(math.min(data.length - 1, data.length * userLevel)).floor()].y),
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
                    height: size.height/20,
                  ),
                  SizedBox(
                    height: size.height/4,
                    width: size.width/1.5,
                    child: Column (
                      children: [
                        AnimatedOpacity( //You got [points] points
                          opacity: isTextVisible ? 1.0 : 0.0,
                          duration: Duration(milliseconds: 300),
                          child: Text(
                            "You got a better score than ${(userLevel*100).floor()}% of the users.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: size.width / 20,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: size.height/20,
                        ),
                        AnimatedOpacity( //You got [points] points
                          opacity: isTextVisible ? 1.0 : 0.0,
                          duration: Duration(milliseconds: 300),
                          child: Text(
                            "${(100-(userLevel*100)).floor()}% of the app users got a better score than you.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: size.width / 20,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ),
                      ],

                    ),
                  ),

                  SizedBox(
                    height: size.height/20,
                  ),
                ],
              ),
            ),
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
          ],
        ),
      ),
    );
  }
}

class _ChartData {
  _ChartData(this.x, this.y);

  final String x;
  final double y;
}
