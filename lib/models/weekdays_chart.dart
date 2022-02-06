import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class WeekDays {
  final String day;
  final double sum;
  final charts.Color color;

  WeekDays(this.day, this.sum, Color color)
      : color = charts.Color(
            r: color.red, g: color.green, b: color.blue, a: color.alpha);
}
