import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class Trend extends StatefulWidget {
  const Trend({Key? key}) : super(key: key);

  @override
  State<Trend> createState() => _TrendState();
}

class _TrendState extends State<Trend> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trend overview (last 7 days)'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 50.0, bottom: 10.0),
          child: Container(
            padding: const EdgeInsets.all(10),
            width: double.infinity,
            child: LineChart(
              LineChartData(
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        const FlSpot(3, 130.01),
                        const FlSpot(6, 57.22),
                        const FlSpot(7, 150.00),
                      ],
                      isCurved: false,
                      barWidth: 3,
                      colors: [
                        Colors.green.shade300,
                      ],
                    ),
                    LineChartBarData(
                      spots: [
                        const FlSpot(1, 79.23),
                        const FlSpot(2, 900),
                        const FlSpot(2, 13.11),
                        const FlSpot(3, 47.99),
                        const FlSpot(6, 17.56),
                        const FlSpot(1, 15.00),
                        const FlSpot(7, 20.00)
                      ],
                      isCurved: false,
                      barWidth: 3,
                      colors: [
                        Colors.orange.shade300,
                      ],
                    ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
