// screens/edit_profile_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/utilisateur.dart';
import '../state/utilisateur_provider.dart';

class EditProfileScreen extends StatefulWidget {
  final Utilisateur utilisateur;

  EditProfileScreen({required this.utilisateur});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.utilisateur.nom);
    _emailController = TextEditingController(text: widget.utilisateur.email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modifier le Profil'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTextField(_nameController, 'Nom'),
            SizedBox(height: 16),
            _buildTextField(_emailController, 'Email'),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: _updateProfile,
              child: Text('Enregistrer les modifications'),
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

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
    );
  }

  void _updateProfile() {
    final String newName = _nameController.text;
    final String newEmail = _emailController.text;

    if (newName.isEmpty || newEmail.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veuillez entrer un nom et un email valides')),
      );
      return;
    }

    final updatedUser = Utilisateur(
      id: widget.utilisateur.id,
      nom: newName,
      email: newEmail,
      dateCreation: widget.utilisateur.dateCreation,
    );

    Provider.of<UtilisateurProvider>(context, listen: false).updateUtilisateur(updatedUser);
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}
