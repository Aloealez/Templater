import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '/buttons.dart';

class ChartDataImprovement {
  ChartDataImprovement(this.day, this.score);
  final String day;
  final double score;
}

class ShowSatsImprovement extends StatefulWidget {
  const ShowSatsImprovement({
    super.key,
    required this.title,
    required this.description,
    required this.exercise,
    required this.yourScore,
    required this.maximum,
    required this.page,
    this.lastin = false,
    this.subtitle = "",
  });

  final String title;
  final String subtitle;
  final String description;
  final int exercise;
  final double yourScore;
  final double maximum;
  final Widget page;
  final bool lastin;
  @override
  State<ShowSatsImprovement> createState() => _ShowSatsImprovement();
}

class _ShowSatsImprovement extends State<ShowSatsImprovement>
    with SingleTickerProviderStateMixin {
  int selectedOption = 0;
  late SharedPreferences prefs;
  late List<ChartDataImprovement> chartData = <ChartDataImprovement>[];

  int improvementrate = 0;
  double oldscore = 0;

  void navigateToPage(Widget? page) {
    if (page != null) {
      Navigator.push(
        context,
        PageTransition(
          type: PageTransitionType.fade,
          child: page,
          reverseDuration: const Duration(milliseconds: 100),
          opaque: false,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    initData();
  }

  Future<void> initData() async {
    prefs = await SharedPreferences.getInstance();
    oldscore = prefs.getDouble(
      'initialTest_${widget.title}_${widget.exercise}',
    ) ??
        0;
    setState(() {
      chartData = [
        ChartDataImprovement("day 1", oldscore),
        ChartDataImprovement("day 30", widget.yourScore),
      ];
      if (oldscore == 0) {
        if (widget.yourScore == 0) {
          improvementrate = 0;
        } else {
          improvementrate = 100;
        }
      } else {
        improvementrate = ((widget.yourScore / oldscore - 1) * 100).toInt();
      }
    });
    if (widget.lastin) {
      prefs.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(
          left: size.width / 10,
          right: size.width / 10,
          top: size.height / 10,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  children: [
                    TextSpan(
                      text: "Your Progress",
                      style: TextStyle(
                        fontSize: size.width / 8,
                      ),
                    ),
                    TextSpan(
                      text: widget.subtitle,
                      style: TextStyle(
                        fontSize: size.width / 16,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: size.height / 15,
            ),
            SfCartesianChart(
              primaryXAxis: const CategoryAxis(),
              primaryYAxis: const NumericAxis(),
              series: <CartesianSeries>[
                LineSeries<ChartDataImprovement, String>(
                  color: Colors.cyan[300],
                  width: 5,
                  dataSource: chartData,
                  xValueMapper: (ChartDataImprovement data, _) => data.day,
                  yValueMapper: (ChartDataImprovement data, _) => data.score,
                  markerSettings: MarkerSettings(
                    isVisible: true,
                    shape: DataMarkerType.circle,
                    color: Colors.cyan[300],
                    width: 12,
                    height: 12,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: size.height / 20,
            ),
            Center(
              child: Column(
                children: [
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 0.022 * size.height,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      children: [
                        const TextSpan(
                          text: "You have improved by ",
                        ),
                        TextSpan(
                          text: "$improvementrate%",
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: size.height / 30,
                  ),
                  Text(
                    "Well Done 🎉",
                    style: TextStyle(
                      fontSize: size.width / 16,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Center(
              child: SizedBox(
                height: size.height * 0.05,
                width: size.width * 0.75,
                child: RedirectButton(
                  route: widget.page,
                  text: 'Continue',
                  width: size.width,
                  clearAllWindows: widget.lastin,
                ),
              ),
            ),
            SizedBox(
              height: size.height / 10,
            ),
          ],
        ),
      ),
    );
  }
}
