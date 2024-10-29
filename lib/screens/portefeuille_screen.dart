import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/portefeuille.dart';
import '../state/portefeuille_provider.dart';
import '../state/utilisateur_provider.dart'; // Ajouter le provider utilisateur
import '../widgets/portefeuille_card.dart';
import '../widgets/header.dart';
import 'edit_portefeuille_screen.dart'; // Assurez-vous d’importer l’écran d’édition

class PortefeuilleScreen extends StatefulWidget {
  @override
  _PortefeuilleScreenState createState() => _PortefeuilleScreenState();
}

class _PortefeuilleScreenState extends State<PortefeuilleScreen> {
  bool _isDeleting = false; // Indicateur pour le mode suppression
  List<int> _selectedPortefeuilles = []; // Liste des portefeuilles sélectionnés pour suppression

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 32),
            Consumer<UtilisateurProvider>(
              builder: (context, utilisateurProvider, child) {
                final utilisateur = utilisateurProvider.utilisateurs.isNotEmpty
                    ? utilisateurProvider.utilisateurs.first
                    : null;

                return Header(
                  pageName: 'Portefeuilles',
                  userName: utilisateur?.nom ?? 'Nom Inconnu',
                  userPhotoPath: utilisateur?.photoPath,
                );
              },
            ),
            const SizedBox(height: 20),
            if (_isDeleting) // Message d'instruction
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Sélectionnez les portefeuilles à supprimer',
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
              ),
            Expanded(
              child: Consumer<PortefeuilleProvider>(
                builder: (context, portefeuilleProvider, child) {
                  if (portefeuilleProvider.portefeuilles.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'Aucun portefeuille trouvé.\nAppuyez sur le bouton "+" pour en ajouter un.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: portefeuilleProvider.portefeuilles.length,
                    itemBuilder: (context, index) {
                      final portefeuille = portefeuilleProvider.portefeuilles[index];
                      final isSelected = _selectedPortefeuilles.contains(portefeuille.id);

                      return GestureDetector(
                        onTap: _isDeleting
                            ? () {
                          setState(() {
                            if (isSelected) {
                              _selectedPortefeuilles.remove(portefeuille.id);
                            } else {
                              _selectedPortefeuilles.add(portefeuille.id!);
                            }
                          });
                        }
                            : () {
                          if (portefeuille.id != null) {
                            Navigator.pushNamed(
                              context,
                              '/transactions',
                              arguments: portefeuille.id,
                            );
                          } else {
                            print('Erreur : Portefeuille ID est null');
                          }
                        },
                        child: PortefeuilleCard(
                          portefeuille: portefeuille,
                          isSelected: isSelected,
                          onEdit: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditPortefeuilleScreen(portefeuille: portefeuille),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: _isDeleting && _selectedPortefeuilles.isNotEmpty
            ? SizedBox(
          width: double.infinity,
          child: FloatingActionButton.extended(
            onPressed: () {
              _showDeleteConfirmationDialog(context);
            },
            backgroundColor: Colors.red.shade400,
            icon: Icon(Icons.delete),
            label: Text('Supprimer (${_selectedPortefeuilles.length})'),
          ),
        )
            : Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 30.0),
              child: FloatingActionButton(
                heroTag: 'deleteButton',
                onPressed: () {
                  setState(() {
                    _isDeleting = !_isDeleting;
                    _selectedPortefeuilles.clear();
                  });
                },
                backgroundColor: Colors.red.shade400,
                child: Icon(_isDeleting ? Icons.cancel : Icons.remove),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 30.0),
              child: FloatingActionButton(
                heroTag: 'addButton',
                onPressed: () {
                  Navigator.pushNamed(context, '/addPortefeuille');
                },
                child: Icon(Icons.add),
                backgroundColor: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmer la suppression'),
          content: Text('Voulez-vous vraiment supprimer les portefeuilles sélectionnés ?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                final provider = Provider.of<PortefeuilleProvider>(context, listen: false);
                for (int id in _selectedPortefeuilles) {
                  provider.deletePortefeuille(id);
                }
                setState(() {
                  _isDeleting = false;
                  _selectedPortefeuilles.clear();
                });
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
