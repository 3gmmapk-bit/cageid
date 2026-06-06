import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/athlete.dart';
import '../../services/athlete_service.dart';
import '../../services/storage_service.dart';

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
  final countryController = TextEditingController();
  final bioController = TextEditingController();
  final instagramController = TextEditingController();
  final facebookController = TextEditingController();
  final rankingController = TextEditingController();

  final AthleteService service = AthleteService();

  Uint8List? imageBytes;
  bool isLoading = false;

  String athleteType = 'Amateur';

  Future<void> pickImage() async {
    final picker = ImagePicker();

    final file = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 75,
    );

    if (file == null) return;

    imageBytes = await file.readAsBytes();

    setState(() {});
  }

  Future<void> saveAthlete() async {
    if (nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Full Name is required'),
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      String imageUrl = '';

      if (imageBytes != null) {
        imageUrl = await StorageService().uploadImage(
          imageBytes!,
          '${DateTime.now().millisecondsSinceEpoch}.jpg',
        );
      }

      final athlete = Athlete(
        fullName: nameController.text.trim(),
        nickname: nicknameController.text.trim(),
        gym: gymController.text.trim(),
        weightClass: weightClassController.text.trim(),
        country: countryController.text.trim(),
        bio: bioController.text.trim(),
        instagram: instagramController.text.trim(),
        facebook: facebookController.text.trim(),
        profileImage: imageUrl,
        wins: 0,
        losses: 0,
        draws: 0,
        rankingPoints:
            int.tryParse(rankingController.text.trim()) ?? 0,
        athleteType: athleteType,
      );

      await service.addAthlete(athlete);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Athlete Added Successfully'),
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Widget buildTextField({
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
    nicknameController.dispose();
    gymController.dispose();
    weightClassController.dispose();
    countryController.dispose();
    bioController.dispose();
    instagramController.dispose();
    facebookController.dispose();
    rankingController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Athlete'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            GestureDetector(
              onTap: pickImage,
              child: CircleAvatar(
                radius: 55,
                backgroundImage:
                    imageBytes != null
                        ? MemoryImage(imageBytes!)
                        : null,
                child: imageBytes == null
                    ? const Icon(
                        Icons.camera_alt,
                        size: 40,
                      )
                    : null,
              ),
            ),

            const SizedBox(height: 20),

            buildTextField(
              controller: nameController,
              label: 'Full Name',
            ),

            buildTextField(
              controller: nicknameController,
              label: 'Nickname',
            ),

            buildTextField(
              controller: gymController,
              label: 'Gym',
            ),

            buildTextField(
              controller: weightClassController,
              label: 'Weight Class',
            ),

            buildTextField(
              controller: rankingController,
              label: 'Ranking Points',
            ),

            Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: DropdownButtonFormField<String>(
                value: athleteType,
                decoration: const InputDecoration(
                  labelText: 'Athlete Type',
                  border: OutlineInputBorder(),
                ),
                items: const [
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
                    athleteType = value!;
                  });
                },
              ),
            ),

            buildTextField(
              controller: countryController,
              label: 'Country',
            ),

            buildTextField(
              controller: bioController,
              label: 'Biography',
              maxLines: 4,
            ),

            buildTextField(
              controller: instagramController,
              label: 'Instagram URL',
            ),

            buildTextField(
              controller: facebookController,
              label: 'Facebook URL',
            ),

            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : saveAthlete,
                child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Save Athlete'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}