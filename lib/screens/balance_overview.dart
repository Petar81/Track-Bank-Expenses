// import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import '../models/balance_chart.dart';
import 'submit_expense.dart';

class BalanceOverview extends StatefulWidget {
  const BalanceOverview({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<BalanceOverview> createState() => _BalanceOverviewState();
}

class _BalanceOverviewState extends State<BalanceOverview> {
  double showPreviousBalance = 0;
  double showCurrentBalance = 0;
  double transactionAmount = 0;

  void _showBalance(double prevBalance, double currBalance, double transAmt) {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      showPreviousBalance = double.parse(prevBalance.toStringAsFixed(2));
      showCurrentBalance = double.parse(currBalance.toStringAsFixed(2));
      transactionAmount = double.parse(transAmt.toStringAsFixed(2));
    });
  }

  @override
  Widget build(BuildContext context) {
    // This (build) method is rerun every time setState is called

    final List<String> entries = <String>[
      'A',
      'B',
      'C',
      'D',
      'E',
      'F',
      'G',
      'H'
    ];

    var data = [
      BalanceChart(showPreviousBalance.toString(), showPreviousBalance,
          Colors.red.shade300),
      BalanceChart(showCurrentBalance.toString(), showCurrentBalance,
          Colors.green.shade300),
      // BalanceChart('2018', _counter, Colors.green),
    ];

    var series = [
      charts.Series(
        domainFn: (BalanceChart clickData, _) => clickData.balanceType,
        measureFn: (BalanceChart clickData, _) => clickData.balanceAmount,
        colorFn: (BalanceChart clickData, _) => clickData.color,
        id: 'Balances',
        data: data,
      ),
    ];

    var chart = charts.BarChart(
      series,
      animate: true,
    );

    var chartWidget = Padding(
      padding: const EdgeInsets.all(32.0),
      child: SizedBox(
        height: 200.0,
        child: chart,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'previous balance',
                  textAlign: TextAlign.left,
                ),
                Text(
                  'current balance',
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ),
          Card(
            elevation: 4,
            child: SizedBox(
              child: Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: ColoredBox(
                        color: Colors.red.shade300,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          child: Text(
                            '$showPreviousBalance',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: ColoredBox(
                        color: Colors.green.shade300,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          child: Text(
                            '$showCurrentBalance',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Card(
            elevation: 4,
            child: chartWidget,
          ),
          const Padding(
            padding: EdgeInsets.only(top: 5),
          ),
          Card(
            elevation: 4,
            child: SizedBox(
              height: 300,
              child: ListView.separated(
                padding: const EdgeInsets.all(8),
                itemCount: entries.length,
                itemBuilder: (BuildContext context, int index) {
                  return SizedBox(
                    height: 60,
                    //color: Colors.amber.shade300,
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const <Widget>[
                            Center(
                              child: Text('22-JUN-2022 '),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Center(
                              child: Text(
                                  '$showPreviousBalance - $transactionAmount = $showCurrentBalance'),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Center(
                              child:
                                  Text('$transactionAmount (popoo oioi ioiio)'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(
                  thickness: 3,
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Align(
        alignment: const Alignment(-0.82, 1.0),
        child: FloatingActionButton(
          onPressed: () async {
            String date;
            String time;
            double currentBalance;
            // double previousBalance;

            DatabaseReference getCurrentBalance =
                FirebaseDatabase.instance.ref("currentBalance/currentAmount");

            // Get the data once
            DatabaseEvent event = await getCurrentBalance.once();
            currentBalance = event.snapshot.value as double;
            currentBalance = double.parse(currentBalance.toStringAsFixed(2));

            // SAVE PREVIOUS BALANCE IN FIREBASE
            DatabaseReference previousBalanceRef =
                FirebaseDatabase.instance.ref("previousBalance");
            await previousBalanceRef.set({
              "previousAmount": currentBalance,
            }).catchError(
                (error) => const Text('You got an error! Please try again.'));

            // GET THE CURRENT TIMESTAMP
            var now = DateTime.now();

            // FORMAT DATE (yyyy-MM-dd) from a TIMESTAMP
            var dateFormatter = DateFormat('yyyy-MM-dd');
            String formattedDate = dateFormatter.format(now);
            date = formattedDate;

            // FORMAT TIME (hh-mm-ss) from a TIMESTAMP
            var timeFormatter = DateFormat.Hms();
            String formattedTime = timeFormatter.format(now);
            time = formattedTime;

            double amount = 1.05;

            // SET EXPENSE IN FIREBASE
            DatabaseReference ref =
                FirebaseDatabase.instance.ref("expenses/$date/$time");
            await ref.set({
              "expenseAmount": amount,
              "expenseDescription": "Yellow boots from Walmart",
            }).catchError(
                (error) => const Text('You got an error! Please try again.'));

            // UPDATE CURRENT BALANCE IN FIREBASE
            DatabaseReference currentBalanceRef =
                FirebaseDatabase.instance.ref("currentBalance");
            await currentBalanceRef.update({
              "currentAmount": currentBalance - amount,
            }).catchError(
                (error) => const Text('You got an error! Please try again.'));

            _showBalance(currentBalance, currentBalance - amount, amount);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SubmitExpense(
                  notifyParent: _showBalance,
                ),
              ),
            );
          },
          tooltip: 'submit expense',
          child: const Icon(Icons.minimize),
          backgroundColor: Colors.red.shade300,
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
