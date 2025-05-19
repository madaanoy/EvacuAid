import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

var name = 50.0;

class MyPieChart extends StatelessWidget {
  final int count1;
  final int count2;
  final int count3;
  final int count4;

  const MyPieChart({super.key, required this.count1, required this.count2, required this.count3, required this.count4,});

  @override
  Widget build(BuildContext context) {
    return PieChart(
      PieChartData(sections: [
        PieChartSectionData(
          value: count1.toDouble(),
          color: Colors.blue, // corrected 'Color' to 'color'
        ),
        PieChartSectionData(
          value: count2.toDouble(),
          color: Colors.red, // corrected 'Color' to 'color'
        ),
        PieChartSectionData(
          value: count3.toDouble(),
          color: Colors.green, // corrected 'Color' to 'color'
        ),
        PieChartSectionData(
          value: count4.toDouble(),
          color: Colors.yellow, // corrected 'Color' to 'color'
        ),
      ]),
    );
  }
}
