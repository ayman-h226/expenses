// models/portefeuille.dart

class Portefeuille {
  int? id;
  String name;
  double initialBalance;
  String? description;
  DateTime dateCreation;
  double soldeActuel; // Nouveau champ pour le solde actuel

  Portefeuille({
    this.id,
    required this.name,
    required this.initialBalance,
    this.description,
    required this.dateCreation,
    this.soldeActuel = 0.0, // Initialiser le solde actuel à la création
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'initialBalance': initialBalance,
      'description': description,
      'dateCreation': dateCreation.toIso8601String(),
    };
  }

  factory Portefeuille.fromMap(Map<String, dynamic> map) {
    return Portefeuille(
      id: map['id'],
      name: map['name'],
      initialBalance: map['initialBalance'],
      description: map['description'],
      dateCreation: DateTime.parse(map['dateCreation']),
      soldeActuel: map.containsKey('soldeActuel') ? map['soldeActuel'] : 0.0, // Charger le solde actuel si présent
    );
  }
}
