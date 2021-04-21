// Flutter imports:
import 'package:flutter/material.dart';

/// Snack Bar Service
class SnackBarService {
  late BuildContext _buildContext;

  /// Snack Bar Servixe Singleton Instance
  static SnackBarService instance = SnackBarService();

  /// Build Context
  set buildContext(BuildContext context) {
    _buildContext = context;
  }

  /// Show SnackBar Error
  void showSnackBarError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        content: Text(
          message,
          style: const TextStyle(color: Colors.white, fontSize: 15.0),
        ),
        backgroundColor: Colors.red,
      ),
    );
  }

  /// Show SnackBar Success
  void showSnackBarSuccess(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        content: Text(
          message,
          style: const TextStyle(color: Colors.white, fontSize: 15.0),
        ),
        backgroundColor: Colors.green,
      ),
    );
  }
}
