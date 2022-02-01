import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

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
