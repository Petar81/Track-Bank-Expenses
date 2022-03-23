import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool inputImage = false;
  File? myImage;
  String imgName = '';

  FirebaseAuth auth = FirebaseAuth.instance;

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
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      ElevatedButton.icon(
                        onPressed: () async {
                          await pickImage(ImageSource.gallery);
                          final ref =
                              FirebaseStorage.instance.ref('images/$imgName');
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
                        },
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
