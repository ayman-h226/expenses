// state/transaction_provider.dart

import 'package:flutter/material.dart';
import '../models/budget_transaction.dart';
import '../services/database_service.dart';

class TransactionProvider extends ChangeNotifier {
  List<BudgetTransaction> _transactions = [];

  List<BudgetTransaction> get transactions => _transactions;

  Future<void> loadTransactions(int portefeuilleId) async {
    print('Chargement des transactions pour le portefeuille ID: $portefeuilleId');
    final db = await DatabaseService().database;
    final result = await db.query(
      'transactions',
      where: 'portefeuilleId = ?',
      whereArgs: [portefeuilleId],
    );
    print('${result.length} transactions trouvées pour le portefeuille $portefeuilleId');

    _transactions = result.map((map) => BudgetTransaction.fromMap(map)).toList();
    print('Transactions récupérées : $_transactions');

    notifyListeners();
  }


  // Ajouter une transaction
  Future<void> addTransaction(BudgetTransaction transaction) async {
    await DatabaseService().insertTransaction(transaction);
    _transactions.add(transaction);
    notifyListeners();
  }

  // Mettre à jour une transaction
  Future<void> updateTransaction(BudgetTransaction transaction) async {
    await DatabaseService().updateTransaction(transaction);
    final index = _transactions.indexWhere((t) => t.id == transaction.id);
    if (index != -1) {
      _transactions[index] = transaction;
      notifyListeners();
    }
  }

  // Supprimer une transaction
  Future<void> deleteTransaction(int id) async {
    await DatabaseService().deleteTransaction(id);
    _transactions.removeWhere((t) => t.id == id);
    notifyListeners();
  }
}
