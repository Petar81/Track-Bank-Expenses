import 'package:flutter/material.dart';

class SubmitExpense extends StatelessWidget {
  final Function(double prevBalance, double currBalance, double transAmount)
      notifyParent;
  SubmitExpense({Key? key, required this.notifyParent}) : super(key: key);

  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

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
                  onPressed: () {
                    // Validate returns true if the form is valid, or false otherwise.
                    if (_formKey.currentState!.validate()) {
                      Navigator.pop(context);
                      notifyParent(1100.00, 1090.00, 10.00);
                      // If the form is valid, display a snackbar. In the real world,
                      // you'd often call a server or save the information in a database.
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Processing Data')),
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
