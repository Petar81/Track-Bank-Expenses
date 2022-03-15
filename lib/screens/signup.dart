import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:track_bank_expenses/screens/login.dart';
import '../models/input_decoration.dart';
import '../screens/balance_overview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class Signup extends StatefulWidget {
  final String title;
  const Signup({Key? key, required this.title}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String name = '';
  String pass = '';
  bool inputImage = false;
  String myImage = '';
  File? image;

  TextEditingController password = TextEditingController();
  TextEditingController confirmpassword = TextEditingController();

  Future pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return null;
    final imageTemporary = File(image.path);
    this.image = imageTemporary;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      const Padding(
                        padding: EdgeInsets.only(bottom: 10.0),
                        child: Text(
                          "SIGNUP FORM",
                          style: TextStyle(fontSize: 20.0),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const Text(
                              "Already registered?",
                              style: TextStyle(fontSize: 14.0),
                            ),
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const Login(
                                          title: 'Track Bank Expenses'),
                                    ),
                                  );
                                },
                                child: const Text('LOGIN'))
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            ElevatedButton.icon(
                              onPressed: () => pickImage(),
                              icon: const Icon(Icons.image),
                              label: const Text('upload'),
                            ),
                            inputImage
                                ? CircleAvatar(
                                    backgroundImage: NetworkImage(myImage),
                                    radius: 50,
                                  )
                                : const CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        'https://cdn.pixabay.com/photo/2016/08/08/09/17/avatar-1577909_960_720.png'),
                                    radius: 50,
                                  ),
                            ElevatedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.camera_alt),
                              label: const Text('take'),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: TextFormField(
                          decoration:
                              buildInputDecoration(Icons.person, "Full Name"),
                          // The validator receives the text that the user has entered.
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            name = value!;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          decoration:
                              buildInputDecoration(Icons.email, "Email"),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter an email';
                            }
                            if (!RegExp(
                                    "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                                .hasMatch(value)) {
                              return 'Please a valid Email';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            email = value!;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: TextFormField(
                          controller: password,
                          obscureText: true,
                          keyboardType: TextInputType.text,
                          decoration:
                              buildInputDecoration(Icons.lock, "Password"),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a password';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            pass = value!;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: TextFormField(
                          controller: confirmpassword,
                          obscureText: true,
                          keyboardType: TextInputType.text,
                          decoration: buildInputDecoration(
                              Icons.lock, "Confirm Password"),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please re-enter password';
                            }
                            // print(password.text);
                            // print(confirmpassword.text);

                            if (password.text != confirmpassword.text) {
                              return "Password does not match";
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: ElevatedButton(
                          onPressed: () async {
                            // Validate returns true if the form is valid, or false otherwise.
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              // If the form is valid, display a snackbar. In the real world,
                              // you'd often call a server or save the information in a database.
                              ScaffoldMessenger.of(context)
                                ..hideCurrentSnackBar()
                                ..showSnackBar(
                                  const SnackBar(
                                      duration: Duration(seconds: 2),
                                      content: Text('Processing Data')),
                                );
                              FirebaseAuth auth = FirebaseAuth.instance;
                              // User? user = auth.currentUser;
                              await Future.delayed(const Duration(seconds: 1));
                              () async {
                                try {
                                  DatabaseReference userID =
                                      FirebaseDatabase.instance.ref("users");
                                  await auth
                                      .createUserWithEmailAndPassword(
                                          email: email, password: pass)
                                      .then((value) async {
                                    await userID.child(value.user!.uid).set({
                                      "displayName": name,
                                      "email": email
                                    }).catchError((error) => const Text(
                                        'You got an error! Please try again.'));
                                    // Reference to currentBalance/currentAmount endpoint
                                    DatabaseReference initializeCurrentBalance =
                                        FirebaseDatabase.instance.ref(
                                            "users/${value.user!.uid}/currentBalance/");
                                    await initializeCurrentBalance.set({
                                      "currentAmount": 0.00,
                                    }).catchError((error) => const Text(
                                        'You got an error! Please try again.'));
                                    // Reference to previousBalance/previousAmount endpoint
                                    DatabaseReference
                                        initializePreviousBalance =
                                        FirebaseDatabase.instance.ref(
                                            "users/${value.user!.uid}/previousBalance/");
                                    await initializePreviousBalance.set({
                                      "previousAmount": 0.00,
                                    }).catchError((error) => const Text(
                                        'You got an error! Please try again.'));
                                  }).then((_) => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const BalanceOverview(
                                                      title:
                                                          'Track Bank Expenses'),
                                            ),
                                          ));
                                } on FirebaseAuthException catch (e) {
                                  if (e.code == 'weak-password') {
                                    ScaffoldMessenger.of(context)
                                      ..hideCurrentSnackBar()
                                      ..showSnackBar(const SnackBar(
                                        duration: Duration(seconds: 3),
                                        content: Text('Weak password!'),
                                      ));
                                  } else if (e.code == 'email-already-in-use') {
                                    ScaffoldMessenger.of(context)
                                      ..hideCurrentSnackBar()
                                      ..showSnackBar(const SnackBar(
                                        duration: Duration(seconds: 3),
                                        content: Text('Email already in use!'),
                                      ));
                                  } else if (e.code == 'invalid-email') {
                                    ScaffoldMessenger.of(context)
                                      ..hideCurrentSnackBar()
                                      ..showSnackBar(const SnackBar(
                                        duration: Duration(seconds: 3),
                                        content: Text('Invalid email!'),
                                      ));
                                  }
                                } catch (e) {
                                  // print(e);
                                }
                              }();
                            }
                          },
                          child: const Text('Submit'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
