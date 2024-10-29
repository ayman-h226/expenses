import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/budget_transaction.dart';
import '../models/categorie.dart';
import '../state/transaction_provider.dart';
import '../state/portefeuille_provider.dart'; // Importez PortefeuilleProvider pour notifier le changement

class AddTransactionScreen extends StatefulWidget {
  final int portefeuilleId;

  AddTransactionScreen({required this.portefeuilleId});

  @override
  _AddTransactionScreenState createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  Categorie _selectedCategorie = Categorie.alimentation;
  DateTime _selectedDate = DateTime.now();
  String _transactionType = 'dépense'; // Valeur par défaut

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter une Transaction'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildAmountField(),
            SizedBox(height: 16),
            _buildDescriptionField(),
            SizedBox(height: 16),
            _buildCategorieDropdown(),
            SizedBox(height: 16),
            _buildDateField(context),
            SizedBox(height: 16),
            _buildTransactionTypeRadios(),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await _addTransaction(context);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                child: Text('Ajouter', style: TextStyle(fontSize: 18)),
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
    );
  }

  Widget _buildAmountField() {
    return TextField(
      controller: _amountController,
      decoration: InputDecoration(
        labelText: 'Montant',
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.number,
    );
  }

  Widget _buildDescriptionField() {
    return TextField(
      controller: _descriptionController,
      decoration: InputDecoration(
        labelText: 'Description',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildCategorieDropdown() {
    return DropdownButtonFormField<Categorie>(
      value: _selectedCategorie,
      decoration: InputDecoration(
        labelText: 'Catégorie',
        border: OutlineInputBorder(),
      ),
      onChanged: (Categorie? newValue) {
        setState(() {
          _selectedCategorie = newValue!;
        });
      },
      items: Categorie.values.map((Categorie categorie) {
        return DropdownMenuItem<Categorie>(
          value: categorie,
          child: Text(getCategorieLabel(categorie)),
        );
      }).toList(),
    );
  }

  Widget _buildDateField(BuildContext context) {
    return Row(
      children: [
        Text(
          'Date : ${_selectedDate.toLocal()}'.split(' ')[0],
          style: TextStyle(fontSize: 16),
        ),
        Spacer(),
        TextButton(
          onPressed: () => _selectDate(context),
          child: Text('Choisir une date'),
        ),
      ],
    );
  }

  Widget _buildTransactionTypeRadios() {
    return Column(
      children: [
        RadioListTile<String>(
          title: const Text('Dépense'),
          value: 'dépense',
          groupValue: _transactionType,
          onChanged: (value) {
            setState(() {
              _transactionType = value!;
            });
          },
        ),
        RadioListTile<String>(
          title: const Text('Revenu'),
          value: 'revenu',
          groupValue: _transactionType,
          onChanged: (value) {
            setState(() {
              _transactionType = value!;
            });
          },
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _addTransaction(BuildContext context) async {
    final amount = double.tryParse(_amountController.text) ?? 0.0;
    final description = _descriptionController.text;

    if (amount <= 0 || description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veuillez entrer un montant valide et une description.')),
      );
      return;
    }

    final newTransaction = BudgetTransaction(
      portefeuilleId: widget.portefeuilleId,
      montant: amount,
      description: description,
      categorie: _selectedCategorie,
      date: _selectedDate,
      type: _transactionType,
    );

    // Ajout de la transaction dans TransactionProvider
    await Provider.of<TransactionProvider>(context, listen: false).addTransaction(newTransaction);

    // Mise à jour du solde du portefeuille dans PortefeuilleProvider
    await Provider.of<PortefeuilleProvider>(context, listen: false).updateSoldeCourant(widget.portefeuilleId);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Transaction ajoutée avec succès !')),
    );

    Navigator.pop(context);  // Retour à l'écran précédent
  }
}
