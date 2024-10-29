import 'package:flutter/material.dart';
import '../models/budget_transaction.dart';

class TransactionListItem extends StatelessWidget {
  final BudgetTransaction transaction;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  final bool isSelected;

  const TransactionListItem({
    required this.transaction,
    required this.onDelete,
    required this.onEdit,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    // Déterminer la couleur du montant : rouge pour les dépenses, vert pour les revenus
    final montantColor = transaction.type == 'dépense' ? Colors.red : Colors.green;

    // Extraire le dernier mot de la catégorie
    String lastWordCategory = transaction.categorie.toString().split('.').last;

    return Card(
      color: isSelected ? Colors.white.withOpacity(0.5) : Colors.white,
      child: ListTile(
        title: Text(
          transaction.description ?? 'Transaction sans description',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                text: 'Montant: ',
                style: DefaultTextStyle.of(context).style,
                children: [
                  TextSpan(
                    text: '${transaction.montant.toStringAsFixed(2)} €',
                    style: TextStyle(color: montantColor),
                  ),
                ],
              ),
            ),
            SizedBox(height: 4.0),
            Text(
              lastWordCategory, // Affiche uniquement le dernier mot de la catégorie
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: onEdit,
            ),
          ],
        ),
      ),
    );
  }
}
