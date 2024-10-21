// models/portefeuille.dart

class Portefeuille {
  final int? id;
  final String name;
  final double initialBalance;
  final String description;
  final DateTime dateCreation;

  Portefeuille({
    this.id,
    required this.name,
    required this.initialBalance,
    required this.description,
    required this.dateCreation,
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

  static Portefeuille fromMap(Map<String, dynamic> map) {
    return Portefeuille(
      id: map['id'],
      name: map['name'],
      initialBalance: map['initialBalance'],
      description: map['description'],
      dateCreation: DateTime.parse(map['dateCreation']),
    );
  }
}
