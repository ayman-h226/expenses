// screens/add_portefeuille_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/portefeuille.dart';
import '../state/portefeuille_provider.dart';

class AddPortefeuilleScreen extends StatefulWidget {
  @override
  _AddPortefeuilleScreenState createState() => _AddPortefeuilleScreenState();
}

class _AddPortefeuilleScreenState extends State<AddPortefeuilleScreen> {
  final _nameController = TextEditingController();
  final _balanceController = TextEditingController();
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
            _buildTextField(_balanceController, 'Solde initial', isNumeric: true),
            SizedBox(height: 16),
            _buildTextField(_descriptionController, 'Description'),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: _addPortefeuille,
              child: Text('Ajouter'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {bool isNumeric = false}) {
    return TextField(
      controller: controller,
      keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
    );
  }

  void _addPortefeuille() {
    final String name = _nameController.text;
    final double balance = double.tryParse(_balanceController.text) ?? 0.0;
    final String description = _descriptionController.text;

    if (name.isEmpty || balance <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veuillez entrer un nom valide et un solde initial')),
      );
      return;
    }

    final newPortefeuille = Portefeuille(
      name: name,
      initialBalance: balance,
      description: description,
      dateCreation: DateTime.now(),
    );

    Provider.of<PortefeuilleProvider>(context, listen: false).addPortefeuille(newPortefeuille);
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _balanceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
