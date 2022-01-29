import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SubmitExpense extends StatelessWidget {
  final Function(double prevBalance, double currBalance, double transAmount,
      String description, String date, String time) notifyParentAboutExpense;
  SubmitExpense({Key? key, required this.notifyParentAboutExpense})
      : super(key: key);

  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  final myAmountController = TextEditingController();
  final myDescriptiontController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Submit Expense'),
      ),
      body: Center(
          child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: myAmountController,
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
              controller: myDescriptiontController,
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
                    String date;
                    String time;
                    num currentBalance;
                    num previousBalance;
                    num newCurrentBalance;

                    // Reference to currentBalance/currentAmount endpoint
                    DatabaseReference getCurrentBalance = FirebaseDatabase
                        .instance
                        .ref("currentBalance/currentAmount");

                    // Get the data once from currentBalance/currentAmount
                    DatabaseEvent event = await getCurrentBalance.once();
                    currentBalance = event.snapshot.value as num;
                    currentBalance = currentBalance.toDouble();
                    currentBalance =
                        double.parse(currentBalance.toStringAsFixed(2));

                    // SAVE PREVIOUS BALANCE IN FIREBASE
                    DatabaseReference previousBalanceRef =
                        FirebaseDatabase.instance.ref("previousBalance/");
                    await previousBalanceRef.set({
                      "previousAmount": currentBalance,
                    }).catchError((error) =>
                        const Text('You got an error! Please try again.'));

                    // Get the data once from previousBalance/previousAmount
                    DatabaseReference previousBalanceAmount = FirebaseDatabase
                        .instance
                        .ref("previousBalance/previousAmount");
                    DatabaseEvent evento = await previousBalanceAmount.once();
                    previousBalance = evento.snapshot.value as num;
                    previousBalance = previousBalance.toDouble();
                    previousBalance =
                        double.parse(previousBalance.toStringAsFixed(2));

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

                    // SET EXPENSE RECORD IN FIREBASE
                    DatabaseReference ref =
                        FirebaseDatabase.instance.ref("expenses/$date/$time");
                    await ref.set({
                      "expenseAmount": double.parse(myAmountController.text),
                      "expenseDescription": myDescriptiontController.text,
                    }).catchError((error) =>
                        const Text('You got an error! Please try again.'));

                    // UPDATE CURRENT BALANCE IN FIREBASE
                    DatabaseReference currentBalanceRef =
                        FirebaseDatabase.instance.ref("currentBalance");
                    await currentBalanceRef.update({
                      "currentAmount": currentBalance -
                          double.parse(myAmountController.text),
                    }).catchError((error) =>
                        const Text('You got an error! Please try again.'));

                    // Get the fresh/updated data once from currentBalance/currentAmount
                    DatabaseReference currentBalanceRefko = FirebaseDatabase
                        .instance
                        .ref("currentBalance/currentAmount");
                    DatabaseEvent eventko = await currentBalanceRefko.once();
                    newCurrentBalance = eventko.snapshot.value as num;
                    newCurrentBalance = newCurrentBalance.toDouble();
                    newCurrentBalance =
                        double.parse(newCurrentBalance.toStringAsFixed(2));

                    // SET TRANSACTION RECORD IN FIREBASE
                    DatabaseReference transactionExpenseRef =
                        FirebaseDatabase.instance.ref("transactions");
                    await transactionExpenseRef.push().set({
                      "transactionAmount":
                          double.parse(myAmountController.text),
                      "transactionDescription": myDescriptiontController.text,
                      "balanceBeforeTransaction": currentBalance,
                      "balanceAfterTransaction": newCurrentBalance,
                      "transactionDate": date,
                      "transactionTime": time,
                      "transactionType": "expense",
                    }).catchError((error) =>
                        const Text('You got an error! Please try again.'));

                    // UPDATE LAST TRANSACTION RECORD IN FIREBASE
                    DatabaseReference lastTransaction =
                        FirebaseDatabase.instance.ref("lastTransaction/");
                    await lastTransaction.update({
                      "lastTransactionAmount":
                          double.parse(myAmountController.text),
                      "lastTransactionDescription":
                          myDescriptiontController.text,
                      "lastTransactionDate": date,
                      "lastTransactionTime": time,
                    }).catchError((error) =>
                        const Text('You got an error! Please try again.'));

                    // Validate returns true if the form is valid, or false otherwise.
                    if (_formKey.currentState!.validate()) {
                      Navigator.pop(context);
                      notifyParentAboutExpense(
                        previousBalance.toDouble(),
                        newCurrentBalance.toDouble(),
                        double.parse(myAmountController.text),
                        myDescriptiontController.text,
                        date.toString(),
                        time.toString(),
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
