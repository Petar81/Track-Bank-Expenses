import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:track_bank_expenses/screens/login.dart';
import '../models/input_decoration.dart';
import '../screens/balance_overview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
// import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

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
  File? myImage;
  String imgName = '';

  TextEditingController password = TextEditingController();
  TextEditingController confirmpassword = TextEditingController();

  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return null;
      final imageTemporary = File(image.path);
      final imageName = basename(image.path);
      // final imagePermanent = await saveImagePermanently(image.path);
      setState(() {
        myImage = imageTemporary;
        inputImage = !inputImage;
        imgName = imageName;
      });
    } on PlatformException catch (e) {
      return e.message;
    }
  }

  // Future<File> saveImagePermanently(String imagePath) async {
  //   final directory = await getApplicationDocumentsDirectory();
  //   final name = basename(imagePath);
  //   final image = File('${directory.path}/$name');

  //   return File(imagePath).copy(image.path);
  // }

  Future uploadFile() async {
    if (myImage == null) return null;
    const destination = 'images/';
    final ref = FirebaseStorage.instance.ref(destination);
    ref.putFile(myImage!);
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
                              onPressed: () => pickImage(ImageSource.gallery),
                              icon: const Icon(Icons.image),
                              label: const Text('upload'),
                            ),
                            myImage != null
                                ? ClipOval(
                                    child: Image.file(
                                      myImage!,
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : const CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        'https://firebasestorage.googleapis.com/v0/b/track-bank-expenses.appspot.com/o/images%2Favatar_placeholder.webp?alt=media&token=aa4c0ac9-012e-4e20-b9ca-e36a47d3773e'),
                                    radius: 50,
                                  ),
                            ElevatedButton.icon(
                              onPressed: () => pickImage(ImageSource.camera),
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
                              return 'Please enter a valid Email';
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
                                    await userID
                                        .child(value.user!.uid)
                                        .set({
                                          "displayName": name,
                                          "email": email,
                                          // "avatarURL": myImage
                                        })
                                        .catchError((error) => const Text(
                                            'You got an error! Please try again.'))
                                        .then((_) async {
                                          if (myImage != null) {
                                            final ref = FirebaseStorage.instance
                                                .ref('images/$imgName');
                                            await ref.putFile(myImage!);
                                            final avatarURL =
                                                await ref.getDownloadURL();
                                            await userID
                                                .child(value.user!.uid)
                                                .update({
                                              "avatarURL": avatarURL,
                                              "imageName": imgName,
                                            }).catchError((error) => const Text(
                                                    'You got an error! Please try again.'));
                                          } else {
                                            return;
                                          }
                                        });
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
