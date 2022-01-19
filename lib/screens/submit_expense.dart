import 'package:flutter/material.dart';

class SubmitExpense extends StatelessWidget {
  final Function(double prevBalance, double currBalance, double transAmount)
      notifyParent;
  const SubmitExpense({Key? key, required this.notifyParent}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Submit Expense'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            notifyParent(1100.00, 1090.00, 10.00);
          },
          child: const Text('Go back!'),
        ),
      ),
    );
  }
}
