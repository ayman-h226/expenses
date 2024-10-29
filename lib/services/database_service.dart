// services/database_service.dart

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/budget_transaction.dart';
import '../models/portefeuille.dart';
import '../models/utilisateur.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;

  static Database? _database;

  DatabaseService._internal();

  // Initialiser la base de données
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Créer et initialiser la base de données
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'budget_app.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Créer la table des portefeuilles
        await db.execute('''
          CREATE TABLE portefeuilles(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            initialBalance REAL,
            description TEXT,
            dateCreation TEXT
          );
        ''');

        // Créer la table des transactions
        await db.execute('''
          CREATE TABLE transactions(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            categorie TEXT,
            montant REAL,
            description TEXT,
            date TEXT,
            type TEXT,
            portefeuilleId INTEGER,
            FOREIGN KEY (portefeuilleId) REFERENCES portefeuilles(id) ON DELETE CASCADE
          );
        ''');

        // Créer la table des utilisateurs
        await db.execute('''
          CREATE TABLE utilisateurs(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nom TEXT,
            email TEXT,
            dateCreation TEXT,
            photoPath TEXT
          );
        ''');

        // Créer la table des préférences de l'application
        await db.execute('''
          CREATE TABLE app_preferences (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            key TEXT,
            value TEXT
          );
        ''');
      },
    );
  }


  // -----------------------------------------------------------
  // Gestion des portefeuilles
  // -----------------------------------------------------------

  Future<void> insertPortefeuille(Portefeuille portefeuille) async {
    final db = await database;
    int id =await db.insert(
      'portefeuilles',
      portefeuille.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    portefeuille.id = id;
    print('Portefeuille inséré avec ID: $id');


  }

// Dans database_service.dart
  Future<List<Portefeuille>> fetchPortefeuilles() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('portefeuilles');

    return List.generate(maps.length, (i) {
      return Portefeuille(
        id: maps[i]['id'],
        name: maps[i]['name'],
        initialBalance: maps[i]['initialBalance'],
        description: maps[i]['description'],
        dateCreation: DateTime.parse(maps[i]['dateCreation']),
      );
    });
  }


  Future<void> updatePortefeuille(Portefeuille portefeuille) async {
    final db = await database;
    await db.update(
      'portefeuilles',
      portefeuille.toMap(),
      where: 'id = ?',
      whereArgs: [portefeuille.id],
    );
  }

  Future<void> deletePortefeuille(int id) async {
    final db = await database;
    await db.delete(
      'portefeuilles',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // -----------------------------------------------------------
  // Gestion des transactions
  // -----------------------------------------------------------

  Future<void> insertTransaction(BudgetTransaction transaction) async {
    final db = await database;
    await db.insert(
      'transactions',
      transaction.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<BudgetTransaction>> fetchTransactions(int portefeuilleId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'transactions',
      where: 'portefeuilleId = ?',
      whereArgs: [portefeuilleId],
    );
    print('${maps.length} transactions trouvées pour le portefeuille $portefeuilleId');
    return List.generate(maps.length, (i) {
      return BudgetTransaction.fromMap(maps[i]);
    });
  }

  Future<void> updateTransaction(BudgetTransaction transaction) async {
    final db = await database;
    await db.update(
      'transactions',
      transaction.toMap(),
      where: 'id = ?',
      whereArgs: [transaction.id],
    );
  }

  Future<void> deleteTransaction(int id) async {
    final db = await database;
    await db.delete(
      'transactions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // -----------------------------------------------------------
  // Gestion des utilisateurs
  // -----------------------------------------------------------

  Future<void> insertUtilisateur(Utilisateur utilisateur) async {
    final db = await database;
    await db.insert(
      'utilisateurs',
      utilisateur.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Utilisateur>> fetchUtilisateurs() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('utilisateurs');
    return List.generate(maps.length, (i) {
      return Utilisateur.fromMap(maps[i]);
    });
  }

  Future<void> updateUtilisateur(Utilisateur utilisateur) async {
    final db = await database;
    await db.update(
      'utilisateurs',
      utilisateur.toMap(),
      where: 'id = ?',
      whereArgs: [utilisateur.id],
    );
  }

  Future<void> deleteUtilisateur(int id) async {
    final db = await database;
    await db.delete(
      'utilisateurs',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // -----------------------------------------------------------
  // Gestion des préférences de l'application
  // -----------------------------------------------------------

  Future<void> setPreference(String key, String value) async {
    final db = await database;
    await db.insert(
      'app_preferences',
      {'key': key, 'value': value},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<String?> getPreference(String key) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      'app_preferences',
      where: 'key = ?',
      whereArgs: [key],
    );
    if (result.isEmpty) {
      return null;
    }
    return result.first['value'];
  }

  // services/database_service.dart

  Future<void> setPreferredLanguage(String language) async {
    final db = await database;
    await db.insert(
      'app_preferences',
      {
        'key': 'preferredLanguage',
        'value': language,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<String> getPreferredLanguage() async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      'app_preferences',
      where: 'key = ?',
      whereArgs: ['preferredLanguage'],
    );
    if (result.isEmpty) {
      return 'Français';  // Langue par défaut
    }
    return result.first['value'] as String;
  }

// services/database_service.dart

  Future<void> setNotificationsEnabled(bool isEnabled) async {
    final db = await database;
    await db.insert(
      'app_preferences',
      {
        'key': 'notificationsEnabled',
        'value': isEnabled ? 'true' : 'false',
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<bool> isNotificationsEnabled() async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      'app_preferences',
      where: 'key = ?',
      whereArgs: ['notificationsEnabled'],
    );
    if (result.isEmpty) {
      return true; // Par défaut, les notifications sont activées
    }
    return result.first['value'] == 'true';
  }

  // Méthode pour vérifier si c'est le premier lancement
  Future<bool> isFirstLaunch() async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      'app_preferences',
      where: 'key = ?',
      whereArgs: ['firstLaunch'],
    );
    if (result.isEmpty) {
      // Si aucune entrée n'est trouvée, on considère que c'est le premier lancement
      return true;
    }
    return result.first['value'] == 'true';
  }

  // Méthode pour définir le premier lancement à "false"
  Future<void> setFirstLaunch(bool isFirstLaunch) async {
    final db = await database;
    await db.insert(
      'app_preferences',
      {
        'key': 'firstLaunch',
        'value': isFirstLaunch ? 'true' : 'false',
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
