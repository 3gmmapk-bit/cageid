import 'package:flutter/material.dart';

import '../../services/dummy_data.dart';
import 'athlete_detail_screen.dart';

class AthletesScreen extends StatelessWidget {
  const AthletesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Athletes'),
      ),
      body: ListView.builder(
        itemCount: athletes.length,
        itemBuilder: (context, index) {

          final athlete = athletes[index];

          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.person),
              ),

              title: Text(athlete.name),

              subtitle: Text(
                '${athlete.wins}-${athlete.losses}-${athlete.draws}',
              ),

              trailing: const Icon(Icons.arrow_forward_ios),

              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        AthleteDetailScreen(
                      athlete: athlete,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}