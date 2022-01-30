import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SubmitDeposit extends StatelessWidget {
  final Function(
      double prevBalanceDeposit,
      double currBalanceDeposit,
      double transAmountDeposit,
      String descriptionDeposit,
      String date,
      String time) notifyParentAboutDeposit;
  SubmitDeposit({Key? key, required this.notifyParentAboutDeposit})
      : super(key: key);

  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKeyDeposit = GlobalKey<FormState>();

  final myAmountControllerDeposit = TextEditingController();
  final myDescriptiontControllerDeposit = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Submit Deposit'),
      ),
      body: Center(
          child: Form(
        key: _formKeyDeposit,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: myAmountControllerDeposit,
              decoration:
                  const InputDecoration(labelText: "Please enter the amount"),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a number';
                }
                return null;
              },
            ),
            TextFormField(
              controller: myDescriptiontControllerDeposit,
              maxLength: 30,
              // The validator receives the text that the user has entered.
              decoration:
                  const InputDecoration(hintText: 'Please enter description'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Center(
                child: ElevatedButton(
                  onPressed: () async {
                    String dateDeposit;
                    String timeDeposit;
                    num currentBalanceDeposit;
                    num previousBalanceDeposit;
                    num newCurrentBalanceDeposit;

                    // Reference to currentBalance/currentAmount endpoint
                    DatabaseReference getCurrentBalanceDeposit =
                        FirebaseDatabase.instance
                            .ref("currentBalance/currentAmount");

                    // Get the data once from currentBalance/currentAmount
                    DatabaseEvent event = await getCurrentBalanceDeposit.once();
                    currentBalanceDeposit = event.snapshot.value as num;
                    currentBalanceDeposit = currentBalanceDeposit.toDouble();
                    currentBalanceDeposit =
                        double.parse(currentBalanceDeposit.toStringAsFixed(2));

                    // SAVE PREVIOUS BALANCE IN FIREBASE
                    DatabaseReference previousBalanceRefDeposit =
                        FirebaseDatabase.instance.ref("previousBalance/");
                    await previousBalanceRefDeposit.set({
                      "previousAmount": currentBalanceDeposit,
                    }).catchError((error) =>
                        const Text('You got an error! Please try again.'));

                    // Get the data once from previousBalance/previousAmount
                    DatabaseReference previousBalanceAmountDeposit =
                        FirebaseDatabase.instance
                            .ref("previousBalance/previousAmount");
                    DatabaseEvent evento =
                        await previousBalanceAmountDeposit.once();
                    previousBalanceDeposit = evento.snapshot.value as num;
                    previousBalanceDeposit = previousBalanceDeposit.toDouble();
                    previousBalanceDeposit =
                        double.parse(previousBalanceDeposit.toStringAsFixed(2));

                    // GET THE CURRENT TIMESTAMP
                    var nowDateDeposit = DateTime.now();

                    // FORMAT DATE (yyyy-MM-dd) from a TIMESTAMP
                    var dateFormatter = DateFormat('yyyy-MM-dd');
                    String formattedDateDeposit =
                        dateFormatter.format(nowDateDeposit);
                    dateDeposit = formattedDateDeposit;

                    // FORMAT TIME (hh-mm-ss) from a TIMESTAMP
                    var timeFormatterDeposit = DateFormat.Hms();
                    String formattedTimeDeposit =
                        timeFormatterDeposit.format(nowDateDeposit);
                    timeDeposit = formattedTimeDeposit;

                    // SET EXPENSE RECORD IN FIREBASE
                    DatabaseReference refDeposit = FirebaseDatabase.instance
                        .ref("deposits/$dateDeposit/$timeDeposit");
                    await refDeposit.set({
                      "depositAmount":
                          double.parse(myAmountControllerDeposit.text),
                      "depositDescription":
                          myDescriptiontControllerDeposit.text,
                    }).catchError((error) =>
                        const Text('You got an error! Please try again.'));

                    // UPDATE CURRENT BALANCE IN FIREBASE
                    DatabaseReference currentBalanceRefDeposit =
                        FirebaseDatabase.instance.ref("currentBalance");
                    await currentBalanceRefDeposit.update({
                      "currentAmount": currentBalanceDeposit +
                          double.parse(myAmountControllerDeposit.text),
                    }).catchError((error) =>
                        const Text('You got an error! Please try again.'));

                    // Get the fresh/updated data once from currentBalance/currentAmount
                    DatabaseReference currentBalanceRefkoDeposit =
                        FirebaseDatabase.instance
                            .ref("currentBalance/currentAmount");
                    DatabaseEvent eventko =
                        await currentBalanceRefkoDeposit.once();
                    newCurrentBalanceDeposit = eventko.snapshot.value as num;
                    newCurrentBalanceDeposit =
                        newCurrentBalanceDeposit.toDouble();
                    newCurrentBalanceDeposit = double.parse(
                        newCurrentBalanceDeposit.toStringAsFixed(2));

                    // SET TRANSACTION RECORD IN FIREBASE
                    DatabaseReference transactionDepositRef =
                        FirebaseDatabase.instance.ref("transactions");
                    await transactionDepositRef.push().set({
                      "transactionAmount":
                          double.parse(myAmountControllerDeposit.text),
                      "transactionDescription":
                          myDescriptiontControllerDeposit.text,
                      "balanceBeforeTransaction": currentBalanceDeposit,
                      "balanceAfterTransaction": newCurrentBalanceDeposit,
                      "transactionDate": dateDeposit,
                      "transactionTime": timeDeposit,
                      "transactionType": "deposit",
                    }).catchError((error) =>
                        const Text('You got an error! Please try again.'));

                    // UPDATE LAST TRANSACTION RECORD IN FIREBASE
                    DatabaseReference lastTransaction =
                        FirebaseDatabase.instance.ref("lastTransaction/");
                    await lastTransaction.update({
                      "lastTransactionAmount":
                          double.parse(myAmountControllerDeposit.text),
                      "lastTransactionDescription":
                          myDescriptiontControllerDeposit.text,
                      "lastTransactionDate": dateDeposit,
                      "lastTransactionTime": timeDeposit,
                    }).catchError((error) =>
                        const Text('You got an error! Please try again.'));

                    // Validate returns true if the form is valid, or false otherwise.
                    if (_formKeyDeposit.currentState!.validate()) {
                      Navigator.pop(context);
                      notifyParentAboutDeposit(
                        previousBalanceDeposit.toDouble(),
                        newCurrentBalanceDeposit.toDouble(),
                        double.parse(myAmountControllerDeposit.text),
                        myDescriptiontControllerDeposit.text,
                        dateDeposit.toString(),
                        timeDeposit.toString(),
                      );
                    }
                  },
                  child: const Text('Submit'),
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
