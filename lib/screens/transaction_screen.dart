import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/budget_transaction.dart';
import '../state/transaction_provider.dart';
import '../state/utilisateur_provider.dart';
import '../widgets/transaction_list_item.dart';
import '../widgets/header.dart';

enum TransactionFilter { all, depenses, revenus }

class TransactionScreen extends StatefulWidget {
  final int portefeuilleId;

  TransactionScreen({required this.portefeuilleId});

  @override
  _TransactionScreenState createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  TransactionFilter _selectedFilter = TransactionFilter.all;
  bool _isDeleting = false;
  List<int> _selectedTransactions = [];

  @override
  Widget build(BuildContext context) {
    final int portefeuilleId = widget.portefeuilleId;
    print('Portefeuille ID reçu: $portefeuilleId');

    return Scaffold(
      backgroundColor: Colors.white,
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
                  pageName: 'Transactions',
                  userName: utilisateur?.nom ?? 'Nom Inconnu',
                  userPhotoPath: utilisateur?.photoPath,
                );
              },
            ),
            const SizedBox(height: 20),

            if (_isDeleting)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Sélectionnez les transactions à supprimer',
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
              ),

            Expanded(
              child: Consumer<TransactionProvider>(
                builder: (context, transactionProvider, child) {
                  return FutureBuilder(
                    future: transactionProvider.loadTransactions(portefeuilleId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Erreur lors du chargement des transactions.'));
                      } else if (transactionProvider.transactions.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Aucune transaction trouvée.'),
                              SizedBox(height: 10),
                              Text('Appuyez sur le bouton "+" pour en ajouter une.'),
                            ],
                          ),
                        );
                      } else {
                        List<BudgetTransaction> filteredTransactions = _getFilteredTransactions(transactionProvider.transactions);
                        return ListView.builder(
                          itemCount: filteredTransactions.length,
                          itemBuilder: (context, index) {
                            final transaction = filteredTransactions[index];
                            final isSelected = _selectedTransactions.contains(transaction.id!);

                            return GestureDetector(
                              onTap: _isDeleting
                                  ? () {
                                setState(() {
                                  if (isSelected) {
                                    _selectedTransactions.remove(transaction.id);
                                  } else {
                                    _selectedTransactions.add(transaction.id!);
                                  }
                                });
                              }
                                  : null,
                              child: TransactionListItem(
                                transaction: transaction,
                                isSelected: isSelected,
                                onDelete: () => _showDeleteDialog(context, transactionProvider, transaction),
                                onEdit: () {
                                  Navigator.pushNamed(context, '/editTransaction', arguments: transaction);
                                },
                              ),
                            );
                          },
                        );
                      }
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
        child: _isDeleting && _selectedTransactions.isNotEmpty
            ? SizedBox(
          width: double.infinity,
          child: FloatingActionButton.extended(
            onPressed: () {
              _showDeleteConfirmationDialog(context);
            },
            backgroundColor: Colors.red.shade400,
            icon: Icon(Icons.delete),
            label: Text('Supprimer (${_selectedTransactions.length})'),
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
                    _selectedTransactions.clear();
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
                  Navigator.pushNamed(context, '/addTransaction', arguments: portefeuilleId);
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

  // Filtrer les transactions par type (toutes, dépenses, revenus)
  List<BudgetTransaction> _getFilteredTransactions(List<BudgetTransaction> transactions) {
    if (_selectedFilter == TransactionFilter.depenses) {
      return transactions.where((t) => t.type == 'dépense').toList();
    } else if (_selectedFilter == TransactionFilter.revenus) {
      return transactions.where((t) => t.type == 'revenu').toList();
    } else {
      return transactions;
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

  // Boîte de dialogue de confirmation de suppression
  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmer la suppression'),
          content: Text('Voulez-vous vraiment supprimer les transactions sélectionnées ?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                final provider = Provider.of<TransactionProvider>(context, listen: false);
                for (int id in _selectedTransactions) {
                  provider.deleteTransaction(id);
                }
                setState(() {
                  _isDeleting = false;
                  _selectedTransactions.clear();
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
