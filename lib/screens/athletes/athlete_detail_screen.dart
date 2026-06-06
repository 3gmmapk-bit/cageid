import 'package:flutter/material.dart';
import '../../models/athlete.dart';

class AthleteDetailScreen extends StatelessWidget {
  final Athlete athlete;

  const AthleteDetailScreen({
    super.key,
    required this.athlete,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(athlete.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            const CircleAvatar(
              radius: 50,
              child: Icon(
                Icons.person,
                size: 50,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              athlete.name,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            Text(
              athlete.nickname,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 20),

            Card(
              child: ListTile(
                title: const Text('Gym'),
                subtitle: Text(athlete.gym),
              ),
            ),

            Card(
              child: ListTile(
                title: const Text('Weight Class'),
                subtitle: Text(athlete.weightClass),
              ),
            ),

            Card(
              child: ListTile(
                title: const Text('Record'),
                subtitle: Text(
                  '${athlete.wins}-${athlete.losses}-${athlete.draws}',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}