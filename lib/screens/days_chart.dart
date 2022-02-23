/// Bar chart example
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

/// Example of a grouped bar chart with three series, each rendered with
/// different fill colors.
class DaysChart extends StatefulWidget {
  final List<charts.Series<dynamic, String>> seriesList;

  const DaysChart(this.seriesList, {Key? key}) : super(key: key);

  @override
  State<DaysChart> createState() => _DaysChartState();
}

class _DaysChartState extends State<DaysChart> {
  final bool animate = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'since beginning ',
              style: TextStyle(
                  // fontFamily: 'OpenSansBold',
                  // fontSize: 26.0,
                  ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.arrow_drop_down),
            ),
          ],
        ),
      ),
      body: charts.BarChart(
        widget.seriesList,
        animate: animate,
        // Configure a stroke width to enable borders on the bars.
        defaultRenderer: charts.BarRendererConfig(
            groupingType: charts.BarGroupingType.grouped, strokeWidthPx: 2.0),
      ),
    );
  }
}
