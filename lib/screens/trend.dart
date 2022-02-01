import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class Trend extends StatefulWidget {
  const Trend({Key? key}) : super(key: key);

  @override
  State<Trend> createState() => _TrendState();
}

class _TrendState extends State<Trend> {
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
