// import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
  final int _counter = 0;

  // void _incrementCounter() {
  //   setState(() {
  //     // This call to setState tells the Flutter framework that something has
  //     // changed in this State, which causes it to rerun the build method below
  //     // so that the display can reflect the updated values. If we changed
  //     // _counter without calling setState(), then the build method would not be
  //     // called again, and so nothing would appear to happen.
  //     _counter++;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          String date;
          String time;
          double currentBalance;

          DatabaseReference getCurrentBalance =
              FirebaseDatabase.instance.ref("currentBalance/currentAmount");

          // Get the data once
          DatabaseEvent event = await getCurrentBalance.once();
          currentBalance = event.snapshot.value as double;

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

          double amount = 12.05;

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
        },
        tooltip: 'add expense',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
