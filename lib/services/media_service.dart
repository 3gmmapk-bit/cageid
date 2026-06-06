import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/media_item.dart';

class MediaService {
  final supabase = Supabase.instance.client;

  Future<List<MediaItem>> getMedia() async {
    final response = await supabase
        .from('media')
        .select()
        .order('created_at', ascending: false);

    return response.map<MediaItem>((item) {
      return MediaItem.fromJson(item);
    }).toList();
  }

  Future<void> addMedia(MediaItem media) async {
    await supabase.from('media').insert(media.toJson());
  }

  Future<void> deleteMedia(String id) async {
    await supabase.from('media').delete().eq('id', id);
  }
}