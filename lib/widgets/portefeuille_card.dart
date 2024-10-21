import 'package:flutter/material.dart';
import '../models/portefeuille.dart';

class PortefeuilleCard extends StatelessWidget {
  final Portefeuille portefeuille;
  final VoidCallback? onTap; // Action lorsqu'on appuie sur la carte (ex: pour éditer)

  const PortefeuilleCard({required this.portefeuille, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 3.0,
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
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
              if (portefeuille.description != null && portefeuille.description!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    portefeuille.description!,
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              SizedBox(height: 10.0),
              Text(
                'Date de création : ${portefeuille.dateCreation.toLocal()}'.split(' ')[0],
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
