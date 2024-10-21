// state/categorie_provider.dart

import 'package:flutter/material.dart';
import '../models/categorie.dart';

class CategorieProvider extends ChangeNotifier {
  Categorie? _selectedCategorie;

  Categorie? get selectedCategorie => _selectedCategorie;

  // Sélectionner une catégorie
  void selectCategorie(Categorie categorie) {
    _selectedCategorie = categorie;
    notifyListeners();  // Notifier les widgets consommateurs
  }

  // Réinitialiser la sélection de la catégorie
  void resetCategorie() {
    _selectedCategorie = null;
    notifyListeners();
  }
}
