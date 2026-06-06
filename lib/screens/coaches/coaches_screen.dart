import 'package:flutter/material.dart';

class CoachesScreen extends StatelessWidget {
  const CoachesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Coaches')),
      body: const Center(child: Text('Coach profiles will appear here')),
    );
  }
}