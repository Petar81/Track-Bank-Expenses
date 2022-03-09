import 'package:flutter/material.dart';
import '../models/input_decoration.dart';
import '../screens/balance_overview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class UserAuth extends StatefulWidget {
  final String title;
  const UserAuth({Key? key, required this.title}) : super(key: key);

  @override
  State<UserAuth> createState() => _UserAuthState();
}

class _UserAuthState extends State<UserAuth> {
  final _formKey = GlobalKey<FormState>();
  final _loginFormKey = GlobalKey<FormState>();
  String email = '';
  String loginEmail = '';
  String name = '';
  String pass = '';
  String loginPass = '';
  bool signUP = false;
  bool logIN = true;

  TextEditingController password = TextEditingController();
  TextEditingController confirmpassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return logIN
        ? Scaffold(
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
                                        setState(() {
                                          logIN = !logIN;
                                          signUP = !signUP;
                                        });
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
                                    return 'Please a Enter';
                                  }
                                  if (!RegExp(
                                          "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                                      .hasMatch(value)) {
                                    return 'Please a valid Email';
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
                                decoration: buildInputDecoration(
                                    Icons.lock, "Password"),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please Enter a Password';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  loginPass = value!;
                                },
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  // Validate returns true if the form is valid, or false otherwise.
                                  if (_loginFormKey.currentState!.validate()) {
                                    _loginFormKey.currentState!.save();
                                    // If the form is valid, display a snackbar. In the real world,
                                    // you'd often call a server or save the information in a database.
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          duration: Duration(seconds: 2),
                                          content: Text('Processing Data')),
                                    );
                                    () async {
                                      try {
                                        await FirebaseAuth.instance
                                            .signInWithEmailAndPassword(
                                                email: loginEmail,
                                                password: loginPass);
                                      } on FirebaseAuthException catch (e) {
                                        if (e.code == 'user-not-found') {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                            duration: Duration(seconds: 3),
                                            content:
                                                Text('Wrong email address!'),
                                          ));
                                        } else if (e.code == 'wrong-password') {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                            duration: Duration(seconds: 2),
                                            content: Text('Wrong password!'),
                                          ));
                                        }
                                      }
                                    }();

                                    FirebaseAuth.instance
                                        .authStateChanges()
                                        .listen((User? user) async {
                                      if (user == null) {
                                        setState(() {
                                          signUP = !signUP;
                                        });
                                      } else {
                                        () async {
                                          // Reference to user display name
                                          DatabaseReference userDisplayName =
                                              FirebaseDatabase.instance.ref(
                                                  "users/${user.uid}/displayName");

                                          // Get the data once from currentBalance/currentAmount
                                          DatabaseEvent event =
                                              await userDisplayName.once();
                                          return event.snapshot.value as String;
                                        }()
                                            .then(
                                          (userName) =>
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                            SnackBar(
                                              duration:
                                                  const Duration(seconds: 3),
                                              content: Text(
                                                  '$userName is logged in'),
                                            ),
                                          ),
                                        );
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const BalanceOverview(
                                                    title:
                                                        'Transactions Tracker!'),
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
          )
        : Scaffold(
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
                                        setState(() {
                                          logIN = !logIN;
                                          signUP = !signUP;
                                        });
                                      },
                                      child: const Text('LOGIN'))
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: TextFormField(
                                decoration: buildInputDecoration(
                                    Icons.person, "Full Name"),
                                // The validator receives the text that the user has entered.
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter some text';
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
                                    return 'Please a Enter';
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
                                decoration: buildInputDecoration(
                                    Icons.lock, "Password"),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please Enter a Password';
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
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  // Validate returns true if the form is valid, or false otherwise.
                                  if (_formKey.currentState!.validate()) {
                                    _formKey.currentState!.save();
                                    // If the form is valid, display a snackbar. In the real world,
                                    // you'd often call a server or save the information in a database.
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          duration: Duration(seconds: 2),
                                          content: Text('Processing Data')),
                                    );
                                    FirebaseAuth auth = FirebaseAuth.instance;
                                    () async {
                                      try {
                                        await auth
                                            .createUserWithEmailAndPassword(
                                                email: email, password: pass);
                                      } on FirebaseAuthException catch (e) {
                                        if (e.code == 'weak-password') {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                            duration: Duration(seconds: 3),
                                            content: Text('Weak password!'),
                                          ));
                                        } else if (e.code ==
                                            'email-already-in-use') {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                            duration: Duration(seconds: 3),
                                            content:
                                                Text('Email already in use!'),
                                          ));
                                        }
                                      } catch (e) {
                                        // print(e);
                                      }
                                    }();

                                    FirebaseAuth.instance
                                        .authStateChanges()
                                        .listen((User? user) async {
                                      if (user == null) {
                                        // print('User is currently signed out!');
                                      } else {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const BalanceOverview(
                                                    title:
                                                        'Transactions Tracker!'),
                                          ),
                                        );
                                        // print('User is signed in!');
                                        DatabaseReference userID =
                                            FirebaseDatabase.instance
                                                .ref("users");
                                        await userID
                                            .child(user.uid)
                                            .set({
                                              "displayName": name,
                                              "email": email
                                            })
                                            .catchError((error) => const Text(
                                                'You got an error! Please try again.'))
                                            .then((value) =>
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                      duration: const Duration(
                                                          seconds: 3),
                                                      content: Text(
                                                          'User $name has been created')),
                                                ));
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
