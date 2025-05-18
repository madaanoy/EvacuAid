import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

var name = 50.0;

class MyPieChart extends StatelessWidget {
  const MyPieChart({super.key});

  @override
  Widget build(BuildContext context) {
    return PieChart(
      PieChartData(sections: [
        PieChartSectionData(
          value: name,
          color: Colors.blue, // corrected 'Color' to 'color'
        ),
        PieChartSectionData(
          value: 20,
          color: Colors.red, // corrected 'Color' to 'color'
        ),
        PieChartSectionData(
          value: 20,
          color: Colors.green, // corrected 'Color' to 'color'
        ),
        PieChartSectionData(
          value: 20,
          color: Colors.yellow, // corrected 'Color' to 'color'
        ),
        PieChartSectionData(
          value: 20,
          color: Color(0xff62eeff), // corrected 'Color' to 'color'
        ),
        PieChartSectionData(
          value: 20,
          color: Colors.orange, // corrected 'Color' to 'color'
        ),
        PieChartSectionData(
          value: 20,
          color: Colors.purple, // corrected 'Color' to 'color'
        ),
        PieChartSectionData(
          value: 20,
          color: Color(0xffff91b6), // corrected 'Color' to 'color'
        ),
      ]),
    );
  }
}
