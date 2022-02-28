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
    onStart();
  }

  bool _isLoading = true;
  String _transactionQueryStr = 'last 7 transactions';
  var expenseSpots = <FlSpot>[const FlSpot(1.36, 1.33)]; // dummy val @ initial.
  var depositSpots = <FlSpot>[const FlSpot(1.18, 1.20)]; // dummy val @ initial.

  onStart() async {
    // IT HOLDS LOGIC FOR LAST 10 TRANSACTIONS CHART
    await getLastNTransactions(7);
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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _transactionQueryStr,
            ),
          ],
        ),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (int result) {
              if (result == 7) {
                getLastNTransactions(result);
                setState(() {
                  _transactionQueryStr = 'last 7 transactions';
                  _isLoading = !_isLoading;
                });
              } else if (result == 10) {
                getLastNTransactions(result);
                setState(() {
                  _isLoading = !_isLoading;
                  _transactionQueryStr = 'last 10 transactions';
                });
              } else if (result == 15) {
                getLastNTransactions(result);
                setState(() {
                  _isLoading = !_isLoading;
                  _transactionQueryStr = 'last 15 transactions';
                });
              } else if (result == 30) {
                getLastNTransactions(result);
                setState(() {
                  _isLoading = !_isLoading;
                  _transactionQueryStr = 'last 30 transactions';
                });
              } else if (result == 50) {
                getLastNTransactions(result);
                setState(() {
                  _isLoading = !_isLoading;
                  _transactionQueryStr = 'last 50 transactions';
                });
              }
            },
            icon: const Icon(Icons.arrow_drop_down),
            itemBuilder: (context) => [
              const PopupMenuItem(
                child: Text("last 7 transactions"),
                value: 7,
              ),
              const PopupMenuItem(
                child: Text("last 10 transactions"),
                value: 10,
              ),
              const PopupMenuItem(
                child: Text("last 15 transactions"),
                value: 15,
              ),
              const PopupMenuItem(
                child: Text("last 30 transactions"),
                value: 30,
              ),
              const PopupMenuItem(
                child: Text("last 50 transactions"),
                value: 50,
              ),
            ],
          ),
        ],
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
