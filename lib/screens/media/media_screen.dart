import 'package:flutter/material.dart';

import '../../models/media_item.dart';
import '../../services/media_service.dart';
import 'add_media_screen.dart';
import 'media_detail_screen.dart';

class MediaScreen extends StatefulWidget {
  const MediaScreen({super.key});

  @override
  State<MediaScreen> createState() => _MediaScreenState();
}

class _MediaScreenState extends State<MediaScreen> {
  final MediaService service = MediaService();

  Future<void> openAddMedia() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AddMediaScreen(),
      ),
    );

    setState(() {});
  }

  Future<void> deleteMedia(String id) async {
    await service.deleteMedia(id);
    setState(() {});
  }

  Widget buildMediaImage(String url) {
    if (url.isEmpty) {
      return const Icon(Icons.image, size: 40);
    }

    return Image.network(
      url,
      width: 70,
      height: 70,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return const Icon(Icons.broken_image, size: 40);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Media'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: openAddMedia,
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<MediaItem>>(
        future: service.getMedia(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error loading media: ${snapshot.error}'),
            );
          }

          final media = snapshot.data ?? [];

          if (media.isEmpty) {
            return const Center(
              child: Text('No media uploaded yet.'),
            );
          }

          return ListView.builder(
            itemCount: media.length,
            itemBuilder: (context, index) {
              final item = media[index];

              return Card(
                margin: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: buildMediaImage(item.imageUrl),
                  ),
                  title: Text(item.title),
                  subtitle: Text(item.category),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MediaDetailScreen(
                          media: item,
                        ),
                      ),
                    );
                  },
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: item.id == null
                        ? null
                        : () => deleteMedia(item.id!),
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