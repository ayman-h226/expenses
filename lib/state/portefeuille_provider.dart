import 'package:flutter/material.dart';
import '../models/budget_transaction.dart';
import '../models/portefeuille.dart';
import '../services/database_service.dart';

class PortefeuilleProvider extends ChangeNotifier {
  List<Portefeuille> _portefeuilles = [];
  List<BudgetTransaction> _transactions = [];

  List<Portefeuille> get portefeuilles => _portefeuilles;

  // Charger les portefeuilles et les transactions associées depuis la base de données
  Future<void> loadPortefeuilles() async {
    _portefeuilles = await DatabaseService().fetchPortefeuilles();
    for (var portefeuille in _portefeuilles) {
      portefeuille.soldeActuel = getSoldeCourant(portefeuille); // Calcul du solde initial
    }
    notifyListeners();
  }

  // Charger les transactions spécifiques à un portefeuille
  Future<void> loadTransactions(int portefeuilleId) async {
    _transactions = await DatabaseService().fetchTransactions(portefeuilleId);
    notifyListeners();
  }

  // Ajouter un portefeuille
  Future<void> addPortefeuille(Portefeuille portefeuille) async {
    await DatabaseService().insertPortefeuille(portefeuille);
    _portefeuilles.add(portefeuille);
    notifyListeners();
  }

  // Mettre à jour un portefeuille
  Future<void> updatePortefeuille(Portefeuille portefeuille) async {
    await DatabaseService().updatePortefeuille(portefeuille);
    final index = _portefeuilles.indexWhere((p) => p.id == portefeuille.id);
    if (index != -1) {
      _portefeuilles[index] = portefeuille;
      notifyListeners();
    }
  }

  // Supprimer un portefeuille
  Future<void> deletePortefeuille(int portefeuilleId) async {
    await DatabaseService().deletePortefeuille(portefeuilleId);
    _portefeuilles.removeWhere((portefeuille) => portefeuille.id == portefeuilleId);
    notifyListeners();
  }

  // Ajouter une transaction, mettre à jour le solde et notifier les changements
  Future<void> addTransaction(BudgetTransaction transaction) async {
    await DatabaseService().insertTransaction(transaction);
    _transactions.add(transaction);

    // Mettre à jour le solde du portefeuille concerné
    final portefeuille = _portefeuilles.firstWhere((p) => p.id == transaction.portefeuilleId);
    portefeuille.soldeActuel = getSoldeCourant(portefeuille);
    notifyListeners();
  }

  // Mettre à jour une transaction et le solde associé
  Future<void> updateTransaction(BudgetTransaction transaction) async {
    await DatabaseService().updateTransaction(transaction);
    final index = _transactions.indexWhere((t) => t.id == transaction.id);
    if (index != -1) {
      _transactions[index] = transaction;

      // Recalculer le solde
      final portefeuille = _portefeuilles.firstWhere((p) => p.id == transaction.portefeuilleId);
      portefeuille.soldeActuel = getSoldeCourant(portefeuille);
      notifyListeners();
    }
  }

  // Supprimer une transaction et mettre à jour le solde
  Future<void> deleteTransaction(int transactionId) async {
    final transaction = _transactions.firstWhere((t) => t.id == transactionId);
    await DatabaseService().deleteTransaction(transactionId);
    _transactions.remove(transaction);

    // Mettre à jour le solde du portefeuille concerné
    final portefeuille = _portefeuilles.firstWhere((p) => p.id == transaction.portefeuilleId);
    portefeuille.soldeActuel = getSoldeCourant(portefeuille);
    notifyListeners();
  }

  // Calculer le solde courant d'un portefeuille
  double getSoldeCourant(Portefeuille portefeuille) {
    final portefeuilleTransactions = _transactions
        .where((transaction) => transaction.portefeuilleId == portefeuille.id);

    double soldeCourant = portefeuille.initialBalance;
    for (var transaction in portefeuilleTransactions) {
      if (transaction.type == 'revenu') {
        soldeCourant += transaction.montant;
      } else if (transaction.type == 'dépense') {
        soldeCourant -= transaction.montant;
      }
    }
    return soldeCourant;
  }
  // Méthode pour calculer et mettre à jour le solde courant d'un portefeuille
  Future<void> updateSoldeCourant(int portefeuilleId) async {
    // Recharger les transactions pour avoir les dernières données
    _transactions = await DatabaseService().fetchTransactions(portefeuilleId);

    final portefeuille = _portefeuilles.firstWhere((p) => p.id == portefeuilleId);
    if (portefeuille != null) {
      // Calculer le solde courant en fonction des transactions
      double soldeCourant = portefeuille.initialBalance;
      for (var transaction in _transactions) {
        if (transaction.type == 'revenu') {
          soldeCourant += transaction.montant;
        } else if (transaction.type == 'dépense') {
          soldeCourant -= transaction.montant;
        }
      }
      portefeuille.soldeActuel = soldeCourant; // Assurez-vous que `soldeActuel` existe dans le modèle
      notifyListeners(); // Notifier l'interface utilisateur de la mise à jour
    }
  }
}
