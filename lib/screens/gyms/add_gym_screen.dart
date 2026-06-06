import 'package:flutter/material.dart';

import '../../models/gym.dart';
import '../../services/gym_service.dart';

class AddGymScreen extends StatefulWidget {
  const AddGymScreen({super.key});

  @override
  State<AddGymScreen> createState() => _AddGymScreenState();
}

class _AddGymScreenState extends State<AddGymScreen> {
  final GymService service = GymService();

  final nameController = TextEditingController();
  final cityController = TextEditingController();
  final countryController = TextEditingController(text: 'Pakistan');
  final descriptionController = TextEditingController();

  bool isSaving = false;

  Future<void> saveGym() async {
    if (nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gym name is required')),
      );
      return;
    }

    setState(() => isSaving = true);

    try {
      final gym = Gym(
        name: nameController.text.trim(),
        city: cityController.text.trim(),
        country: countryController.text.trim(),
        description: descriptionController.text.trim(),
      );

      await service.addGym(gym);

      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving gym: $e')),
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
    cityController.dispose();
    countryController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Gym'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            buildField(
              controller: nameController,
              label: 'Gym Name',
            ),
            buildField(
              controller: cityController,
              label: 'City',
            ),
            buildField(
              controller: countryController,
              label: 'Country',
            ),
            buildField(
              controller: descriptionController,
              label: 'Description',
              maxLines: 4,
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isSaving ? null : saveGym,
                child: isSaving
                    ? const CircularProgressIndicator()
                    : const Text('Save Gym'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}