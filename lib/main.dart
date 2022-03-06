import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

import './screens/balance_overview.dart';
import './screens/user_auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    () async {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: "barry.allen@example.com", password: "SuperSecretPassword!");
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          // print('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          // print('Wrong password provided for that user.');
        }
      }
    }();
    FirebaseAuth auth = FirebaseAuth.instance;
    auth.currentUser!.reload();
    User? user = auth.currentUser;
    // print(user!.email);

    return (user != null && !user.emailVerified)
        ? MaterialApp(
            title: 'Transactions Tracker',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: const BalanceOverview(title: 'Transactions Tracker'),
          )
        : MaterialApp(
            title: 'Transactions Tracker',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: const UserAuth(title: 'Transactions Tracker'),
          );
  }
}
