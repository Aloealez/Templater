import 'package:flutter/material.dart';
import 'dart:async';
import '/navbar.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:math';
import 'package:intl/intl.dart';
import 'package:brainace_pro/buttons.dart';
import '/buttons.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class AnalysisScreen extends StatefulWidget {
  final bool percent;
  final double userPoints;

  const AnalysisScreen({
    super.key,
    required this.percent,
    required this.userPoints,
  });

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  late double userLevel;
  bool isTextVisible = false;

  late List<_ChartData> data;
  late TooltipBehavior _tooltip;

  List<double> normalDistr(double start, double end, double step, {double mu = 0, double sigma = 1.5}) {
    return List.generate(
      ((end - start) / step).ceil(),
      (index) {
        double x = start + index * step;
        return (1 / (sigma * sqrt(2 * pi))) *
            exp((-1 * pow((x - mu), 2)) / (2 * pow(sigma, 2)));
      },
    );
  }

  double getDailyUserLevel() {
    final String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final Random random = Random(today.hashCode);
    return (random.nextInt(151) + 150) / 1000;
  }

  @override
  void initState() {
    super.initState();
    userLevel = getDailyUserLevel();

    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        isTextVisible = true;
      });
    });

    List<double> distribution = normalDistr(-5, 5, 0.05);
    data = List.generate(
      distribution.length,
      (index) => _ChartData(index.toString(), distribution[index]),
    );

    _tooltip = TooltipBehavior(enable: true);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: size.width * 0.1),
        child: Stack(
          children: <Widget>[
            _buildCenteredContent(size),
            _buildBottomButton(size),
          ],
        ),
      ),
      bottomNavigationBar: const MyBottomNavigationBar(),
    );
  }

  Widget _buildCenteredContent(Size size) {
    return Align(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildAnimatedText(
            text: "Great Job 🥳",
            fontSize: size.width / 12,
          ),
          _buildAnimatedText(
            text: widget.percent
                ? "You got [${widget.userPoints.toStringAsFixed(1)}%]."
                : "You got [${widget.userPoints.toStringAsFixed(0)}] points.",
            fontSize: size.width / 15,
          ),
          _buildChart(size),
          _buildComparisonText(size),
        ],
      ),
    );
  }

  Widget _buildAnimatedText({required String text, required double fontSize}) {
    return AnimatedOpacity(
      opacity: isTextVisible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 300),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: fontSize,
          color: Theme.of(context).colorScheme.primaryFixedDim,
        ),
      ),
    );
  }

  Widget _buildChart(Size size) {
    return SizedBox(
      height: size.height / 5,
      child: SfCartesianChart(
        primaryXAxis: CategoryAxis(
          majorTickLines: const MajorTickLines(size: 0),
          axisLine: AxisLine(
            width: 2,
            color: Theme.of(context).colorScheme.primaryFixedDim,
          ),
        ),
        primaryYAxis: NumericAxis(
          minimum: 0,
          maximum: 0.4,
          majorTickLines: const MajorTickLines(size: 0),
        ),
        tooltipBehavior: _tooltip,
        series: <CartesianSeries<_ChartData, String>>[
          AreaSeries<_ChartData, String>(
            dataSource: data.sublist(0, (data.length * userLevel).floor()),
            xValueMapper: (_ChartData data, _) => data.x,
            yValueMapper: (_ChartData data, _) => data.y,
            color: Theme.of(context).colorScheme.secondaryContainer.withAlpha(79),
          ),
          LineSeries<_ChartData, String>(
            dataSource: data,
            xValueMapper: (_ChartData data, _) => data.x,
            yValueMapper: (_ChartData data, _) => data.y,
            color: Theme.of(context).colorScheme.primaryFixedDim,
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonText(Size size) {
    return Column(
      children: [
        _buildAnimatedText(
          text: "You got a better score than ${(userLevel * 100).toStringAsFixed(1)}% of the users.",
          fontSize: size.width / 20,
        ),
        SizedBox(height: size.height / 20),
        _buildAnimatedText(
          text: "${(100 - (userLevel * 100)).toStringAsFixed(1)}% of the app users got a better score than you.",
          fontSize: size.width / 20,
        ),
      ],
    );
  }

  Widget _buildBottomButton(Size size) {
    return Positioned(
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
    );
  }
}

class _ChartData {
  _ChartData(this.x, this.y);

  final String x;
  final double y;
}
