import 'package:flutter/material.dart';
import 'dart:io';

class Header extends StatelessWidget {
  final String pageName;
  final String? userName;
  final String? userPhotoPath;

  Header({required this.pageName, this.userName, this.userPhotoPath});

  @override
  Widget build(BuildContext context) {
    bool showBackButton = pageName != 'Portefeuilles' && pageName != 'welcome';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (showBackButton) // Affiche le bouton retour si on est pas sur les pages spécifiques
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          Expanded(
            child: Text(
              pageName,
              textAlign: showBackButton ? TextAlign.left : TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          _buildProfileIcon(context),
        ],
      ),
    );
  }

  Widget _buildProfileIcon(BuildContext context) {
    if (userPhotoPath != null && userPhotoPath!.isNotEmpty) {
      return GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, '/settings');
        },
        child: CircleAvatar(
          backgroundImage: FileImage(File(userPhotoPath!)),
          radius: 25,
        ),
      );
    } else if (userName != null && userName!.isNotEmpty) {
      String initials = userName!.split(' ').map((e) => e[0]).take(2).join();
      return GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, '/settings');
        },
        child: CircleAvatar(
          backgroundColor: Colors.grey,
          child: Text(
            initials.toUpperCase(),
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          radius: 25,
        ),
      );
    } else {
      return IconButton(
        icon: Icon(Icons.account_circle_sharp, size: 40),
        onPressed: () {
          Navigator.pushNamed(context, '/settings');
        },
      );
    }
  }
}
