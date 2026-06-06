import 'package:flutter/material.dart';
import '../../models/athlete.dart';
import '../../services/athlete_service.dart';

class AddAthleteScreen extends StatefulWidget {
  const AddAthleteScreen({super.key});

  @override
  State<AddAthleteScreen> createState() => _AddAthleteScreenState();
}

class _AddAthleteScreenState extends State<AddAthleteScreen> {
  final nameController = TextEditingController();
  final nicknameController = TextEditingController();
  final gymController = TextEditingController();
  final weightClassController = TextEditingController();

  final service = AthleteService();

  bool isLoading = false;

  Future<void> saveAthlete() async {
    if (nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Full name is required')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final athlete = Athlete(
        fullName: nameController.text.trim(),
        nickname: nicknameController.text.trim(),
        gym: gymController.text.trim(),
        weightClass: weightClassController.text.trim(),
        wins: 0,
        losses: 0,
        draws: 0,
      );

      await service.addAthlete(athlete);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Athlete added successfully')),
      );

      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding athlete: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    nicknameController.dispose();
    gymController.dispose();
    weightClassController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Athlete'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Full Name',
              ),
            ),
            TextField(
              controller: nicknameController,
              decoration: const InputDecoration(
                labelText: 'Nickname',
              ),
            ),
            TextField(
              controller: gymController,
              decoration: const InputDecoration(
                labelText: 'Gym',
              ),
            ),
            TextField(
              controller: weightClassController,
              decoration: const InputDecoration(
                labelText: 'Weight Class',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isLoading ? null : saveAthlete,
              child: isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Save Athlete'),
            ),
          ],
        ),
      ),
    );
  }
}