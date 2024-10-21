// screens/transaction_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/budget_transaction.dart';
import '../state/transaction_provider.dart';
import '../widgets/transaction_list_item.dart';

enum TransactionFilter { all, depenses, revenus }

class TransactionScreen extends StatefulWidget {
  final int portefeuilleId;

  // Constructeur avec le portefeuilleId en paramètre
  TransactionScreen({required this.portefeuilleId});

  @override
  _TransactionScreenState createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  TransactionFilter _selectedFilter = TransactionFilter.all;

  @override
  Widget build(BuildContext context) {
    // Récupérer l'ID du portefeuille depuis les arguments de la navigation
    final int portefeuilleId = ModalRoute.of(context)!.settings.arguments as int;

    return Scaffold(
      appBar: AppBar(
        title: Text('Transactions'),
        actions: [
          PopupMenuButton<TransactionFilter>(
            onSelected: (TransactionFilter result) {
              setState(() {
                _selectedFilter = result;
              });
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<TransactionFilter>>[
              const PopupMenuItem<TransactionFilter>(
                value: TransactionFilter.all,
                child: Text('Toutes les transactions'),
              ),
              const PopupMenuItem<TransactionFilter>(
                value: TransactionFilter.depenses,
                child: Text('Dépenses uniquement'),
              ),
              const PopupMenuItem<TransactionFilter>(
                value: TransactionFilter.revenus,
                child: Text('Revenus uniquement'),
              ),
            ],
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              // Naviguer vers l'écran d'ajout de transaction en passant l'ID du portefeuille
              Navigator.pushNamed(context, '/addTransaction', arguments: portefeuilleId);
            },
          ),
        ],
      ),
      body: Consumer<TransactionProvider>(
        builder: (context, transactionProvider, child) {
          return FutureBuilder(
            // Passer l'ID du portefeuille ici pour charger les transactions associées
            future: transactionProvider.loadTransactions(portefeuilleId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (transactionProvider.transactions.isEmpty) {
                return Center(child: Text('Aucune transaction trouvée.'));
              } else {
                List<BudgetTransaction> filteredTransactions = _getFilteredTransactions(transactionProvider.transactions);

                return ListView.builder(
                  itemCount: filteredTransactions.length,
                  itemBuilder: (context, index) {
                    final transaction = filteredTransactions[index];
                    return TransactionListItem(
                      transaction: transaction,
                      onDelete: () => _showDeleteDialog(context, transactionProvider, transaction),
                      onEdit: () {
                        Navigator.pushNamed(
                          context,
                          '/editTransaction',
                          arguments: transaction,
                        );
                      },
                    );
                  },
                );
              }
            },
          );
        },
      ),
    );
  }

  // Filtrer les transactions par type (toutes, dépenses, revenus)
  List<BudgetTransaction> _getFilteredTransactions(List<BudgetTransaction> transactions) {
    if (_selectedFilter == TransactionFilter.depenses) {
      return transactions.where((t) => t.type == 'dépense').toList();
    } else if (_selectedFilter == TransactionFilter.revenus) {
      return transactions.where((t) => t.type == 'revenu').toList();
    } else {
      return transactions; // Retourner toutes les transactions
    }
  }

  // Boîte de dialogue pour confirmer la suppression
  void _showDeleteDialog(BuildContext context, TransactionProvider provider, BudgetTransaction transaction) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Supprimer la transaction'),
          content: Text('Voulez-vous vraiment supprimer cette transaction ?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                provider.deleteTransaction(transaction.id!);
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
