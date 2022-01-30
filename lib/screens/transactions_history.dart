import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class TransactionsHistory extends StatefulWidget {
  const TransactionsHistory({Key? key}) : super(key: key);

  @override
  State<TransactionsHistory> createState() => _TransactionsHistoryState();
}

class _TransactionsHistoryState extends State<TransactionsHistory> {
  @override
  void initState() {
    super.initState();
    getDeposits();
  }

  Map<dynamic, dynamic> values = {};
  bool _isLoading = true;

  getDeposits() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("transactions");

// Get the data once
    DatabaseEvent event = await ref.once();

    Map<dynamic, dynamic> data = event.snapshot.value as Map<dynamic, dynamic>;
    values = data;

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
                    String key = values.keys.elementAt(index);
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
                                            style:
                                                TextStyle(color: Colors.orange),
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
                                                TextStyle(color: Colors.green),
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
          );
  }
}
