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
                  lineTouchData: LineTouchData(
                    touchTooltipData:
                        LineTouchTooltipData(tooltipBgColor: Colors.black87),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        const FlSpot(1, 0),
                        const FlSpot(2, 0),
                        const FlSpot(3, 0),
                        const FlSpot(4, 0),
                        const FlSpot(5, 100),
                        const FlSpot(6, 0),
                        const FlSpot(7, 0)
                      ],
                      isCurved: false,
                      barWidth: 3,
                      colors: [
                        Colors.green.shade300,
                      ],
                    ),
                    LineChartBarData(
                      spots: [
                        const FlSpot(1, 150.23),
                        const FlSpot(2, 99),
                        const FlSpot(3, 47.99),
                        const FlSpot(4, 0),
                        const FlSpot(5, 0),
                        const FlSpot(6, 457.56),
                        const FlSpot(7, 20.00)
                      ],
                      isCurved: false,
                      barWidth: 3,
                      colors: [
                        Colors.red.shade300,
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
