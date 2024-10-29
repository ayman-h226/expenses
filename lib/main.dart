import 'package:expenses/screens/add_transaction_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/add_portefeuille_screen.dart';
import 'screens/analysis_screen.dart';
import 'screens/edit_profile_screen.dart';
import 'screens/edit_transaction_screen.dart';
import 'screens/portefeuille_screen.dart'; // Portefeuille comme page d'accueil
import 'screens/profile_list_screen.dart';
import 'screens/profile_setup_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/transaction_screen.dart';
import 'screens/welcome_screen.dart';
import 'services/notification_service.dart';
import 'state/notification_provider.dart';
import 'state/portefeuille_provider.dart';
import 'state/transaction_provider.dart';
import 'state/utilisateur_provider.dart';
import 'theme.dart';
import 'services/database_service.dart';
import 'models/budget_transaction.dart'; // Ajout des modèles manquants
import 'models/utilisateur.dart'; // Ajout des modèles manquants

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialiser les notifications
  await NotificationService().initNotifications();

  runApp(MyApp());
}
// Méthode pour vérifier s'il existe un utilisateur enregistré
Future<bool> _checkUserExists() async {
  final utilisateurs = await DatabaseService().fetchUtilisateurs(); // Appelle la méthode dans DatabaseService
  return utilisateurs.isNotEmpty; // Si la liste n'est pas vide, un utilisateur existe
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TransactionProvider()),
        ChangeNotifierProvider(create: (_) => PortefeuilleProvider()..loadPortefeuilles()),
        ChangeNotifierProvider(create: (_) => UtilisateurProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()..loadNotificationSettings()),
      ],
      child: MaterialApp(
        title: 'Budget App',
        theme: AppTheme.lightTheme, // Thème global appliqué
        initialRoute: '/',
        routes: {
          '/': (context) => FutureBuilder(
            future:  _checkUserExists(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else {
                bool userExists = snapshot.data ?? true;
                return userExists ? PortefeuilleScreen() : WelcomeScreen();
              }
            },
          ),
          '/profileSetup': (context) => ProfileSetupScreen(),
          '/portefeuilles': (context) => PortefeuilleScreen(), // Lien vers la page des portefeuilles
          '/transactions': (context) => TransactionScreen(portefeuilleId: ModalRoute.of(context)!.settings.arguments as int),
          '/addTransaction': (context) => AddTransactionScreen(portefeuilleId: ModalRoute.of(context)!.settings.arguments as int),
          '/editTransaction': (context) => EditTransactionScreen(transaction: ModalRoute.of(context)!.settings.arguments as BudgetTransaction),
          '/editProfile': (context) => EditProfileScreen(utilisateur: ModalRoute.of(context)!.settings.arguments as Utilisateur),
          '/addPortefeuille': (context) => AddPortefeuilleScreen(),
          '/profileList': (context) => ProfileListScreen(),
          '/settings': (context) => SettingsScreen(),
          '/analysis': (context) => AnalysisScreen(),
        },
      ),
    );
  }

  Future<bool> _checkFirstLaunch() async {
    final firstLaunch = await DatabaseService().isFirstLaunch(); // Utilisation de SQLite
    return firstLaunch;
  }
}
