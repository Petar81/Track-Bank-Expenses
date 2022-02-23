/// Bar chart example
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

/// Example of a grouped bar chart with three series, each rendered with
/// different fill colors.
class DaysChart extends StatefulWidget {
  final List<charts.Series<dynamic, String>> seriesList;

  const DaysChart(this.seriesList, {Key? key}) : super(key: key);

  @override
  State<DaysChart> createState() => _DaysChartState();
}

class _DaysChartState extends State<DaysChart> {
  final bool animate = true;

  getNTransactions(int numOfTransactions) async {
    Map<dynamic, dynamic> values = {};
    var keys = [];
    double mondayExpenseSum = 0.00;
    double mondayDepositSum = 0.00;
    double tuesdayExpenseSum = 0.00;
    double tuesdayDepositSum = 0.00;
    double wednesdayExpenseSum = 0.00;
    double wednesdayDepositSum = 0.00;
    double thursdayExpenseSum = 0.00;
    double thursdayDepositSum = 0.00;
    double fridayExpenseSum = 0.00;
    double fridayDepositSum = 0.00;
    double saturdayExpenseSum = 0.00;
    double saturdayDepositSum = 0.00;
    double sundayExpenseSum = 0.00;
    double sundayDepositSum = 0.00;

    Query ref = FirebaseDatabase.instance
        .ref("transactions")
        .limitToLast(numOfTransactions);

// Get the data once
    DatabaseEvent event = await ref.once();

    Map<dynamic, dynamic> data = event.snapshot.value as Map<dynamic, dynamic>;
    values = data;

    keys = (values.keys.toList()..sort());
    //print(keys);

    for (var i = 0; i < keys.length; i++) {
      // MONDAY SUM
      if (DateFormat('EEEE')
                  .format(DateTime.parse(values[keys[i]]['transactionDate'])) ==
              'Monday' &&
          values[keys[i]]['transactionType'] == 'expense') {
        // print(values[keys[i]]['transactionDate']);
        double value = 0.00;
        value = value + values[keys[i]]['transactionAmount'] + .0;
        // print(value);
        mondayExpenseSum = mondayExpenseSum + value;
      } else if (DateFormat('EEEE')
                  .format(DateTime.parse(values[keys[i]]['transactionDate'])) ==
              'Monday' &&
          values[keys[i]]['transactionType'] == 'deposit') {
        double value = 0.00;
        value = value + values[keys[i]]['transactionAmount'] + .0;
        // print(value);
        mondayDepositSum = mondayDepositSum + value;
      }

      // TUESDAY SUM
      if (DateFormat('EEEE')
                  .format(DateTime.parse(values[keys[i]]['transactionDate'])) ==
              'Tuesday' &&
          values[keys[i]]['transactionType'] == 'expense') {
        // print(values[keys[i]]['transactionDate']);
        double value = 0.00;
        value = value + values[keys[i]]['transactionAmount'] + .0;
        // print(value);
        tuesdayExpenseSum = tuesdayExpenseSum + value;
      } else if (DateFormat('EEEE')
                  .format(DateTime.parse(values[keys[i]]['transactionDate'])) ==
              'Tuesday' &&
          values[keys[i]]['transactionType'] == 'deposit') {
        double value = 0.00;
        value = value + values[keys[i]]['transactionAmount'] + .0;
        // print(value);
        tuesdayDepositSum = tuesdayDepositSum + value;
      }

      // WEDNESDAY SUM
      if (DateFormat('EEEE')
                  .format(DateTime.parse(values[keys[i]]['transactionDate'])) ==
              'Wednesday' &&
          values[keys[i]]['transactionType'] == 'expense') {
        // print(values[keys[i]]['transactionDate']);
        double value = 0.00;
        value = value + values[keys[i]]['transactionAmount'] + .0;
        // print(value);
        wednesdayExpenseSum = wednesdayExpenseSum + value;
      } else if (DateFormat('EEEE')
                  .format(DateTime.parse(values[keys[i]]['transactionDate'])) ==
              'Wednesday' &&
          values[keys[i]]['transactionType'] == 'deposit') {
        double value = 0.00;
        value = value + values[keys[i]]['transactionAmount'] + .0;
        // print(value);
        wednesdayDepositSum = wednesdayDepositSum + value;
      }

      // THURSDAY SUM
      if (DateFormat('EEEE')
                  .format(DateTime.parse(values[keys[i]]['transactionDate'])) ==
              'Thursday' &&
          values[keys[i]]['transactionType'] == 'expense') {
        // print(values[keys[i]]['transactionDate']);
        double value = 0.00;
        value = value + values[keys[i]]['transactionAmount'] + .0;
        // print(value);
        thursdayExpenseSum = thursdayExpenseSum + value;
      } else if (DateFormat('EEEE')
                  .format(DateTime.parse(values[keys[i]]['transactionDate'])) ==
              'Thursday' &&
          values[keys[i]]['transactionType'] == 'deposit') {
        double value = 0.00;
        value = value + values[keys[i]]['transactionAmount'] + .0;
        // print(value);
        thursdayDepositSum = thursdayDepositSum + value;
      }

      // FRIDAY SUM
      if (DateFormat('EEEE')
                  .format(DateTime.parse(values[keys[i]]['transactionDate'])) ==
              'Friday' &&
          values[keys[i]]['transactionType'] == 'expense') {
        // print(values[keys[i]]['transactionDate']);
        double value = 0.00;
        value = value + values[keys[i]]['transactionAmount'] + .0;
        // print(value);
        fridayExpenseSum = fridayExpenseSum + value;
      } else if (DateFormat('EEEE')
                  .format(DateTime.parse(values[keys[i]]['transactionDate'])) ==
              'Friday' &&
          values[keys[i]]['transactionType'] == 'deposit') {
        double value = 0.00;
        value = value + values[keys[i]]['transactionAmount'] + .0;
        // print(value);
        fridayDepositSum = fridayDepositSum + value;
      }

      // SATURDAY SUM
      if (DateFormat('EEEE')
                  .format(DateTime.parse(values[keys[i]]['transactionDate'])) ==
              'Saturday' &&
          values[keys[i]]['transactionType'] == 'expense') {
        // print(values[keys[i]]['transactionDate']);
        double value = 0.00;
        value = value + values[keys[i]]['transactionAmount'] + .0;
        // print(value);
        saturdayExpenseSum = saturdayExpenseSum + value;
      } else if (DateFormat('EEEE')
                  .format(DateTime.parse(values[keys[i]]['transactionDate'])) ==
              'Saturday' &&
          values[keys[i]]['transactionType'] == 'deposit') {
        double value = 0.00;
        value = value + values[keys[i]]['transactionAmount'] + .0;
        // print(value);
        saturdayDepositSum = saturdayDepositSum + value;
      }

      // SATURDAY SUM
      if (DateFormat('EEEE')
                  .format(DateTime.parse(values[keys[i]]['transactionDate'])) ==
              'Sunday' &&
          values[keys[i]]['transactionType'] == 'expense') {
        // print(values[keys[i]]['transactionDate']);
        double value = 0.00;
        value = value + values[keys[i]]['transactionAmount'] + .0;
        // print(value);
        sundayExpenseSum = sundayExpenseSum + value;
      } else if (DateFormat('EEEE')
                  .format(DateTime.parse(values[keys[i]]['transactionDate'])) ==
              'Sunday' &&
          values[keys[i]]['transactionType'] == 'deposit') {
        double value = 0.00;
        value = value + values[keys[i]]['transactionAmount'] + .0;
        // print(value);
        sundayDepositSum = sundayDepositSum + value;
      }
    }

    setState(() {
      // WEEKDAY CHART DATA
      weekdayExpenses = [
        WeekDays('Mon', mondayExpenseSum, Colors.red.shade300),
        WeekDays('Tue', tuesdayExpenseSum, Colors.red.shade300),
        WeekDays('Wed', wednesdayExpenseSum, Colors.red.shade300),
        WeekDays('Thu', thursdayExpenseSum, Colors.red.shade300),
        WeekDays('Fri', fridayExpenseSum, Colors.red.shade300),
        WeekDays('Sat', saturdayExpenseSum, Colors.red.shade300),
        WeekDays('Sun', sundayExpenseSum, Colors.red.shade300),
      ];

      weekdayDeposits = [
        WeekDays('Mon', mondayDepositSum, Colors.blue.shade300),
        WeekDays('Tue', tuesdayDepositSum, Colors.blue.shade300),
        WeekDays('Wed', wednesdayDepositSum, Colors.blue.shade300),
        WeekDays('Thu', thursdayDepositSum, Colors.blue.shade300),
        WeekDays('Fri', fridayDepositSum, Colors.blue.shade300),
        WeekDays('Sat', saturdayDepositSum, Colors.blue.shade300),
        WeekDays('Sun', sundayDepositSum, Colors.blue.shade300),
      ];

      // WEEKDAY CHART SERIES DATA
      weekdayChartSeries = [
        // Blue bars with a lighter center color.
        charts.Series<WeekDays, String>(
          id: 'Weekday Expenses',
          domainFn: (WeekDays days, _) => days.day,
          measureFn: (WeekDays total, _) => total.sum,
          data: weekdayExpenses,
          colorFn: (WeekDays weekdayExpenseColor, __) =>
              weekdayExpenseColor.color,
          // fillColorFn: (_, __) =>
          //     charts.MaterialPalette.blue.shadeDefault.lighter,
        ),
        // Solid red bars. Fill color will default to the series color if no
        // fillColorFn is configured.
        charts.Series<WeekDays, String>(
          id: 'Weekday Deposits',
          measureFn: (WeekDays total, _) => total.sum,
          data: weekdayDeposits,
          colorFn: (WeekDays weekdayDepositColor, __) =>
              weekdayDepositColor.color,
          domainFn: (WeekDays days, _) => days.day,
        ),
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'since beginning ',
              style: TextStyle(
                  // fontFamily: 'OpenSansBold',
                  // fontSize: 26.0,
                  ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.arrow_drop_down),
            ),
          ],
        ),
      ),
      body: charts.BarChart(
        widget.seriesList,
        animate: animate,
        // Configure a stroke width to enable borders on the bars.
        defaultRenderer: charts.BarRendererConfig(
            groupingType: charts.BarGroupingType.grouped, strokeWidthPx: 2.0),
      ),
    );
  }
}
