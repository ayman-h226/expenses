// state/utilisateur_provider.dart

import 'package:flutter/material.dart';
import '../models/utilisateur.dart';
import '../services/database_service.dart';

class UtilisateurProvider extends ChangeNotifier {
  List<Utilisateur> _utilisateurs = [];

  List<Utilisateur> get utilisateurs => _utilisateurs;

  // Charger les utilisateurs depuis la base de données
  Future<void> loadUtilisateurs() async {
    _utilisateurs = await DatabaseService().fetchUtilisateurs();
    notifyListeners();  // Notifier les widgets consommateurs
  }

  // Ajouter un nouvel utilisateur
  Future<void> addUtilisateur(Utilisateur utilisateur) async {
    await DatabaseService().insertUtilisateur(utilisateur);
    _utilisateurs.add(utilisateur);
    notifyListeners();
  }

  // Mettre à jour un utilisateur
  Future<void> updateUtilisateur(Utilisateur utilisateur) async {
    await DatabaseService().updateUtilisateur(utilisateur);
    final index = _utilisateurs.indexWhere((u) => u.id == utilisateur.id);
    if (index != -1) {
      _utilisateurs[index] = utilisateur;
      notifyListeners();
    }
  }

  // Supprimer un utilisateur
  Future<void> deleteUtilisateur(int id) async {
    await DatabaseService().deleteUtilisateur(id);
    _utilisateurs.removeWhere((u) => u.id == id);
    notifyListeners();
  }
}
