import 'package:flutter/material.dart';

class Trend extends StatelessWidget {
  const Trend({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trend overview'),
      ),
      body: const Center(
        child: Text('Trend Screen'),
      ),
    );
  }
}
