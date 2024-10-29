// screens/edit_portefeuille_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/portefeuille.dart';
import '../state/portefeuille_provider.dart';
import '../widgets/header.dart'; // Import du header
import 'package:provider/provider.dart';
import '../state/utilisateur_provider.dart';


class EditPortefeuilleScreen extends StatefulWidget {
  final Portefeuille portefeuille;

  EditPortefeuilleScreen({required this.portefeuille});

  @override
  _EditPortefeuilleScreenState createState() => _EditPortefeuilleScreenState();
}

class _EditPortefeuilleScreenState extends State<EditPortefeuilleScreen> {
  late TextEditingController _nameController;
  late TextEditingController _balanceController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.portefeuille.name);
    _balanceController = TextEditingController(text: widget.portefeuille.initialBalance.toString());
    _descriptionController = TextEditingController(text: widget.portefeuille.description);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 32),

            // Consommer le provider pour récupérer les données utilisateur
            Consumer<UtilisateurProvider>(
              builder: (context, utilisateurProvider, child) {
                final utilisateur = utilisateurProvider.utilisateurs.isNotEmpty
                    ? utilisateurProvider.utilisateurs.first
                    : null;

                return Header(
                  pageName: 'Modifier le Portefeuille',
                  userName: utilisateur?.nom ?? 'Nom Inconnu',
                  userPhotoPath: utilisateur?.photoPath,
                );
              },
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Nom du Portefeuille',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: _balanceController,
                      decoration: InputDecoration(
                        labelText: 'Solde Initial',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        await _updatePortefeuille(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                        child: Text('Sauvegarder les modifications', style: TextStyle(fontSize: 18)),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _updatePortefeuille(BuildContext context) async {
    final name = _nameController.text;
    final balance = double.tryParse(_balanceController.text) ?? 0.0;
    final description = _descriptionController.text;

    if (name.isEmpty || balance <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veuillez entrer un nom valide et un solde initial positif.')),
      );
      return;
    }

    final updatedPortefeuille = Portefeuille(
      id: widget.portefeuille.id,  // Conserver l'ID du portefeuille existant
      name: name,
      initialBalance: balance,
      description: description,
      dateCreation: widget.portefeuille.dateCreation, // Garder la date de création initiale
    );

    // Appeler la méthode de mise à jour via le provider
    await Provider.of<PortefeuilleProvider>(context, listen: false).updatePortefeuille(updatedPortefeuille);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Portefeuille mis à jour avec succès !')),
    );

    Navigator.pop(context);  // Retour à la liste des portefeuilles
  }
}
