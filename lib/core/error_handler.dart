import 'package:flutter/material.dart';

class AppErrorHandler {
  static void showError(
    BuildContext context,
    Object error,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          error.toString(),
        ),
      ),
    );
  }
}