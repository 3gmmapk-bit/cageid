import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/news_article.dart';
import '../../services/news_service.dart';
import '../../services/storage_service.dart';

class AddNewsScreen extends StatefulWidget {
  const AddNewsScreen({super.key});

  @override
  State<AddNewsScreen> createState() => _AddNewsScreenState();
}

class _AddNewsScreenState extends State<AddNewsScreen> {
  final NewsService newsService = NewsService();
  final StorageService storageService = StorageService();

  final titleController = TextEditingController();
  final contentController = TextEditingController();

  Uint8List? imageBytes;
  String selectedCategory = 'General';
  bool isSaving = false;

  final List<String> categories = [
    'General',
    'Announcement',
    'Event',
    'Result',
    'Ranking',
    'Fighter Update',
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

  Future<void> saveNews() async {
    if (titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('News title is required')),
      );
      return;
    }

    if (contentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('News content is required')),
      );
      return;
    }

    setState(() => isSaving = true);

    try {
      String imageUrl = '';

      if (imageBytes != null) {
        final fileName =
            'news_${DateTime.now().millisecondsSinceEpoch}.jpg';

        imageUrl = await storageService.uploadImage(
          imageBytes!,
          fileName,
        );
      }

      final article = NewsArticle(
        title: titleController.text.trim(),
        content: contentController.text.trim(),
        imageUrl: imageUrl,
        category: selectedCategory,
      );

      await newsService.addNews(article);

      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving news: $e')),
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
    contentController.dispose();
    super.dispose();
  }

  Widget buildImagePicker() {
    return GestureDetector(
      onTap: pickImage,
      child: Container(
        height: 210,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add News'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            buildImagePicker(),

            const SizedBox(height: 16),

            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'News Title',
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

            const SizedBox(height: 14),

            TextField(
              controller: contentController,
              maxLines: 8,
              decoration: const InputDecoration(
                labelText: 'News Content',
                alignLabelWithHint: true,
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isSaving ? null : saveNews,
                child: isSaving
                    ? const CircularProgressIndicator()
                    : const Text('Publish News'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}