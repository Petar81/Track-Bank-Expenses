import 'package:flutter/material.dart';
import '../models/input_decoration.dart';
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
  String email = '';
  String name = '';
  String pass = '';

  TextEditingController password = TextEditingController();
  TextEditingController confirmpassword = TextEditingController();

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
                        padding: EdgeInsets.only(bottom: 30.0),
                        child: Text("SIGNUP FORM"),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: TextFormField(
                          decoration:
                              buildInputDecoration(Icons.person, "Full Name"),
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
                          decoration:
                              buildInputDecoration(Icons.lock, "Password"),
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
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: ElevatedButton(
                          onPressed: () {
                            // Validate returns true if the form is valid, or false otherwise.
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              // If the form is valid, display a snackbar. In the real world,
                              // you'd often call a server or save the information in a database.
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Processing Data')),
                              );
                              FirebaseAuth auth = FirebaseAuth.instance;
                              () async {
                                try {
                                  await auth.createUserWithEmailAndPassword(
                                      email: email, password: pass);
                                } on FirebaseAuthException catch (e) {
                                  if (e.code == 'weak-password') {
                                    // print('The password provided is too weak.');
                                  } else if (e.code == 'email-already-in-use') {
                                    // print('The account already exists for that email.');
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
                                  // print('User is signed in!');
                                  DatabaseReference userID =
                                      FirebaseDatabase.instance.ref("users");
                                  await userID
                                      .child(user.uid)
                                      .set(
                                          {"displayName": name, "email": email})
                                      .catchError((error) => const Text(
                                          'You got an error! Please try again.'))
                                      .then((value) =>
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
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
