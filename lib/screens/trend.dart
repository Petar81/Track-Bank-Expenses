import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:firebase_database/firebase_database.dart';

class Trend extends StatefulWidget {
  const Trend({Key? key}) : super(key: key);

  @override
  State<Trend> createState() => _TrendState();
}

class _TrendState extends State<Trend> {
  @override
  void initState() {
    super.initState();
    getTransactions();
  }

  Map<dynamic, dynamic> values = {};
  bool _isLoading = true;
  var keys = [];
  var expenseSpots = <FlSpot>[];
  var depositSpots = <FlSpot>[];

  getTransactions() async {
    Query ref = FirebaseDatabase.instance.ref("transactions").limitToLast(10);

// Get the data once
    DatabaseEvent event = await ref.once();

    Map<dynamic, dynamic> data = event.snapshot.value as Map<dynamic, dynamic>;
    values = data;

    keys = (values.keys.toList()..sort());
    //print(keys);

    for (var i = 0; i < keys.length; i++) {
      if (values[keys[i]]['transactionType'] == 'expense') {
        //print(values[keys[i]]['transactionType']);
        var value = values[keys[i]]['transactionAmount'];
        value = value + .0;
        //print(value.runtimeType);
        expenseSpots.add(FlSpot(i + 1, value));
        //print(expenseSpots.toString());
      } else {
        expenseSpots.add(FlSpot(i + 1, 0.0));
      }
    }

    for (var i = 0; i < keys.length; i++) {
      if (values[keys[i]]['transactionType'] == 'deposit') {
        //print(values[keys[i]]['transactionType']);
        var value = values[keys[i]]['transactionAmount'];
        value = value + .0;
        //print(value.runtimeType);
        depositSpots.add(FlSpot(i + 1, value));
        //print(expenseSpots.toString());
      } else {
        depositSpots.add(FlSpot(i + 1, 0.0));
      }
    }

    setState(() {
      _isLoading = !_isLoading;
    });
  }

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
                      spots: depositSpots,
                      isCurved: false,
                      barWidth: 3,
                      colors: [
                        Colors.green.shade300,
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
