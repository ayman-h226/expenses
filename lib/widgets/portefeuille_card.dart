import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/portefeuille.dart';
import '../state/portefeuille_provider.dart';

class PortefeuilleCard extends StatelessWidget {
  final Portefeuille portefeuille;
  final VoidCallback? onTap; // Action lorsqu'on appuie sur la carte (ex: pour sélectionner)
  final VoidCallback? onEdit; // Action lorsqu'on appuie sur l'icône d'édition
  final bool isSelected; // Indique si le portefeuille est sélectionné

  const PortefeuilleCard({
    required this.portefeuille,
    this.onTap,
    this.onEdit,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final portefeuilleProvider = Provider.of<PortefeuilleProvider>(context);
    final soldeCourant = portefeuilleProvider.getSoldeCourant(portefeuille);

    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 10.0,
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        color: isSelected ? Colors.white.withOpacity(0.5) : Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Informations du portefeuille
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    portefeuille.name,
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Solde initial : ${portefeuille.initialBalance.toStringAsFixed(2)} €',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey[700],
                    ),
                  ),
                  Text(
                    'Solde actuel : ${soldeCourant.toStringAsFixed(2)} €',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: soldeCourant < 0 ? Colors.red : Colors.grey[700],
                    ),
                  ),
                  if (portefeuille.description != null )
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        portefeuille.description.toString(),
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  SizedBox(height: 10.0),
                  Text(
                    'Date de création : ${portefeuille.dateCreation.toString().split(' ')[0]}',
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              // Icône de modification
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: onEdit, // Appelle la fonction de modification
              ),
            ],
          ),
        ),
      ),
    );
  }
}
