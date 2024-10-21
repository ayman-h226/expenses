// state/notification_provider.dart

import 'package:flutter/material.dart';
import '../services/database_service.dart';

class NotificationProvider with ChangeNotifier {
  bool _notificationsEnabled = true;

  bool get notificationsEnabled => _notificationsEnabled;

  Future<void> setNotificationsEnabled(bool isEnabled) async {
    _notificationsEnabled = isEnabled;
    await DatabaseService().setNotificationsEnabled(isEnabled); // Appel de la méthode dans DatabaseService
    notifyListeners();
  }

  Future<void> loadNotificationSettings() async {
    _notificationsEnabled = await DatabaseService().isNotificationsEnabled();
    notifyListeners();
  }
}
