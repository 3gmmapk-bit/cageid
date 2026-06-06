import 'package:flutter/material.dart';

import '../../models/media_item.dart';

class MediaDetailScreen extends StatelessWidget {
  final MediaItem media;

  const MediaDetailScreen({
    super.key,
    required this.media,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(media.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(
              media.imageUrl,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const SizedBox(
                  height: 250,
                  child: Center(
                    child: Icon(Icons.broken_image, size: 60),
                  ),
                );
              },
            ),

            Card(
              margin: const EdgeInsets.all(12),
              child: ListTile(
                title: Text(media.title),
                subtitle: Text('Category: ${media.category}'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}