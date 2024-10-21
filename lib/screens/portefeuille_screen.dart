import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/portefeuille.dart';
import '../state/portefeuille_provider.dart';
import '../widgets/portefeuille_card.dart';
import '../widgets/status_bar.dart';
import '../widgets/wallet_header.dart';

class PortefeuilleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Couleur de fond
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const StatusBar(), // Bar d'état (heure, batterie, etc.)
              const SizedBox(height: 32), // Espacement
              WalletHeader(), // En-tête personnalisé du portefeuille
              const SizedBox(height: 37), // Espacement
              Consumer<PortefeuilleProvider>(
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
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(), // Pour éviter les conflits avec le scrolling parent
                    itemCount: portefeuilleProvider.portefeuilles.length,
                    itemBuilder: (context, index) {
                      final portefeuille = portefeuilleProvider.portefeuilles[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/transactions',
                            arguments: portefeuille.id,
                          );
                        },
                        child: PortefeuilleCard(portefeuille: portefeuille),
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 16), // Espacement supplémentaire en bas
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/addPortefeuille');
        },
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor, // Couleur du bouton flottant
      ),
    );
  }
}
