import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:track_bank_expenses/screens/settings.dart';
import 'firebase_options.dart';

import './screens/balance_overview.dart';
import './screens/login.dart';

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
    // auth.currentUser!.reload();
    // await auth.signOut();

    User? user = auth.currentUser;
    // print(user!.email);

    return (user != null)
        ? MaterialApp(
            routes: {
              '/balance': (BuildContext context) => const BalanceOverview(
                    title: 'Track Bank Expenses',
                  ),
              '/settings': (BuildContext context) => const Settings(),
            },
            title: 'Track Bank Expenses',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: const BalanceOverview(title: 'Track Bank Expenses'),
          )
        : MaterialApp(
            routes: {
              '/balance': (BuildContext context) => const BalanceOverview(
                    title: 'Track Bank Expenses',
                  ),
              '/settings': (BuildContext context) => const Settings(),
            },
            title: 'Track Bank Expenses',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: const Login(title: 'Track Bank Expenses'),
          );
  }
}
