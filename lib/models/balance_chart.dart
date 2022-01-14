import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class BalanceChart {
  final String balanceType;
  final double balanceAmount;
  final charts.Color color;

  BalanceChart(this.balanceType, this.balanceAmount, Color color)
      : color = charts.Color(
            r: color.red, g: color.green, b: color.blue, a: color.alpha);
}
