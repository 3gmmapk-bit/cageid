import 'package:flutter/material.dart';

import '../../models/athlete.dart';
import '../../services/athlete_service.dart';

class RankingsScreen extends StatefulWidget {
  const RankingsScreen({super.key});

  @override
  State<RankingsScreen> createState() => _RankingsScreenState();
}

class _RankingsScreenState extends State<RankingsScreen> {
  final AthleteService service = AthleteService();

  String selectedType = 'All';

  List<Athlete> filterAndSortAthletes(List<Athlete> athletes) {
    List<Athlete> filteredAthletes = athletes;

    if (selectedType != 'All') {
      filteredAthletes = athletes.where((athlete) {
        return athlete.athleteType == selectedType;
      }).toList();
    }

    filteredAthletes.sort(
      (a, b) => b.rankingPoints.compareTo(a.rankingPoints),
    );

    return filteredAthletes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rankings'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: DropdownButtonFormField<String>(
              value: selectedType,
              decoration: const InputDecoration(
                labelText: 'Filter Ranking Type',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'All',
                  child: Text('All'),
                ),
                DropdownMenuItem(
                  value: 'Amateur',
                  child: Text('Amateur'),
                ),
                DropdownMenuItem(
                  value: 'Professional',
                  child: Text('Professional'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  selectedType = value!;
                });
              },
            ),
          ),

          Expanded(
            child: FutureBuilder<List<Athlete>>(
              future: service.getAthletes(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error loading rankings: ${snapshot.error}',
                      textAlign: TextAlign.center,
                    ),
                  );
                }

                final athletes = snapshot.data ?? [];
                final rankedAthletes = filterAndSortAthletes(athletes);

                if (rankedAthletes.isEmpty) {
                  return const Center(
                    child: Text('No rankings available'),
                  );
                }

                return ListView.builder(
                  itemCount: rankedAthletes.length,
                  itemBuilder: (context, index) {
                    final athlete = rankedAthletes[index];

                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text('#${index + 1}'),
                        ),
                        title: Text(
                          athlete.fullName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          '${athlete.weightClass} • ${athlete.athleteType}',
                        ),
                        trailing: Text(
                          '${athlete.rankingPoints} pts',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}