import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/media_item.dart';
import '../../services/media_service.dart';
import '../../services/storage_service.dart';

class AddMediaScreen extends StatefulWidget {
  const AddMediaScreen({super.key});

  @override
  State<AddMediaScreen> createState() => _AddMediaScreenState();
}

class _AddMediaScreenState extends State<AddMediaScreen> {
  final MediaService mediaService = MediaService();
  final StorageService storageService = StorageService();

  final titleController = TextEditingController();

  Uint8List? imageBytes;
  String selectedCategory = 'General';
  bool isSaving = false;

  final List<String> categories = [
    'General',
    'Athlete',
    'Event',
    'Gym',
    'Poster',
  ];

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

  Future<void> saveMedia() async {
    if (titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Media title is required')),
      );
      return;
    }

    if (imageBytes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an image')),
      );
      return;
    }

    setState(() => isSaving = true);

    try {
      final fileName =
          'media_${DateTime.now().millisecondsSinceEpoch}.jpg';

      final imageUrl = await storageService.uploadImage(
        imageBytes!,
        fileName,
        folder: 'media',
      );
    
      final media = MediaItem(
        title: titleController.text.trim(),
        imageUrl: imageUrl,
        category: selectedCategory,
      );

      await mediaService.addMedia(media);

      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading media: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => isSaving = false);
      }
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Media'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            GestureDetector(
              onTap: pickImage,
              child: Container(
                height: 220,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: imageBytes == null
                    ? const Center(
                        child: Icon(Icons.add_photo_alternate, size: 60),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.memory(
                          imageBytes!,
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Media Title',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 14),

            DropdownButtonFormField<String>(
              value: selectedCategory,
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
              items: categories.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCategory = value!;
                });
              },
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isSaving ? null : saveMedia,
                child: isSaving
                    ? const CircularProgressIndicator()
                    : const Text('Upload Media'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}