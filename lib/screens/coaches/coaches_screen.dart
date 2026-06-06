import 'package:flutter/material.dart';

import '../../models/coach.dart';
import '../../services/coach_service.dart';
import '../../services/role_service.dart';
import 'add_coach_screen.dart';
import 'coach_detail_screen.dart';

class CoachesScreen extends StatefulWidget {
  const CoachesScreen({super.key});

  @override
  State<CoachesScreen> createState() => _CoachesScreenState();
}

class _CoachesScreenState extends State<CoachesScreen> {
  final CoachService service = CoachService();
  final RoleService roleService = RoleService();

  Future<void> openAddCoach() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AddCoachScreen(),
      ),
    );

    setState(() {});
  }

  Future<void> deleteCoach(String id) async {
    await service.deleteCoach(id);
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
          onPressed: openAddCoach,
          child: const Icon(Icons.add),
        );
      },
    );
  }

  Widget buildDeleteButton(String coachId) {
    return FutureBuilder<bool>(
      future: roleService.isSuperAdmin(),
      builder: (context, snapshot) {
        if (snapshot.data != true) {
          return const SizedBox.shrink();
        }

        return IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () async {
            await deleteCoach(coachId);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Coaches'),
      ),
      floatingActionButton: buildAddButton(),
      body: FutureBuilder<List<Coach>>(
        future: service.getCoaches(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error loading coaches: ${snapshot.error}',
                textAlign: TextAlign.center,
              ),
            );
          }

          final coaches = snapshot.data ?? [];

          if (coaches.isEmpty) {
            return const Center(
              child: Text('No coaches found.'),
            );
          }

          return ListView.builder(
            itemCount: coaches.length,
            itemBuilder: (context, index) {
              final coach = coaches[index];

              return Card(
                margin: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                child: ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.sports_mma),
                  ),
                  title: Text(coach.name),
                  subtitle: Text(
                    '${coach.specialization} • ${coach.gym}',
                  ),
                  trailing: coach.id == null
                      ? const SizedBox.shrink()
                      : buildDeleteButton(coach.id!),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CoachDetailScreen(
                          coach: coach,
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