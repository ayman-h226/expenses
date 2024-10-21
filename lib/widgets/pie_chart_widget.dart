// widgets/pie_chart_widget.dart

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/budget_transaction.dart';
import '../models/categorie.dart';

class PieChartWidget extends StatelessWidget {
  final List<BudgetTransaction> expenses;

  PieChartWidget({required this.expenses});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.3,
      child: PieChart(
        PieChartData(
          sections: _generateSections(),
          centerSpaceRadius: 40,
          sectionsSpace: 4,
        ),
      ),
    );
  }

  List<PieChartSectionData> _generateSections() {
    Map<Categorie, double> categoryAmounts = {};

    for (var expense in expenses) {
      categoryAmounts.update(expense.categorie, (value) => value + expense.montant, ifAbsent: () => expense.montant);
    }

    return categoryAmounts.entries.map((entry) {
      final percentage = (entry.value / expenses.fold(0.0, (sum, item) => sum + item.montant)) * 100;
      return PieChartSectionData(
        color: _getCategorieColor(entry.key),
        value: entry.value,
        title: '${percentage.toStringAsFixed(1)}%',
        radius: 50,
        titleStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      );
    }).toList();
  }

  Color _getCategorieColor(Categorie categorie) {
    switch (categorie) {
      case Categorie.alimentation:
        return Colors.blue;
      case Categorie.transport:
        return Colors.orange;
      case Categorie.loisirs:
        return Colors.green;
      case Categorie.logement:
        return Colors.purple;
      case Categorie.sante:
        return Colors.red;
      case Categorie.revenu:
        return Colors.yellow; // Non utilisé pour les dépenses
      default:
        return Colors.grey;
    }
  }
}
