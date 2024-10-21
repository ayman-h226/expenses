// widgets/transaction_list_item.dart

import 'package:flutter/material.dart';
import '../models/budget_transaction.dart';
import '../models/categorie.dart';

class TransactionListItem extends StatelessWidget {
  final BudgetTransaction transaction;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  TransactionListItem({
    required this.transaction,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(transaction.description),
      subtitle: Text(
        '${getCategorieLabel(transaction.categorie)} - ${transaction.date.toLocal()}'.split(' ')[0],
      ),
      trailing: Text(
        '${transaction.montant.toStringAsFixed(2)} €',
        style: TextStyle(
          color: transaction.type == 'revenu' ? Colors.green : Colors.red,
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: onEdit,
      onLongPress: onDelete,
    );
  }
}
