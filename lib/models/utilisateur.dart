// models/utilisateur.dart

class Utilisateur {
  final int? id;
  final String nom;
  final String email;
  final String? dateCreation;

  Utilisateur({
    this.id,
    required this.nom,
    required this.email,
    this.dateCreation,
  });

  // Convertir l'utilisateur en map (pour l'insertion en base de données)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nom': nom,
      'email': email,
      'dateCreation': dateCreation,
    };
  }

  // Récupérer un utilisateur à partir d'un map (lors de la lecture depuis la base de données)
  static Utilisateur fromMap(Map<String, dynamic> map) {
    return Utilisateur(
      id: map['id'],
      nom: map['nom'],
      email: map['email'],
      dateCreation: map['dateCreation'],
    );
  }
}
