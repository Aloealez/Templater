import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

SfLinearGauge scoreAxis(
  BuildContext context,
  double yourScore,
  double meanScore,
  double maximum,
) {
  return SfLinearGauge(
    showAxisTrack: false,
    showTicks: false,
    showLabels: false,
    useRangeColorForAxis: true,
    animateAxis: true,
    axisTrackStyle: const LinearAxisTrackStyle(thickness: 1),
    ranges: <LinearGaugeRange>[
      LinearGaugeRange(
        startWidth: 25,
        endWidth: 25,
        shaderCallback: (bounds) => const RadialGradient(
          center: Alignment.topLeft,
          radius: 12.5,
          colors: [
            Colors.red,
            Colors.yellow,
            Colors.green,
          ],
        ).createShader(bounds),
      ),
    ],
    markerPointers: [
      LinearShapePointer(
        value: yourScore,
        shapeType: LinearShapePointerType.rectangle,
        height: 30,
        width: 4,
        color: Colors.blue,
      ),
      LinearWidgetPointer(
        value: yourScore,
        offset: 30,
        position: LinearElementPosition.outside,
        child: const Text("Your\nScore"),
      ),
      LinearWidgetPointer(
        value: yourScore,
        offset: -60,
        position: LinearElementPosition.inside,
        child: Text(yourScore.toString()),
      ),
      LinearShapePointer(
        value: meanScore,
        shapeType: LinearShapePointerType.rectangle,
        height: 30,
        width: 4,
      ),
      LinearWidgetPointer(
        value: meanScore,
        offset: 30,
        position: LinearElementPosition.outside,
        child: const Text("Mean\nScore"),
      ),
    ],
    maximum: maximum,
  );
}
