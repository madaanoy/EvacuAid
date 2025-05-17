import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

var Adult_Sum = 0.0;
var Children_Sum = 0.0;
var Infant_Sum = 0.0;
var Senior_Sum = 0.0;
var Pregnant_Sum = 0.0;
var Lactating_Sum = 0.0;
var PWD_Sum = 0.0;
var WithIllness_Sum = 0.0;

class MyPieChart extends StatelessWidget {
  const MyPieChart({super.key});

  @override
  Widget build(BuildContext context) {
    return PieChart(
      PieChartData(sections: [
        PieChartSectionData(
          value: Adult_Sum,
          color: Colors.blue, // corrected 'Color' to 'color'
        ),
        PieChartSectionData(
          value: Children_Sum,
          color: Colors.red, // corrected 'Color' to 'color'
        ),
        PieChartSectionData(
          value: Infant_Sum,
          color: Colors.green, // corrected 'Color' to 'color'
        ),
        PieChartSectionData(
          value: Senior_Sum,
          color: Colors.yellow, // corrected 'Color' to 'color'
        ),
        PieChartSectionData(
          value: Pregnant_Sum,
          color: Color(0xff62eeff), // corrected 'Color' to 'color'
        ),
        PieChartSectionData(
          value: Lactating_Sum,
          color: Colors.orange, // corrected 'Color' to 'color'
        ),
        PieChartSectionData(
          value: PWD_Sum,
          color: Colors.purple, // corrected 'Color' to 'color'
        ),
        PieChartSectionData(
          value: WithIllness_Sum,
          color: Color(0xffff91b6), // corrected 'Color' to 'color'
        ),
      ]),
    );
  }
}
