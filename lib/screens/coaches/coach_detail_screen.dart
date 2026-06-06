import 'package:flutter/material.dart';

import '../../models/coach.dart';
import '../../models/athlete.dart';
import '../../services/coach_service.dart';
import '../athletes/athlete_detail_screen.dart';

class CoachDetailScreen extends StatelessWidget {
  final Coach coach;

  const CoachDetailScreen({
    super.key,
    required this.coach,
  });

  @override
  Widget build(BuildContext context) {
    final CoachService service = CoachService();

    return Scaffold(
      appBar: AppBar(
        title: Text(coach.name),
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
                    const CircleAvatar(
                      radius: 45,
                      child: Icon(Icons.sports_mma, size: 40),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      coach.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(coach.specialization),
                    const SizedBox(height: 8),
                    Text('${coach.gym} • ${coach.country}'),
                    const SizedBox(height: 14),
                    Text(
                      coach.bio.isEmpty
                          ? 'No biography added.'
                          : coach.bio,
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
                  'Fighters coached',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            FutureBuilder<List<Athlete>>(
              future: service.getAthletesByCoach(coach.name),
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
                    child: Text('No fighters linked to this coach yet.'),
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