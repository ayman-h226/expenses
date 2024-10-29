// screens/analysis_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/transaction_provider.dart';
import '../widgets/pie_chart_widget.dart';
import '../widgets/bar_chart_widget.dart';

class AnalysisScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Analyse des Transactions'),
      ),
      body: Consumer<TransactionProvider>(
        builder: (context, transactionProvider, child) {
          if (transactionProvider.transactions.isEmpty) {
            return Center(child: Text('Aucune donnée disponible pour l\'analyse.'));
          }

          // Filtrer les transactions par type et catégorie pour les graphiques
          final expenses = transactionProvider.transactions.where((t) => t.type == 'dépense').toList();
          final revenues = transactionProvider.transactions.where((t) => t.type == 'revenu').toList();

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    'Dépenses par Catégorie',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  PieChartWidget(expenses: expenses), // Camembert pour les dépenses
                  SizedBox(height: 32),
                  Text(
                    'Revenus vs Dépenses par Mois',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  BarChartWidget(expenses: expenses, revenues: revenues), // Graphique à barres
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
