// state/portefeuille_provider.dart

import 'package:flutter/material.dart';
import '../models/portefeuille.dart';
import '../services/database_service.dart';

class PortefeuilleProvider extends ChangeNotifier {
  List<Portefeuille> _portefeuilles = [];

  List<Portefeuille> get portefeuilles => _portefeuilles;

  // Charger tous les portefeuilles depuis la base de données
  Future<void> loadPortefeuilles() async {
    _portefeuilles = await DatabaseService().fetchPortefeuilles();
    notifyListeners();  // Notifier les widgets consommateurs de ce changement
  }

  // Ajouter un nouveau portefeuille
  Future<void> addPortefeuille(Portefeuille portefeuille) async {
    await DatabaseService().insertPortefeuille(portefeuille);
    _portefeuilles.add(portefeuille);
    notifyListeners();  // Mettre à jour l'UI après l'ajout
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
  Future<void> deletePortefeuille(int id) async {
    await DatabaseService().deletePortefeuille(id);
    _portefeuilles.removeWhere((p) => p.id == id);
    notifyListeners();
  }
}
