class Utilisateur {
  int? id; // L'ID de l'utilisateur, null pour les nouveaux utilisateurs
  final String nom;
  final String email;
  final String dateCreation;
  final String? photoPath; // Le chemin de la photo de profil

  Utilisateur({
    this.id, // ID facultatif, il sera généré automatiquement lors de l'insertion
    required this.nom,
    required this.email,
    required this.dateCreation,
    this.photoPath,
  });

  // Conversion de l'objet en Map pour l'enregistrement en BDD
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nom': nom,
      'email': email,
      'dateCreation': dateCreation,
      'photoPath': photoPath,
    };
  }

  // Création d'un objet Utilisateur depuis un Map (reçu depuis la BDD)
  static Utilisateur fromMap(Map<String, dynamic> map) {
    return Utilisateur(
      id: map['id'], // On récupère l'ID ici
      nom: map['nom'],
      email: map['email'],
      dateCreation: map['dateCreation'],
      photoPath: map['photoPath'],
    );
  }
}
