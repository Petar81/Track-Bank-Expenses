/// Bar chart example
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

/// Example of a grouped bar chart with three series, each rendered with
/// different fill colors.
class DaysChart extends StatelessWidget {
  final List<charts.Series<dynamic, String>> seriesList;
  final bool animate = true;

  const DaysChart(this.seriesList, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'by day overview',
          // style: TextStyle(fontSize: 16),
        ),
      ),
      body: charts.BarChart(
        seriesList,
        animate: animate,
        // Configure a stroke width to enable borders on the bars.
        defaultRenderer: charts.BarRendererConfig(
            groupingType: charts.BarGroupingType.grouped, strokeWidthPx: 2.0),
      ),
    );
  }
}

/// Sample ordinal data type.
class WeekDays {
  final String day;
  final double sum;
  final charts.Color color;

  WeekDays(this.day, this.sum, Color color)
      : color = charts.Color(
            r: color.red, g: color.green, b: color.blue, a: color.alpha);
}
