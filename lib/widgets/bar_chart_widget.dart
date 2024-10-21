// widgets/bar_chart_widget.dart

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/budget_transaction.dart';

class BarChartWidget extends StatelessWidget {
  final List<BudgetTransaction> expenses;
  final List<BudgetTransaction> revenues;

  BarChartWidget({required this.expenses, required this.revenues});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.7,
      child: BarChart(
        BarChartData(
          barGroups: _generateBarGroups(),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(),
            bottomTitles: AxisTitles(),
          ),
        ),
      ),
    );
  }

  List<BarChartGroupData> _generateBarGroups() {
    // Filtrer et regrouper les dépenses et revenus par mois
    Map<int, double> monthlyExpenses = {};
    Map<int, double> monthlyRevenues = {};

    for (var expense in expenses) {
      monthlyExpenses.update(expense.date.month, (value) => value + expense.montant, ifAbsent: () => expense.montant);
    }

    for (var revenue in revenues) {
      monthlyRevenues.update(revenue.date.month, (value) => value + revenue.montant, ifAbsent: () => revenue.montant);
    }

    List<BarChartGroupData> barGroups = [];

    for (int month = 1; month <= 12; month++) {
      final expense = monthlyExpenses[month] ?? 0.0;
      final revenue = monthlyRevenues[month] ?? 0.0;

      barGroups.add(
        BarChartGroupData(
          x: month,
          barRods: [
            BarChartRodData(
              toY: revenue,
              color: Colors.green,
              width: 8,
            ),
            BarChartRodData(
              toY: expense,
              color: Colors.red,
              width: 8,
            ),
          ],
          showingTooltipIndicators: [0],
        ),
      );
    }

    return barGroups;
  }
}
