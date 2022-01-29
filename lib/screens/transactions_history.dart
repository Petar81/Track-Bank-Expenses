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

  getDeposits() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("deposits");

// Get the data once
    DatabaseEvent event = await ref.once();

    Map<dynamic, dynamic> data = event.snapshot.value as Map<dynamic, dynamic>;
    values = data;

    // data.forEach((key, value) {
    //   print(key);
    //   value.forEach((key, value) {
    //     print('$key $value');
    //   });
    // });

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                height: 100,
                //color: Colors.amber.shade300,
                child: ListTile(
                  leading: 10 < 3
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
                  title: Text(values.length.toString()),
                  subtitle: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text('${values[key]}'),
                        ],
                      ),
                      Row(
                        children: const <Widget>[
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(top: 5),
                              child: Text('oioio'),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: const <Widget>[
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(top: 5),
                              child: Text('previous balance: 344.77'),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: const <Widget>[
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(top: 5.0),
                              child: Text('current balance: 9898.90'),
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
