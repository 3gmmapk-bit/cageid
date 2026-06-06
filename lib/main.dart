import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'screens/splash/splash_screen.dart';

void main() {
  runApp(const CageIDApp());
}

class CageIDApp extends StatelessWidget {
  const CageIDApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CageID',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const SplashScreen(),
    );
  }
}