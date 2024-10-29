// screens/settings_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/notification_provider.dart';
import '../services/database_service.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Paramètres'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildNotificationToggle(context),
            SizedBox(height: 16),
            _buildPreferredLanguage(context),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationToggle(BuildContext context) {
    return Consumer<NotificationProvider>(
      builder: (context, notificationProvider, child) {
        return SwitchListTile(
          title: Text('Activer les notifications'),
          value: notificationProvider.notificationsEnabled ?? false,  // Ajout de l'opérateur null-aware
          onChanged: (value) {
            notificationProvider.setNotificationsEnabled(value);
          },
        );
      },
    );
  }

  Widget _buildPreferredLanguage(BuildContext context) {
    return FutureBuilder<String>(
      future: DatabaseService().getPreferredLanguage(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (!snapshot.hasData) {
          return Text('Erreur lors de la récupération de la langue préférée.');
        }

        String language = snapshot.data ?? 'Français';
        return ListTile(
          title: Text('Langue préférée : $language'),
          trailing: IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              _showLanguageDialog(context);
            },
          ),
        );
      },
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Choisir la langue préférée'),
          content: DropdownButton<String>(
            value: 'Français',
            items: [
              DropdownMenuItem(child: Text('Français'), value: 'Français'),
              DropdownMenuItem(child: Text('Anglais'), value: 'Anglais'),
            ],
            onChanged: (value) {
              DatabaseService().setPreferredLanguage(value!);
              Navigator.of(context).pop();
            },
          ),
        );
      },
    );
  }
}
