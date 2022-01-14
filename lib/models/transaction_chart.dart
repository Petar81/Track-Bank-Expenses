import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class TransactionChart {
  final String transactionType;
  final int transactionAmount;
  final charts.Color color;

  TransactionChart(this.transactionType, this.transactionAmount, Color color)
      : color = charts.Color(
            r: color.red, g: color.green, b: color.blue, a: color.alpha);
}
