import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:firebase_database/firebase_database.dart';

class Trend extends StatefulWidget {
  final List<FlSpot> expenseSpots;
  final List<FlSpot> depositSpots;
  const Trend(this.expenseSpots, this.depositSpots, {Key? key})
      : super(key: key);

  @override
  State<Trend> createState() => _TrendState();
}

class _TrendState extends State<Trend> {
  @override
  void initState() {
    super.initState();
    onStart();
  }

  bool _isLoading = true;
  String _transactionQueryStr = 'last 10 transactions';
  var expenseSpots = <FlSpot>[];
  var depositSpots = <FlSpot>[];

  onStart() async {
    // IT HOLDS LOGIC FOR LAST 10 TRANSACTIONS CHART
    await getLastNTransactions(10);
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  getLastNTransactions(int numberOfTransactions) async {
    int transactionsNumber = numberOfTransactions;
    Map<dynamic, dynamic> values = {};
    var keys = [];
    var newExpenseSpots = <FlSpot>[];
    var newDepositSpots = <FlSpot>[];

    Query ref = FirebaseDatabase.instance
        .ref("transactions")
        .limitToLast(transactionsNumber);

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
        newExpenseSpots.add(FlSpot(i + 1, value));
        //print(expenseSpots.toString());
      } else {
        newExpenseSpots.add(FlSpot(i + 1, 0.0));
      }
    }

    for (var i = 0; i < keys.length; i++) {
      if (values[keys[i]]['transactionType'] == 'deposit') {
        //print(values[keys[i]]['transactionType']);
        var value = values[keys[i]]['transactionAmount'];
        value = value + .0;
        //print(value.runtimeType);
        newDepositSpots.add(FlSpot(i + 1, value));
        //print(expenseSpots.toString());
      } else {
        newDepositSpots.add(FlSpot(i + 1, 0.0));
      }
    }

    setState(() {
      expenseSpots = newExpenseSpots;
      depositSpots = newDepositSpots;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_transactionQueryStr),
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
                      spots: widget.depositSpots,
                      isCurved: false,
                      barWidth: 3,
                      colors: [
                        Colors.blue.shade300,
                      ],
                    ),
                    LineChartBarData(
                      spots: widget.expenseSpots,
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
