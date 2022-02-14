import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class DonutChart extends StatefulWidget {
  const DonutChart({Key? key}) : super(key: key);

  @override
  State<DonutChart> createState() => _DonutChartState();
}

class _DonutChartState extends State<DonutChart> {
  @override
  void initState() {
    super.initState();
    onStart();
  }

  void onStart() async {}

  @override
  Widget build(BuildContext context) {
    Map<String, double> dataMap = {
      "Expenses": 5,
      "Deposits": 2,
    };
    final colorList = <Color>[
      Colors.red.shade300,
      Colors.blue.shade300,
    ];
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
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 80),
                child: PieChart(
                  dataMap: dataMap,
                  animationDuration: const Duration(milliseconds: 1200),
                  chartLegendSpacing: 122,
                  chartRadius: MediaQuery.of(context).size.width / 3.2,
                  colorList: colorList,
                  initialAngleInDegree: 0,
                  chartType: ChartType.ring,
                  ringStrokeWidth: 182,
                  centerText: "%",
                  legendOptions: const LegendOptions(
                    showLegendsInRow: true,
                    legendPosition: LegendPosition.bottom,
                    showLegends: true,
                    legendTextStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  chartValuesOptions: const ChartValuesOptions(
                    showChartValueBackground: true,
                    showChartValues: true,
                    showChartValuesInPercentage: true,
                    showChartValuesOutside: true,
                    decimalPlaces: 1,
                  ),
                  // gradientList: ---To add gradient colors---
                  // emptyColorGradient: ---Empty Color gradient---
                ),
              ),
              Row(
                children: [
                  Text(
                    '-8797.89',
                    style: TextStyle(
                        color: Colors.red.shade300,
                        fontWeight: FontWeight.w800,
                        fontSize: 16),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(right: 20, bottom: 80),
                  ),
                  Text(
                    '+76768.67',
                    style: TextStyle(
                        color: Colors.blue.shade300,
                        fontWeight: FontWeight.w800,
                        fontSize: 16),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const <Widget>[
                  Text(
                    'TOTAL = 29898.76',
                    style: TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.w800,
                        fontSize: 16),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
