import 'package:flutter/material.dart';

import '../../models/athlete.dart';
import '../../services/athlete_service.dart';
import 'add_athlete_screen.dart';
import 'athlete_detail_screen.dart';

class AthletesScreen extends StatefulWidget {
  const AthletesScreen({super.key});

  @override
  State<AthletesScreen> createState() => _AthletesScreenState();
}

class _AthletesScreenState extends State<AthletesScreen> {
  final AthleteService service = AthleteService();
  final TextEditingController searchController = TextEditingController();

  late Future<List<Athlete>> athletesFuture;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    athletesFuture = service.getAthletes();

    searchController.addListener(() {
      setState(() {
        searchQuery = searchController.text.toLowerCase().trim();
      });
    });
  }

  void refresh() {
    setState(() {
      athletesFuture = service.getAthletes();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  List<Athlete> filterAthletes(List<Athlete> athletes) {
    if (searchQuery.isEmpty) {
      return athletes;
    }

    return athletes.where((athlete) {
      final name = athlete.fullName.toLowerCase();
      final nickname = athlete.nickname.toLowerCase();
      final gym = athlete.gym.toLowerCase();
      final weightClass = athlete.weightClass.toLowerCase();
      final country = athlete.country?.toLowerCase() ?? '';

      return name.contains(searchQuery) ||
          nickname.contains(searchQuery) ||
          gym.contains(searchQuery) ||
          weightClass.contains(searchQuery) ||
          country.contains(searchQuery);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Athletes'),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddAthleteScreen(),
            ),
          );

          refresh();
        },
        child: const Icon(Icons.add),
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search athletes...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          searchController.clear();
                        },
                      )
                    : null,
                border: const OutlineInputBorder(),
              ),
            ),
          ),

          Expanded(
            child: FutureBuilder<List<Athlete>>(
              future: athletesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'Error loading athletes: ${snapshot.error}',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }

                final allAthletes = snapshot.data ?? [];
                final filteredAthletes = filterAthletes(allAthletes);

                if (allAthletes.isEmpty) {
                  return const Center(
                    child: Text('No athletes added yet'),
                  );
                }

                if (filteredAthletes.isEmpty) {
                  return const Center(
                    child: Text('No athletes found'),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    refresh();
                  },
                  child: ListView.builder(
                    itemCount: filteredAthletes.length,
                    itemBuilder: (context, index) {
                      final athlete = filteredAthletes[index];

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: athlete.profileImage != null &&
                                    athlete.profileImage!.isNotEmpty
                                ? NetworkImage(athlete.profileImage!)
                                : null,
                            child: athlete.profileImage == null ||
                                    athlete.profileImage!.isEmpty
                                ? const Icon(Icons.person)
                                : null,
                          ),
                          title: Text(
                            athlete.fullName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            '${athlete.nickname.isNotEmpty ? athlete.nickname : 'No nickname'} • ${athlete.weightClass}',
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () async {
                              if (athlete.id == null) return;

                              await service.deleteAthlete(athlete.id!);
                              refresh();
                            },
                          ),
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
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}