import 'package:flutter/material.dart';

import '../../models/gym.dart';
import '../../services/gym_service.dart';
import 'add_gym_screen.dart';
import 'gym_detail_screen.dart';

class GymsScreen extends StatefulWidget {
  const GymsScreen({super.key});

  @override
  State<GymsScreen> createState() => _GymsScreenState();
}

class _GymsScreenState extends State<GymsScreen> {
  final GymService service = GymService();

  Future<void> openAddGym() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AddGymScreen(),
      ),
    );

    setState(() {});
  }

  Future<void> deleteGym(String id) async {
    await service.deleteGym(id);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gyms'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: openAddGym,
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<Gym>>(
        future: service.getGyms(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error loading gyms: ${snapshot.error}'),
            );
          }

          final gyms = snapshot.data ?? [];

          if (gyms.isEmpty) {
            return const Center(
              child: Text('No gyms found. Add your first gym.'),
            );
          }

          return ListView.builder(
            itemCount: gyms.length,
            itemBuilder: (context, index) {
              final gym = gyms[index];

              return Card(
                margin: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                child: ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.fitness_center),
                  ),
                  title: Text(gym.name),
                  subtitle: Text('${gym.city}, ${gym.country}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => GymDetailScreen(gym: gym),
                      ),
                    );
                  },
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: gym.id == null
                        ? null
                        : () => deleteGym(gym.id!),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}