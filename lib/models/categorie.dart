// models/categorie.dart

enum Categorie {
  alimentation,
  transport,
  loisirs,
  logement,
  sante,
  revenu,
}

// Fonction pour obtenir une chaîne de caractères à partir de l'énumération
String getCategorieLabel(Categorie categorie) {
  switch (categorie) {
    case Categorie.alimentation:
      return 'Alimentation';
    case Categorie.transport:
      return 'Transport';
    case Categorie.loisirs:
      return 'Loisirs';
    case Categorie.logement:
      return 'Logement';
    case Categorie.sante:
      return 'Santé';
    case Categorie.revenu:
      return 'Revenu';
    default:
      return 'Inconnu';
  }
}
