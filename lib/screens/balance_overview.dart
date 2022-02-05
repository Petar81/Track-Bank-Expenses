// import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:fl_chart/fl_chart.dart';
import '../models/balance_chart.dart';
import 'submit_expense.dart';
import 'submit_deposit.dart';
import 'transactions_history.dart';
import 'trend.dart';
import 'days_chart.dart';

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
  final database = FirebaseDatabase.instance.ref();

  @override
  void initState() {
    super.initState();
    onStart();
  }

  num showPreviousBalance = 0;
  num showCurrentBalance = 0;
  num transactionAmount = 0;
  String showDescription = 'description';
  String showTransactiondate = 'date';
  String showTransactionTime = 'time';
  bool isLoading = true;
  var expenseSpots = <FlSpot>[];
  var depositSpots = <FlSpot>[];

  void onStart() async {
    // Reference to currentBalance/currentAmount endpoint
    DatabaseReference getCurrentBalance =
        FirebaseDatabase.instance.ref("currentBalance/currentAmount");

    // Get the data once from currentBalance/currentAmount
    DatabaseEvent event = await getCurrentBalance.once();
    showCurrentBalance = event.snapshot.value as num;
    showCurrentBalance = showCurrentBalance.toDouble();
    showCurrentBalance = double.parse(showCurrentBalance.toStringAsFixed(2));

    // Get the data once from previousBalance/previousAmount
    DatabaseReference previousBalanceAmount =
        FirebaseDatabase.instance.ref("previousBalance/previousAmount");
    DatabaseEvent evento = await previousBalanceAmount.once();
    showPreviousBalance = evento.snapshot.value as num;
    showPreviousBalance = showPreviousBalance.toDouble();
    showPreviousBalance = double.parse(showPreviousBalance.toStringAsFixed(2));

    // Get the data once from lastTransaction/lastTransactionAmount
    DatabaseReference lastTransactionAmount =
        FirebaseDatabase.instance.ref("lastTransaction/lastTransactionAmount");
    DatabaseEvent eventLastTransactionAmount =
        await lastTransactionAmount.once();
    transactionAmount = eventLastTransactionAmount.snapshot.value as num;
    transactionAmount = transactionAmount.toDouble();
    transactionAmount = double.parse(transactionAmount.toStringAsFixed(2));

    // Get the data once from lastTransaction/lastTransactionDescription
    DatabaseReference lastTransactionDescription = FirebaseDatabase.instance
        .ref("lastTransaction/lastTransactionDescription");
    DatabaseEvent eventLastTransactionDescription =
        await lastTransactionDescription.once();
    showDescription = eventLastTransactionDescription.snapshot.value as String;

    // Get the data once from lastTransaction/lastTransactionDate
    DatabaseReference lastTransactionDate =
        FirebaseDatabase.instance.ref("lastTransaction/lastTransactionDate");
    DatabaseEvent eventLastTransactionDate = await lastTransactionDate.once();
    showTransactiondate = eventLastTransactionDate.snapshot.value as String;

    // Get the data once from lastTransaction/lastTransactionTime
    DatabaseReference lastTransactionTime =
        FirebaseDatabase.instance.ref("lastTransaction/lastTransactionTime");
    DatabaseEvent eventLastTransactionTime = await lastTransactionTime.once();
    showTransactionTime = eventLastTransactionTime.snapshot.value as String;

    // IT HOLDS LOGIC FOR LAST 10 TRANSACTIONS CHART
    getTransactions();

    setState(() {
      isLoading = !isLoading;
    });
  }

  getTransactions() async {
    Map<dynamic, dynamic> values = {};
    var keys = [];
    var newExpenseSpots = <FlSpot>[];
    var newDepositSpots = <FlSpot>[];

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

  void _showBalance(num prevBalance, num currBalance, num transAmt,
      String description, String date, String time) {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      showPreviousBalance = double.parse(prevBalance.toStringAsFixed(2));
      showCurrentBalance = double.parse(currBalance.toStringAsFixed(2));
      transactionAmount = double.parse(transAmt.toStringAsFixed(2));
      showDescription = description;
      showTransactiondate = date;
      showTransactionTime = time;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This (build) method is rerun every time setState is called

    // CHART DATA
    var data = [
      BalanceChart(showPreviousBalance.toString(), showPreviousBalance,
          Colors.red.shade300),
      BalanceChart(showCurrentBalance.toString(), showCurrentBalance,
          Colors.green.shade300),
      // BalanceChart('2018', _counter, Colors.green),
    ];

    // CHART SERIES
    var series = [
      charts.Series(
        domainFn: (BalanceChart clickData, _) => clickData.balanceType,
        measureFn: (BalanceChart clickData, _) => clickData.balanceAmount,
        colorFn: (BalanceChart clickData, _) => clickData.color,
        id: 'Balances',
        data: data,
      ),
    ];

    // DEFINE A CHART TYPE
    var chart = charts.BarChart(
      series,
      animate: true,
    );

    // CREATE A CHART WIDGET
    var chartWidget = Padding(
      padding: const EdgeInsets.all(32.0),
      child: SizedBox(
        height: MediaQuery.of(context).size.height / 3,
        child: chart,
      ),
    );

    return isLoading
        ? Scaffold(
            appBar: AppBar(
              title: Text(widget.title),
            ),
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          ) //loading widget goes here
        : Scaffold(
            appBar: AppBar(
              // Here we take the value from the MyHomePage object that was created by
              // the App.build method, and use it to set our appbar title.
              title: Text(widget.title),
            ),
            endDrawer: Drawer(
              child: Column(
                children: [
                  UserAccountsDrawerHeader(
                    currentAccountPicture: const CircleAvatar(
                      backgroundImage: NetworkImage(
                          'https://cdn.pixabay.com/photo/2016/08/08/09/17/avatar-1577909_960_720.png'),
                    ),
                    accountEmail: const Text('jane.doe@example.com'),
                    accountName: const Text(
                      'Jane Doe',
                      style: TextStyle(fontSize: 24.0),
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.history),
                    title: const Text(
                      'History',
                      style: TextStyle(fontSize: 20.0),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TransactionsHistory(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.show_chart),
                    title: const Text(
                      'Trend',
                      style: TextStyle(fontSize: 20.0),
                    ),
                    onTap: () async {
                      await getTransactions();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              Trend(expenseSpots, depositSpots),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.bar_chart),
                    title: const Text(
                      '7 Days',
                      style: TextStyle(fontSize: 20.0),
                    ),
                    onTap: () async {
                      await getTransactions();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DaysChart(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.pie_chart),
                    title: const Text(
                      'Sliced',
                      style: TextStyle(fontSize: 20.0),
                    ),
                    onTap: () async {
                      await getTransactions();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              Trend(expenseSpots, depositSpots),
                        ),
                      );
                    },
                  ),
                  const Divider(
                    height: 10,
                    thickness: 1,
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.coffee,
                      color: Colors.brown[200],
                    ),
                    title: const Text(
                      'buy us a coffee',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    onTap: () {
                      // Navigator.pushReplacement(
                      //   context,
                      //   MaterialPageRoute<void>(
                      //     builder: (BuildContext context) => const MyHomePage(
                      //       title: 'Favorites',
                      //     ),
                      //   ),
                      // );
                    },
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Made in Serbia with ',
                                  // style: TextStyle(fontSize: 14),
                                ),
                                Icon(
                                  Icons.favorite,
                                  color: Colors.red[300],
                                  size: 16,
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text(
                                  '\u00A9 Serbona Applications',
                                  // style: TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
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
                  elevation: 2,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        leading: showCurrentBalance < showPreviousBalance
                            ? Icon(
                                Icons.arrow_downward,
                                color: Colors.red.shade300,
                                size: 30,
                              )
                            : Icon(
                                Icons.arrow_upward,
                                color: Colors.green.shade300,
                                size: 30,
                              ),
                        title: Text(
                            'Your last transaction was $transactionAmount'),
                        subtitle: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Text(showDescription),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: Text(
                                      'on $showTransactiondate @ $showTransactionTime'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          TextButton(
                            child: const Text('VIEW ALL'),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const TransactionsHistory(),
                                ),
                              );
                            },
                          ),
                          const SizedBox(width: 8),
                          TextButton(
                            child: const Text('TREND'),
                            onPressed: () async {
                              await getTransactions();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      Trend(expenseSpots, depositSpots),
                                ),
                              );
                            },
                          ),
                          const SizedBox(width: 8),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            floatingActionButton: Stack(
              children: <Widget>[
                Align(
                  alignment: const Alignment(-0.75, 1.0),
                  child: FloatingActionButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SubmitExpense(
                            notifyParentAboutExpense: _showBalance,
                          ),
                        ),
                      );
                    },
                    tooltip: 'submit expense',
                    child: const Icon(Icons.minimize),
                    backgroundColor: Colors.red.shade300,
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: FloatingActionButton(
                    heroTag: null,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SubmitDeposit(
                            notifyParentAboutDeposit: _showBalance,
                          ),
                        ),
                      );
                    },
                    tooltip: 'submit deposit',
                    child: const Icon(Icons.add),
                    backgroundColor: Colors.green.shade300,
                  ),
                ),
              ],
            ),
          );
  }
}
