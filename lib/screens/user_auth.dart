import 'package:flutter/material.dart';

class UserAuth extends StatefulWidget {
  const UserAuth({Key? key}) : super(key: key);

  @override
  State<UserAuth> createState() => _UserAuthState();
}

class _UserAuthState extends State<UserAuth> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Authentication Screen'),
      ),
      body: const Center(
        child: Text('Authentication Form'),
      ),
    );
  }
}
