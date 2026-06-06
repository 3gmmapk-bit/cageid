import 'package:flutter/material.dart';

class GymsScreen extends StatelessWidget {
  const GymsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gyms')),
      body: const Center(child: Text('Gym profiles will appear here')),
    );
  }
}