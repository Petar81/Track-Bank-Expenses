import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import '../models/input_decoration.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  FirebaseAuth auth = FirebaseAuth.instance;
  // GET A REFERENCE OF USER
  User? user = FirebaseAuth.instance.currentUser;
  final _updateNameKey = GlobalKey<FormState>();
  final _updateEmailKey = GlobalKey<FormState>();
  TextEditingController updateNameControler = TextEditingController();
  TextEditingController updateEmailControler = TextEditingController();
  bool inputImage = false;
  File? myImage;
  String imgName = '';
  String avatarUrl = '';

  @override
  void initState() {
    super.initState();
    onStart();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void onStart() async {
    // Reference to users/user.uid/avatarURL endpoint
    DatabaseReference refAvatarURL =
        FirebaseDatabase.instance.ref("users/${user!.uid}/avatarURL/");

    // Get the data once from users/user.uid/avatarURL
    DatabaseEvent avatarURLRef = await refAvatarURL.once();
    if (avatarURLRef.snapshot.value != null) {
      final avatarURLSnapshot = avatarURLRef.snapshot.value as String;
      avatarUrl = avatarURLSnapshot;
    } else {
      avatarUrl = '';
    }

    setState(() {
      avatarUrl = avatarUrl;
    });
  }

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

  Future uploadFile() async {
    if (myImage == null) return null;
    const destination = 'images/';
    final ref = FirebaseStorage.instance.ref(destination);
    ref.putFile(myImage!);
  }

  @override
  Widget build(BuildContext context) {
    // get user and userID
    User? user = auth.currentUser;
    DatabaseReference userID = FirebaseDatabase.instance.ref("users");

    return Scaffold(
      appBar: AppBar(
        title: const Text('Track Bank Expenses'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.only(bottom: 10.0),
                  child: Text(
                    "Update personal info",
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
                const Divider(
                  height: 10,
                  thickness: 1,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      ElevatedButton.icon(
                        onPressed: () async {
                          await pickImage(ImageSource.gallery);
                          final ref =
                              FirebaseStorage.instance.ref('images/$imgName');
                          if (myImage != null) {
                            await ref.putFile(myImage!);
                            final avatarURL = await ref.getDownloadURL();
                            await userID
                                .child(user!.uid)
                                .update({"avatarURL": avatarURL})
                                .catchError((error) => const Text(
                                    'You got an error! Please try again.'))
                                .then((value) => ScaffoldMessenger.of(context)
                                  ..hideCurrentSnackBar()
                                  ..showSnackBar(const SnackBar(
                                    duration: Duration(seconds: 3),
                                    content: Text(
                                        'Avatar image has been successfully updated!'),
                                  )));
                          } else {
                            return;
                          }
                        },
                        icon: const Icon(Icons.image),
                        label: const Text('upload'),
                      ),
                      if (myImage != null)
                        ClipOval(
                          child: Image.file(
                            myImage!,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        )
                      else if (avatarUrl != '')
                        CircleAvatar(
                          backgroundImage: NetworkImage(avatarUrl),
                          radius: 50,
                        )
                      else
                        const CircleAvatar(
                          backgroundImage: NetworkImage(
                              'https://firebasestorage.googleapis.com/v0/b/track-bank-expenses.appspot.com/o/images%2Favatar_placeholder.webp?alt=media&token=aa4c0ac9-012e-4e20-b9ca-e36a47d3773e'),
                          radius: 50,
                        ),
                      ElevatedButton.icon(
                        onPressed: () async {
                          await pickImage(ImageSource.camera);
                          final ref =
                              FirebaseStorage.instance.ref('images/$imgName');
                          if (myImage != null) {
                            await ref.putFile(myImage!);
                            final avatarURL = await ref.getDownloadURL();
                            await userID
                                .child(user!.uid)
                                .update({"avatarURL": avatarURL})
                                .catchError((error) => const Text(
                                    'You got an error! Please try again.'))
                                .then((value) => ScaffoldMessenger.of(context)
                                  ..hideCurrentSnackBar()
                                  ..showSnackBar(const SnackBar(
                                    duration: Duration(seconds: 3),
                                    content: Text(
                                        'Avatar image has been successfully updated!'),
                                  )));
                          } else {
                            return;
                          }
                        },
                        icon: const Icon(Icons.camera_alt),
                        label: const Text('take'),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 30),
                      child: Form(
                        key: _updateNameKey,
                        child: SizedBox(
                          width: 250,
                          child: TextFormField(
                            controller: updateNameControler,
                            decoration: buildInputDecoration(
                                Icons.person, "Update Name"),
                            // The validator receives the text that the user has entered.
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your name';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_updateNameKey.currentState!.validate()) {
                          _updateNameKey.currentState!.save();
                          () async {
                            DatabaseReference userID =
                                FirebaseDatabase.instance.ref("users");

                            await userID
                                .child(user!.uid)
                                .update({
                                  "displayName":
                                      updateNameControler.text.trim(),
                                  // "avatarURL": myImage
                                })
                                .catchError((error) => const Text(
                                    'You got an error! Please try again.'))
                                .then((value) {
                                  ScaffoldMessenger.of(context)
                                    ..hideCurrentSnackBar()
                                    ..showSnackBar(const SnackBar(
                                      duration: Duration(seconds: 3),
                                      content: Text(
                                          'Name has been successfully updated!'),
                                    ));
                                });
                          }();
                        }
                      },
                      child: const Text('update'),
                    ),
                  ],
                ),
                const Divider(
                  height: 10,
                  thickness: 1,
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: Text(
                    "Account settings",
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 30),
                      child: Form(
                        key: _updateEmailKey,
                        child: SizedBox(
                          width: 250,
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            controller: updateEmailControler,
                            decoration: buildInputDecoration(
                                Icons.email, "Update Email"),
                            // The validator receives the text that the user has entered.
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
                          ),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_updateEmailKey.currentState!.validate()) {
                          _updateEmailKey.currentState!.save();
                          () async {
                            try {
                              await user!
                                  .updateEmail(updateEmailControler.text.trim())
                                  .then((value) => ScaffoldMessenger.of(context)
                                    ..hideCurrentSnackBar()
                                    ..showSnackBar(const SnackBar(
                                      duration: Duration(seconds: 3),
                                      content: Text(
                                          'Name has been successfully updated!'),
                                    )));
                            } on FirebaseAuthException catch (e) {
                              if (e.code == 'invalid-email') {
                                ScaffoldMessenger.of(context)
                                  ..hideCurrentSnackBar()
                                  ..showSnackBar(const SnackBar(
                                    duration: Duration(seconds: 3),
                                    content: Text('Invalid email!'),
                                  ));
                              } else if (e.code == 'email-already-in-use') {
                                ScaffoldMessenger.of(context)
                                  ..hideCurrentSnackBar()
                                  ..showSnackBar(const SnackBar(
                                    duration: Duration(seconds: 3),
                                    content: Text('Email already in use!'),
                                  ));
                              } else if (e.code == 'requires-recent-login') {
                                ScaffoldMessenger.of(context)
                                  ..hideCurrentSnackBar()
                                  ..showSnackBar(const SnackBar(
                                    duration: Duration(seconds: 3),
                                    content: Text(
                                        'You must logout first, then login back to perform this action.'),
                                  ));
                              }
                            }

                            DatabaseReference userID =
                                FirebaseDatabase.instance.ref("users");

                            await userID
                                .child(user!.uid)
                                .update({
                                  "displayName":
                                      updateNameControler.text.trim(),
                                  // "avatarURL": myImage
                                })
                                .catchError((error) => const Text(
                                    'You got an error! Please try again.'))
                                .then((value) {
                                  ScaffoldMessenger.of(context)
                                    ..hideCurrentSnackBar()
                                    ..showSnackBar(const SnackBar(
                                      duration: Duration(seconds: 3),
                                      content: Text(
                                          'Name has been successfully updated!'),
                                    ));
                                });
                          }();
                        }
                      },
                      child: const Text('update'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
