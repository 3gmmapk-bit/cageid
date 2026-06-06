import 'package:flutter/material.dart';

import '../../models/athlete.dart';
import '../../services/athlete_service.dart';
import '../../services/role_service.dart';
import 'add_athlete_screen.dart';
import 'athlete_detail_screen.dart';

class AthletesScreen extends StatefulWidget {
  const AthletesScreen({super.key});

  @override
  State<AthletesScreen> createState() => _AthletesScreenState();
}

class _AthletesScreenState extends State<AthletesScreen> {
  final AthleteService service = AthleteService();
  final RoleService roleService = RoleService();

  Future<void> openAddAthlete() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AddAthleteScreen(),
      ),
    );

    setState(() {});
  }

  Future<void> deleteAthlete(String id) async {
    await service.deleteAthlete(id);
    setState(() {});
  }

  Widget buildAddButton() {
    return FutureBuilder<bool>(
      future: roleService.canManageAthletes(),
      builder: (context, snapshot) {
        if (snapshot.data != true) {
          return const SizedBox.shrink();
        }

        return FloatingActionButton(
          onPressed: openAddAthlete,
          child: const Icon(Icons.add),
        );
      },
    );
  }

  Widget buildDeleteButton(String athleteId) {
    return FutureBuilder<bool>(
      future: roleService.isSuperAdmin(),
      builder: (context, snapshot) {
        if (snapshot.data != true) {
          return const SizedBox.shrink();
        }

        return IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () async {
            await deleteAthlete(athleteId);
          },
        );
      },
    );
  }

  Widget buildProfileImage(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return const CircleAvatar(
        child: Icon(Icons.person),
      );
    }

    return CircleAvatar(
      backgroundImage: NetworkImage(imageUrl),
      onBackgroundImageError: (_, __) {},
      child: null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Athletes'),
      ),
      floatingActionButton: buildAddButton(),
      body: FutureBuilder<List<Athlete>>(
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
                'Error loading athletes: ${snapshot.error}',
                textAlign: TextAlign.center,
              ),
            );
          }

          final athletes = snapshot.data ?? [];

          if (athletes.isEmpty) {
            return const Center(
              child: Text('No athletes found.'),
            );
          }

          return ListView.builder(
            itemCount: athletes.length,
            itemBuilder: (context, index) {
              final athlete = athletes[index];

              return Card(
                margin: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                child: ListTile(
                  leading: buildProfileImage(athlete.profileImage),
                  title: Text(
                    athlete.fullName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    '${athlete.nickname}\n'
                    '${athlete.weightClass} • ${athlete.athleteType}\n'
                    '${athlete.gym} • ${athlete.wins}-${athlete.losses}-${athlete.draws}',
                  ),
                  isThreeLine: true,
                  trailing: buildDeleteButton(athlete.id ?? ''),
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
    );
  }
}