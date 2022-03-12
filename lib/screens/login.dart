import 'package:flutter/material.dart';
import '../models/input_decoration.dart';
import '../screens/balance_overview.dart';
import '../screens/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class Login extends StatefulWidget {
  final String title;
  const Login({Key? key, required this.title}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _loginFormKey = GlobalKey<FormState>();
  String loginEmail = '';
  String loginPass = '';
  String username = '';

  TextEditingController password = TextEditingController();

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
                  key: _loginFormKey,
                  child: Column(
                    children: <Widget>[
                      const Padding(
                        padding: EdgeInsets.only(bottom: 10.0),
                        child: Text(
                          "LOGIN",
                          style: TextStyle(fontSize: 20.0),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const Text(
                              "Not registered yet?",
                              style: TextStyle(fontSize: 14.0),
                            ),
                            TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const Signup(
                                          title: 'Track Bank Expenses'),
                                    ),
                                  );
                                },
                                child: const Text('SIGNUP'))
                          ],
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
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            loginEmail = value!;
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
                              return 'Please enter a valid password';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            loginPass = value!;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: ElevatedButton(
                          onPressed: () async {
                            // Validate returns true if the form is valid, or false otherwise.
                            if (_loginFormKey.currentState!.validate()) {
                              _loginFormKey.currentState!.save();
                              // If the form is valid, display a snackbar. In the real world,
                              // you'd often call a server or save the information in a database.
                              ScaffoldMessenger.of(context)
                                ..hideCurrentSnackBar()
                                ..showSnackBar(
                                  const SnackBar(
                                      duration: Duration(seconds: 2),
                                      content: Text('Processing Data')),
                                );
                              await Future.delayed(const Duration(seconds: 1));
                              () async {
                                try {
                                  await FirebaseAuth.instance
                                      .signInWithEmailAndPassword(
                                          email: loginEmail,
                                          password: loginPass);
                                } on FirebaseAuthException catch (e) {
                                  if (e.code == 'user-not-found') {
                                    ScaffoldMessenger.of(context)
                                      ..hideCurrentSnackBar()
                                      ..showSnackBar(const SnackBar(
                                        duration: Duration(seconds: 3),
                                        content: Text('User not found!'),
                                      ));
                                  } else if (e.code == 'wrong-password') {
                                    ScaffoldMessenger.of(context)
                                      ..hideCurrentSnackBar()
                                      ..showSnackBar(const SnackBar(
                                        duration: Duration(seconds: 2),
                                        content: Text('Wrong password!'),
                                      ));
                                  } else if (e.code == 'invalid-email') {
                                    ScaffoldMessenger.of(context)
                                      ..hideCurrentSnackBar()
                                      ..showSnackBar(const SnackBar(
                                        duration: Duration(seconds: 2),
                                        content: Text('Invalid email address!'),
                                      ));
                                  } else if (e.code == 'user-disabled') {
                                    ScaffoldMessenger.of(context)
                                      ..hideCurrentSnackBar()
                                      ..showSnackBar(const SnackBar(
                                        duration: Duration(seconds: 2),
                                        content: Text(
                                            'This user has been disabled!'),
                                      ));
                                  }
                                }
                              }();

                              FirebaseAuth.instance
                                  .userChanges()
                                  .listen((User? user) async {
                                user = FirebaseAuth.instance.currentUser;
                                if (user == null) {
                                  // print('user not authenticated');
                                } else {
                                  DatabaseReference getUserName =
                                      FirebaseDatabase.instance.ref(
                                          "users/${user.uid}/displayName/");

                                  // Get the data once from users/user.uid/displayName
                                  DatabaseEvent userNameRef =
                                      await getUserName.once();
                                  final userNameSnapshot =
                                      userNameRef.snapshot.value as String;

                                  username = userNameSnapshot;
                                  ScaffoldMessenger.of(context)
                                    ..hideCurrentSnackBar()
                                    ..showSnackBar(
                                      SnackBar(
                                        duration: const Duration(seconds: 3),
                                        content: Text('$username is logged in'),
                                      ),
                                    );
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const BalanceOverview(
                                              title: 'Track Bank Expenses'),
                                    ),
                                  );
                                }
                              });
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
