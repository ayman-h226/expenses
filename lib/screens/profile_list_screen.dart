// screens/profile_list_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/utilisateur_provider.dart';
import '../models/utilisateur.dart';
import '../widgets/profile_card.dart';

class ProfileListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mes Profils'),
      ),
      body: Consumer<UtilisateurProvider>(
        builder: (context, utilisateurProvider, child) {
          if (utilisateurProvider.utilisateurs.isEmpty) {
            return Center(
              child: Text(
                'Aucun profil trouvé. Vous pouvez en ajouter un.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          return ListView.builder(
            itemCount: utilisateurProvider.utilisateurs.length,
            itemBuilder: (context, index) {
              final utilisateur = utilisateurProvider.utilisateurs[index];
              return ProfileCard(
                utilisateur: utilisateur,
                onEdit: () {
                  Navigator.pushNamed(
                    context,
                    '/editProfile',
                    arguments: utilisateur,
                  );
                },
                onDelete: () {
                  _showDeleteDialog(context, utilisateurProvider, utilisateur);
                },
              );
            },
          );
        },
      ),
    );
  }

  // Boîte de dialogue pour confirmer la suppression
  void _showDeleteDialog(BuildContext context, UtilisateurProvider provider, Utilisateur utilisateur) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Supprimer le profil'),
          content: Text('Voulez-vous vraiment supprimer ce profil ?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                provider.deleteUtilisateur(utilisateur.id!);
                Navigator.of(context).pop();
              },
              child: Text('Oui'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Non'),
            ),
          ],
        );
      },
    );
  }
}
