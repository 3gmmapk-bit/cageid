import 'package:flutter/material.dart';

import '../../models/gym.dart';
import '../../models/athlete.dart';
import '../../services/gym_service.dart';
import '../athletes/athlete_detail_screen.dart';

class GymDetailScreen extends StatelessWidget {
  final Gym gym;

  const GymDetailScreen({
    super.key,
    required this.gym,
  });

  @override
  Widget build(BuildContext context) {
    final GymService service = GymService();

    return Scaffold(
      appBar: AppBar(
        title: Text(gym.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              margin: const EdgeInsets.all(12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 45,
                      child: gym.logoUrl == null || gym.logoUrl!.isEmpty
                          ? const Icon(Icons.fitness_center, size: 40)
                          : null,
                    ),
                    const SizedBox(height: 14),
                    Text(
                      gym.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text('${gym.city}, ${gym.country}'),
                    const SizedBox(height: 14),
                    Text(
                      gym.description.isEmpty
                          ? 'No description added.'
                          : gym.description,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

            const Padding(
              padding: EdgeInsets.all(12),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Fighters from this Gym',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            FutureBuilder<List<Athlete>>(
              future: service.getAthletesByGym(gym.name),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.all(20),
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  return Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text('Error loading fighters: ${snapshot.error}'),
                  );
                }

                final athletes = snapshot.data ?? [];

                if (athletes.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(20),
                    child: Text('No fighters linked to this gym yet.'),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: athletes.length,
                  itemBuilder: (context, index) {
                    final athlete = athletes[index];

                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      child: ListTile(
                        leading: const CircleAvatar(
                          child: Icon(Icons.person),
                        ),
                        title: Text(athlete.fullName),
                        subtitle: Text(
                          '${athlete.weightClass} • ${athlete.wins}-${athlete.losses}-${athlete.draws}',
                        ),
                        trailing: Text('${athlete.rankingPoints} pts'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AthleteDetailScreen(
                                athlete: athlete,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}