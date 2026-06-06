import 'package:flutter/material.dart';

import '../../models/coach.dart';
import '../../services/coach_service.dart';

class AddCoachScreen extends StatefulWidget {
  const AddCoachScreen({super.key});

  @override
  State<AddCoachScreen> createState() => _AddCoachScreenState();
}

class _AddCoachScreenState extends State<AddCoachScreen> {
  final CoachService service = CoachService();

  final nameController = TextEditingController();
  final specializationController = TextEditingController();
  final gymController = TextEditingController();
  final countryController = TextEditingController(text: 'Pakistan');
  final bioController = TextEditingController();

  bool isSaving = false;

  Future<void> saveCoach() async {
    if (nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Coach name is required')),
      );
      return;
    }

    setState(() => isSaving = true);

    try {
      final coach = Coach(
        name: nameController.text.trim(),
        specialization: specializationController.text.trim(),
        gym: gymController.text.trim(),
        country: countryController.text.trim(),
        bio: bioController.text.trim(),
      );

      await service.addCoach(coach);

      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving coach: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => isSaving = false);
      }
    }
  }

  Widget buildField({
    required TextEditingController controller,
    required String label,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    specializationController.dispose();
    gymController.dispose();
    countryController.dispose();
    bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Coach'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            buildField(
              controller: nameController,
              label: 'Coach Name',
            ),
            buildField(
              controller: specializationController,
              label: 'Specialization e.g. MMA / BJJ / Wrestling',
            ),
            buildField(
              controller: gymController,
              label: 'Gym',
            ),
            buildField(
              controller: countryController,
              label: 'Country',
            ),
            buildField(
              controller: bioController,
              label: 'Biography',
              maxLines: 4,
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isSaving ? null : saveCoach,
                child: isSaving
                    ? const CircularProgressIndicator()
                    : const Text('Save Coach'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}