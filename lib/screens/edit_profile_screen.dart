import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
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
  File? _profileImage;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.utilisateur.nom);
    _emailController = TextEditingController(text: widget.utilisateur.email);
    if (widget.utilisateur.photoPath != null) {
      _profileImage = File(widget.utilisateur.photoPath!);
    }
  }

  Future<void> _pickImage() async {
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _profileImage = File(pickedImage.path);
      });
    }
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
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _profileImage != null ? FileImage(_profileImage!) : null,
                child: _profileImage == null ? Icon(Icons.camera_alt, size: 50) : null,
              ),
            ),
            SizedBox(height: 16),
            _buildTextField(_nameController, 'Nom'),
            SizedBox(height: 16),
            _buildTextField(_emailController, 'Email'),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: _updateProfile,
              child: Text('Enregistrer les modifications'),
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
      photoPath: _profileImage?.path, // Sauvegarder la nouvelle photo de profil si disponible
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
