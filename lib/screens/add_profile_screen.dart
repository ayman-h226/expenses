// screens/add_portefeuille_screen.dart

import 'package:flutter/material.dart';
import '../models/portefeuille.dart';
import '../services/database_service.dart';

class AddPortefeuilleScreen extends StatefulWidget {
  @override
  _AddPortefeuilleScreenState createState() => _AddPortefeuilleScreenState();
}

class _AddPortefeuilleScreenState extends State<AddPortefeuilleScreen> {
  final _nameController = TextEditingController();
  final _initialBalanceController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter un Portefeuille'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTextField(_nameController, 'Nom du portefeuille'),
            SizedBox(height: 16),
            _buildTextField(_initialBalanceController, 'Solde initial', isNumeric: true),
            SizedBox(height: 16),
            _buildTextField(_descriptionController, 'Description'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addPortefeuille,
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

  Widget _buildTextField(TextEditingController controller, String labelText, {bool isNumeric = false}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(),
      ),
      keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
    );
  }

  void _addPortefeuille() async {
    final name = _nameController.text;
    final initialBalance = double.tryParse(_initialBalanceController.text) ?? 0.0;
    final description = _descriptionController.text;

    if (name.isEmpty || initialBalance < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veuillez entrer un nom valide et un solde initial.')),
      );
      return;
    }

    final newPortefeuille = Portefeuille(
      name: name,
      initialBalance: initialBalance,
      description: description,
      dateCreation: DateTime.now(),
    );

    await DatabaseService().insertPortefeuille(newPortefeuille);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Portefeuille ajouté avec succès !')),
    );

    Navigator.pop(context);  // Retour à l'écran précédent
  }
}
