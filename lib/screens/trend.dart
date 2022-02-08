import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class Trend extends StatelessWidget {
  final List<FlSpot> expenseSpots;
  final List<FlSpot> depositSpots;
  const Trend(this.expenseSpots, this.depositSpots, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trend for last 10 transactions'),
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
                      spots: depositSpots,
                      isCurved: false,
                      barWidth: 3,
                      colors: [
                        Colors.blue.shade300,
                      ],
                    ),
                    LineChartBarData(
                      spots: expenseSpots,
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
