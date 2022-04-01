// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:track_bank_expenses/main.dart';
import '../models/balance_chart.dart';
import 'submit_expense.dart';
import 'submit_deposit.dart';
import 'transactions_history.dart';
import 'trend.dart';
import 'days_chart.dart';
import 'donut_chart.dart';

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
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    onStart();
  }

  @override
  void dispose() {
    super.dispose();
  }

  num showPreviousBalance = 0;
  num showCurrentBalance = 0;
  num transactionAmount = 0;
  String showDescription = 'description';
  String showTransactiondate = 'date';
  String showTransactionTime = 'time';
  bool isLoading = true;
  String userName = '';
  String avatarUrl = '';

  // GET A REFERENCE OF USER
  User? user = FirebaseAuth.instance.currentUser;

  void onStart() async {
    // Reference to currentBalance/currentAmount endpoint
    DatabaseReference getCurrentBalance = FirebaseDatabase.instance
        .ref("users/${user!.uid}/currentBalance/currentAmount");

    // Get the data once from currentBalance/currentAmount
    DatabaseEvent event = await getCurrentBalance.once();
    if (event.snapshot.value != null) {
      showCurrentBalance = event.snapshot.value as num;
      showCurrentBalance = showCurrentBalance.toDouble();
      showCurrentBalance = double.parse(showCurrentBalance.toStringAsFixed(2));
    } else {
      showCurrentBalance = 0.00;
    }

    // Get the data once from previousBalance/previousAmount
    DatabaseReference previousBalanceAmount = FirebaseDatabase.instance
        .ref("users/${user!.uid}/previousBalance/previousAmount");
    DatabaseEvent evento = await previousBalanceAmount.once();
    if (evento.snapshot.value != null) {
      showPreviousBalance = evento.snapshot.value as num;
      showPreviousBalance = showPreviousBalance.toDouble();
      showPreviousBalance =
          double.parse(showPreviousBalance.toStringAsFixed(2));
    } else {
      showPreviousBalance = 0.00;
    }
    // Get the data once from lastTransaction/lastTransactionAmount
    DatabaseReference lastTransactionAmount = FirebaseDatabase.instance
        .ref("users/${user!.uid}/lastTransaction/lastTransactionAmount");
    DatabaseEvent eventLastTransactionAmount =
        await lastTransactionAmount.once();
    if (eventLastTransactionAmount.snapshot.value != null) {
      transactionAmount = eventLastTransactionAmount.snapshot.value as num;
      transactionAmount = transactionAmount.toDouble();
      transactionAmount = double.parse(transactionAmount.toStringAsFixed(2));
    } else {
      transactionAmount = 0.00;
    }

    // Get the data once from lastTransaction/lastTransactionDescription
    DatabaseReference lastTransactionDescription = FirebaseDatabase.instance
        .ref("users/${user!.uid}/lastTransaction/lastTransactionDescription");
    DatabaseEvent eventLastTransactionDescription =
        await lastTransactionDescription.once();
    if (eventLastTransactionDescription.snapshot.value != null) {
      showDescription =
          eventLastTransactionDescription.snapshot.value as String;
    } else {
      showDescription = 'description';
    }

    // Get the data once from lastTransaction/lastTransactionDate
    DatabaseReference lastTransactionDate = FirebaseDatabase.instance
        .ref("users/${user!.uid}/lastTransaction/lastTransactionDate");
    DatabaseEvent eventLastTransactionDate = await lastTransactionDate.once();
    if (eventLastTransactionDate.snapshot.value != null) {
      showTransactiondate = eventLastTransactionDate.snapshot.value as String;
    } else {
      showTransactiondate = 'date';
    }

    // Get the data once from lastTransaction/lastTransactionTime
    DatabaseReference lastTransactionTime = FirebaseDatabase.instance
        .ref("users/${user!.uid}/lastTransaction/lastTransactionTime");
    DatabaseEvent eventLastTransactionTime = await lastTransactionTime.once();
    if (eventLastTransactionTime.snapshot.value != null) {
      showTransactionTime = eventLastTransactionTime.snapshot.value as String;
    } else {
      showTransactionTime = 'time';
    }

    // Reference to users/displayName endpoint
    DatabaseReference getUserName =
        FirebaseDatabase.instance.ref("users/${user!.uid}/displayName/");

    // Get the data once from users/user.uid/displayName
    DatabaseEvent userNameRef = await getUserName.once();
    if (userNameRef.snapshot.value != null) {
      final userNameSnapshot = userNameRef.snapshot.value as String;
      userName = userNameSnapshot;
    } else {
      userName = '';
    }

    // Reference to users/user.uid/avatarURL endpoint
    DatabaseReference refAvatarURL =
        FirebaseDatabase.instance.ref("users/${user!.uid}/avatarURL/");

    // Get the data once from users/user.uid/avatarURL
    DatabaseEvent avatarURLRef = await refAvatarURL.once();
    if (avatarURLRef.snapshot.value != null) {
      final avatarURLSnapshot = avatarURLRef.snapshot.value as String;
      avatarUrl = avatarURLSnapshot;
    } else {
      avatarUrl = '';
    }

    setState(() {
      isLoading = !isLoading;
    });
  }

  void _showBalance(num prevBalance, num currBalance, num transAmt,
      String description, String date, String time) {
    setState(() {
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

    // BALANCE CHART DATA
    var data = [
      BalanceChart(showPreviousBalance.toString(), showPreviousBalance,
          Colors.red.shade300),
      BalanceChart(showCurrentBalance.toString(), showCurrentBalance,
          Colors.blue.shade300),
      // BalanceChart('2018', _counter, Colors.green),
    ];

    // BALANCE CHART SERIES
    var series = [
      charts.Series(
        domainFn: (BalanceChart clickData, _) => clickData.balanceType,
        measureFn: (BalanceChart clickData, _) => clickData.balanceAmount,
        colorFn: (BalanceChart clickData, _) => clickData.color,
        id: 'Balances',
        data: data,
      ),
    ];

    // DEFINE A BALANCE CHART TYPE
    var chart = charts.BarChart(
      series,
      animate: true,
    );

    // CREATE A BALANCE CHART WIDGET
    var chartWidget = Padding(
      padding: const EdgeInsets.all(32.0),
      child: SizedBox(
        height: MediaQuery.of(context).size.height / 3,
        child: chart,
      ),
    );

    // LAUNCH URL
    _launchPayPalURL() async {
      final url =
          Uri.encodeFull('https://www.paypal.com/paypalme/SerbonaApplications');
      if (!await launch(url)) throw 'Could not launch $url';
      if (await canLaunch(url)) {
        await launch(url);
      }
    }

    // GET A REFERENCE OF USER
    User? user = FirebaseAuth.instance.currentUser;

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
            onEndDrawerChanged: (isOpened) async {
              // Reference to users/user.uid/avatarURL endpoint
              DatabaseReference refAvatarURL = FirebaseDatabase.instance
                  .ref("users/${user!.uid}/avatarURL/");

              // Get the data once from users/user.uid/avatarURL
              DatabaseEvent avatarURLRef = await refAvatarURL.once();
              if (avatarURLRef.snapshot.value != null) {
                final avatarURLSnapshot = avatarURLRef.snapshot.value as String;
                avatarUrl = avatarURLSnapshot;
              } else {
                avatarUrl = '';
              }
              setState(() {
                avatarUrl = avatarUrl;
              });
            },
            appBar: AppBar(
              // Here we take the value from the MyHomePage object that was created by
              // the App.build method, and use it to set our appbar title.
              title: Text(widget.title),
            ),
            endDrawer: Drawer(
              child: Column(
                children: [
                  UserAccountsDrawerHeader(
                    currentAccountPicture: avatarUrl != ''
                        ? CircleAvatar(
                            backgroundImage: NetworkImage(avatarUrl),
                          )
                        : const CircleAvatar(
                            backgroundImage: NetworkImage(
                                'https://firebasestorage.googleapis.com/v0/b/track-bank-expenses.appspot.com/o/images%2Favatar_placeholder.webp?alt=media&token=aa4c0ac9-012e-4e20-b9ca-e36a47d3773e'),
                          ),
                    accountEmail: Text(user != null ? user.email! : ''),
                    accountName: Text(
                      userName,
                      style: const TextStyle(fontSize: 24.0),
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
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Trend(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.bar_chart),
                    title: const Text(
                      'by Day',
                      style: TextStyle(fontSize: 20.0),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DaysChart(),
                          ));
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.pie_chart),
                    title: const Text(
                      'Sliced',
                      style: TextStyle(fontSize: 20.0),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DonutChart(),
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
                    onTap: _launchPayPalURL,
                  ),
                  const Divider(
                    height: 10,
                    thickness: 1,
                  ),
                  ListTile(
                    leading: const Icon(Icons.settings),
                    title: const Text(
                      'Settings',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    onTap: () async {
                      Navigator.pushNamed(context, '/settings').then((_) async {
                        // This block runs when we return back from settings
                        // Reference to users/user.uid/avatarURL endpoint
                        DatabaseReference refAvatarURL = FirebaseDatabase
                            .instance
                            .ref("users/${user!.uid}/avatarURL/");

                        // Get the data once from users/user.uid/avatarURL
                        DatabaseEvent avatarURLRef = await refAvatarURL.once();
                        if (avatarURLRef.snapshot.value != null) {
                          final avatarURLSnapshot =
                              avatarURLRef.snapshot.value as String;
                          avatarUrl = avatarURLSnapshot;
                        } else {
                          avatarUrl = '';
                        }

                        // Reference to users/displayName endpoint
                        DatabaseReference getUserName = FirebaseDatabase
                            .instance
                            .ref("users/${user.uid}/displayName/");

                        // Get the data once from users/user.uid/displayName
                        DatabaseEvent userNameRef = await getUserName.once();
                        if (userNameRef.snapshot.value != null) {
                          final userNameSnapshot =
                              userNameRef.snapshot.value as String;
                          userName = userNameSnapshot;
                        } else {
                          userName = '';
                        }

                        setState(() {
                          avatarUrl = avatarUrl;
                          userName = userName;
                        });
                      });
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.logout_rounded),
                    title: const Text(
                      'Logout',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    onTap: () async {
                      await FirebaseAuth.instance.signOut();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MyApp(),
                        ),
                      );
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
                              children: <Widget>[
                                TextButton(
                                  onPressed: () {},
                                  child:
                                      const Text('\u00A9 Serbona Applications'),
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
                              color: Colors.blue.shade300,
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
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Trend(),
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
                    backgroundColor: Colors.blue.shade300,
                  ),
                ),
              ],
            ),
          );
  }
}
