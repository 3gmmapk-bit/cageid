import 'package:supabase_flutter/supabase_flutter.dart';

class EventService {
  final supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> getEvents() async {
    final response = await supabase
        .from('events')
        .select()
        .order('event_date', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }

  Future<List<Map<String, dynamic>>> searchEvents(
    String query,
  ) async {
    final response = await supabase
        .from('events')
        .select()
        .or(
          'name.ilike.%$query%,venue.ilike.%$query%,city.ilike.%$query%,country.ilike.%$query%',
        )
        .order('event_date', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }

  Future<void> addEvent({
    required String name,
    required String eventDate,
    required String venue,
    required String city,
    required String country,
  }) async {
    await supabase.from('events').insert({
      'name': name,
      'event_date': eventDate,
      'venue': venue,
      'city': city,
      'country': country,
    });
  }

  Future<void> updateEvent({
    required String id,
    required String name,
    required String eventDate,
    required String venue,
    required String city,
    required String country,
  }) async {
    await supabase
        .from('events')
        .update({
          'name': name,
          'event_date': eventDate,
          'venue': venue,
          'city': city,
          'country': country,
        })
        .eq('id', id);
  }

  Future<Map<String, dynamic>?> getEventById(
    String id,
  ) async {
    final response = await supabase
        .from('events')
        .select()
        .eq('id', id)
        .maybeSingle();

    return response;
  }

  Future<void> deleteEvent(String id) async {
    await supabase
        .from('events')
        .delete()
        .eq('id', id);
  }
}