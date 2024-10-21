// models/budget_transaction.dart

import 'categorie.dart';

class BudgetTransaction {
  final int? id;
  final int portefeuilleId;  // ID du portefeuille auquel cette transaction est associée
  final Categorie categorie; // Enum pour la catégorie de la transaction
  final double montant;
  final String description;
  final DateTime date;
  final String type;  // "dépense" ou "revenu"

  BudgetTransaction({
    this.id,
    required this.portefeuilleId,
    required this.categorie,
    required this.montant,
    required this.description,
    required this.date,
    required this.type,
  });

  // Méthode pour convertir une transaction en Map (pour SQLite)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'portefeuilleId': portefeuilleId,
      'categorie': categorie.toString().split('.').last, // Enregistrer comme chaîne de caractères
      'montant': montant,
      'description': description,
      'date': date.toIso8601String(), // Format ISO pour la date
      'type': type,
    };
  }

  // Méthode pour créer une transaction à partir d'un Map (SQLite -> Objet)
  static BudgetTransaction fromMap(Map<String, dynamic> map) {
    return BudgetTransaction(
      id: map['id'],
      portefeuilleId: map['portefeuilleId'],
      categorie: getCategorieFromString(map['categorie']),
      montant: map['montant'],
      description: map['description'],
      date: DateTime.parse(map['date']),
      type: map['type'],
    );
  }
}

// Fonction pour obtenir la catégorie à partir d'une chaîne de caractères
Categorie getCategorieFromString(String categorie) {
  return Categorie.values.firstWhere((e) => e.toString().split('.').last == categorie);
}
