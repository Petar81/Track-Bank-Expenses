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
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    return (user != null && !user.emailVerified)
        ? MaterialApp(
            title: 'Bank expense tracker',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: const BalanceOverview(title: 'Bank expense tracker'),
          )
        : MaterialApp(
            title: 'Bank expense tracker',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: const UserAuth(),
          );
  }
}
