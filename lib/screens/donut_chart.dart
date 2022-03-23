import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  @override
  void dispose() {
    super.dispose();
  }

  double expenseTotal = 0.00;
  double depositTotal = 0.00;
  bool _isLoading = true;
  String _transactionQuery = 'all transactions';
  final FirebaseAuth auth = FirebaseAuth.instance;

  void onStart() async {
    final User? user = auth.currentUser;
    double expenseSum = 0.00;
    double depositSum = 0.00;
    Map<dynamic, dynamic> values = {};
    var keys = [];
    Query ref =
        FirebaseDatabase.instance.ref("users/${user!.uid}/transactions");

// Get the data once
    DatabaseEvent event = await ref.once();
    if (event.snapshot.value != null) {
      Map<dynamic, dynamic> data =
          event.snapshot.value as Map<dynamic, dynamic>;
      values = data;
    } else {
      values = {};
    }

    keys = (values.keys.toList()..sort());
    //print(keys);

    for (var i = 0; i < keys.length; i++) {
      if (values[keys[i]]['transactionType'] == 'expense') {
        //print(values[keys[i]]['transactionType']);
        var expenseValue = values[keys[i]]['transactionAmount'];
        expenseValue = expenseValue + .0;
        expenseSum += expenseValue;
        //print(value.runtimeType);
      } else if (values[keys[i]]['transactionType'] == 'deposit') {
        var depositValue = values[keys[i]]['transactionAmount'];
        depositValue = depositValue + .0;
        depositSum += depositValue;
      }
    }

    setState(() {
      expenseTotal = expenseSum;
      depositTotal = depositSum;
      _isLoading = !_isLoading;
    });
  }

  getLastNTransactions(int numberOfTransactions) async {
    _isLoading = true;
    int transactionsNumber = numberOfTransactions;
    final User? user = auth.currentUser;
    double expenseSumN = 0.00;
    double depositSumN = 0.00;
    Map<dynamic, dynamic> values = {};
    var keys = [];

    Query ref = FirebaseDatabase.instance
        .ref("users/${user!.uid}/transactions")
        .limitToLast(transactionsNumber);

// Get the data once
    DatabaseEvent event = await ref.once();
    if (event.snapshot.value != null) {
      Map<dynamic, dynamic> data =
          event.snapshot.value as Map<dynamic, dynamic>;
      values = data;
    } else {
      values = {};
    }

    keys = (values.keys.toList()..sort());
    //print(keys);

    for (var i = 0; i < keys.length; i++) {
      if (values[keys[i]]['transactionType'] == 'expense') {
        //print(values[keys[i]]['transactionType']);
        var expenseValueN = values[keys[i]]['transactionAmount'];
        expenseValueN = expenseValueN + .0;
        expenseSumN += expenseValueN;
        //print(value.runtimeType);
      } else if (values[keys[i]]['transactionType'] == 'deposit') {
        var depositValueN = values[keys[i]]['transactionAmount'];
        depositValueN = depositValueN + .0;
        depositSumN += depositValueN;
      }
    }

    setState(() {
      expenseTotal = expenseSumN;
      depositTotal = depositSumN;
      _isLoading = !_isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    Map<String, double> dataMap = {
      "Expenses": double.parse(expenseTotal.toStringAsFixed(2)),
      "Deposits": double.parse(depositTotal.toStringAsFixed(2)),
    };
    final colorList = <Color>[
      Colors.red.shade300,
      Colors.blue.shade300,
    ];
    return _isLoading == true
        ? Scaffold(
            appBar: AppBar(
              title: const Text('View transactions history'),
            ),
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Scaffold(
            appBar: AppBar(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      _transactionQuery,
                      //style: TextStyle(
                      // fontFamily: 'OpenSansBold',
                      // fontSize: 26.0,
                      // ),
                    ),
                  ],
                ),
                actions: <Widget>[
                  PopupMenuButton(
                    onSelected: (int result) {
                      if (result == 30) {
                        getLastNTransactions(result);
                        setState(() {
                          _transactionQuery = 'last 30 transactions';
                        });
                      } else if (result == 60) {
                        getLastNTransactions(result);
                        setState(() {
                          _transactionQuery = 'last 60 transactions';
                        });
                      } else if (result == 90) {
                        getLastNTransactions(result);
                        setState(() {
                          _transactionQuery = 'last 90 transactions';
                        });
                      } else if (result == 120) {
                        getLastNTransactions(result);
                        setState(() {
                          _transactionQuery = 'last 120 transactions';
                        });
                      } else if (result == 7) {
                        onStart();
                        setState(() {
                          _transactionQuery = 'all transactions';
                          _isLoading = !_isLoading;
                        });
                      }
                    },
                    icon: const Icon(Icons.arrow_drop_down),
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        child: Text("last 30 transactions"),
                        value: 30,
                      ),
                      const PopupMenuItem(
                        child: Text("last 60 transactions"),
                        value: 60,
                      ),
                      const PopupMenuItem(
                        child: Text("last 90 transactions"),
                        value: 90,
                      ),
                      const PopupMenuItem(
                        child: Text("last 120 transactions"),
                        value: 120,
                      ),
                      const PopupMenuItem(
                        child: Text("see all transactions"),
                        value: 7,
                      ),
                    ],
                  ),
                ]),
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
                          '-${double.parse(expenseTotal.toStringAsFixed(2))}',
                          style: TextStyle(
                              color: Colors.red.shade300,
                              fontWeight: FontWeight.w800,
                              fontSize: 16),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(right: 20, bottom: 80),
                        ),
                        Text(
                          '+${double.parse(depositTotal.toStringAsFixed(2))}',
                          style: TextStyle(
                              color: Colors.blue.shade300,
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
