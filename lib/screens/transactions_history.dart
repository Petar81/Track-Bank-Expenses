import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TransactionsHistory extends StatefulWidget {
  const TransactionsHistory({Key? key}) : super(key: key);

  @override
  State<TransactionsHistory> createState() => _TransactionsHistoryState();
}

class _TransactionsHistoryState extends State<TransactionsHistory> {
  @override
  void initState() {
    super.initState();
    getTransactions();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Map<dynamic, dynamic> values = {};
  bool _isLoading = true;
  bool _descendingList = true;
  final FirebaseAuth auth = FirebaseAuth.instance;

  getTransactions() async {
    final User? user = auth.currentUser;
    DatabaseReference ref =
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

    setState(() {
      _isLoading = !_isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
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
              title: const Text('View transactions history'),
            ),
            body: Card(
              child: SizedBox(
                height: double.infinity,
                child: ListView.separated(
                  padding: const EdgeInsets.all(8),
                  itemCount: values.length,
                  itemBuilder: (BuildContext context, int index) {
                    String key;
                    // A HAACK TO CONVERT AN ITERABLE INTO AN ASCENDING/DECENDING LIST
                    _descendingList == true
                        ? key = (values.keys.map((i) => i).toList()..sort())
                            .reversed
                            .elementAt(index) as String
                        : key = (values.keys.map((i) => i).toList()..sort())
                            .elementAt(index) as String;
                    return SizedBox(
                      height: 110,
                      //color: Colors.amber.shade300,
                      child: ListTile(
                        leading: values[key]['balanceAfterTransaction'] <
                                values[key]['balanceBeforeTransaction']
                            ? Icon(
                                Icons.south_west_rounded,
                                color: Colors.red.shade300,
                                size: 30,
                              )
                            : Icon(
                                Icons.north_east_rounded,
                                color: Colors.green.shade300,
                                size: 30,
                              ),
                        title: Text(
                            '${values[key]['transactionDate']} @ ${values[key]['transactionTime']}'),
                        subtitle: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Text(
                                    '${values[key]['transactionDescription']}'),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: values[key]['transactionType'] ==
                                            'expense'
                                        ? RichText(
                                            text: TextSpan(
                                              style:
                                                  DefaultTextStyle.of(context)
                                                      .style,
                                              children: [
                                                const WidgetSpan(
                                                  child: Icon(
                                                    Icons.remove,
                                                    size: 16,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text:
                                                      "${values[key]['transactionAmount']}",
                                                  style: TextStyle(
                                                      color: Colors.black
                                                          .withOpacity(0.9)),
                                                ),
                                              ],
                                            ),
                                          )
                                        : RichText(
                                            text: TextSpan(
                                              style:
                                                  DefaultTextStyle.of(context)
                                                      .style,
                                              children: [
                                                const WidgetSpan(
                                                  child: Icon(
                                                    Icons.add,
                                                    size: 16,
                                                    color: Colors.green,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text:
                                                      "${values[key]['transactionAmount']}",
                                                  style: TextStyle(
                                                      color: Colors.black
                                                          .withOpacity(0.9)),
                                                ),
                                              ],
                                            ),
                                          ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: RichText(
                                      text: TextSpan(
                                        style:
                                            DefaultTextStyle.of(context).style,
                                        children: [
                                          const TextSpan(
                                            text: "previous balance: ",
                                            style: TextStyle(color: Colors.red),
                                          ),
                                          TextSpan(
                                            text:
                                                "${values[key]['balanceBeforeTransaction']}",
                                            style: TextStyle(
                                                color: Colors.black
                                                    .withOpacity(0.9)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 5.0),
                                    child: RichText(
                                      text: TextSpan(
                                        style:
                                            DefaultTextStyle.of(context).style,
                                        children: [
                                          const TextSpan(
                                            text: "current balance: ",
                                            style:
                                                TextStyle(color: Colors.blue),
                                          ),
                                          TextSpan(
                                            text:
                                                "${values[key]['balanceAfterTransaction']}",
                                            style: TextStyle(
                                                color: Colors.black
                                                    .withOpacity(0.9)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
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
            floatingActionButton: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.bottomRight,
                  child: FloatingActionButton(
                    heroTag: null,
                    onPressed: () {
                      setState(() {
                        _descendingList = !_descendingList;
                      });
                    },
                    tooltip: 'ascending/descending',
                    child: Transform.rotate(
                      angle: 180 * math.pi / 360,
                      child: const Icon(Icons.compare_arrows),
                    ),
                    backgroundColor: Colors.blue.shade300,
                  ),
                ),
              ],
            ),
          );
  }
}
