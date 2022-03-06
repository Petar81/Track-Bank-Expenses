import 'package:flutter/material.dart';

class UserAuth extends StatefulWidget {
  final String title;
  const UserAuth({Key? key, required this.title}) : super(key: key);

  @override
  State<UserAuth> createState() => _UserAuthState();
}

class _UserAuthState extends State<UserAuth> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: const Center(
        child: Text('Authentication Form'),
      ),
    );
  }
}
