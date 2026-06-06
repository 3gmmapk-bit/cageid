import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/athlete.dart';

class AthleteService {
  final supabase = Supabase.instance.client;

  Future<List<Athlete>> getAthletes() async {
    final response = await supabase
        .from('athletes')
        .select()
        .order('ranking_points', ascending: false);

    return response.map<Athlete>((item) {
      return Athlete.fromJson(item);
    }).toList();
  }

  Future<List<Athlete>> searchAthletes(String query) async {
    final response = await supabase
        .from('athletes')
        .select()
        .or(
          'full_name.ilike.%$query%,nickname.ilike.%$query%,gym.ilike.%$query%,weight_class.ilike.%$query%,country.ilike.%$query%,coach.ilike.%$query%',
        )
        .order('ranking_points', ascending: false);

    return response.map<Athlete>((item) {
      return Athlete.fromJson(item);
    }).toList();
  }

  Future<List<Athlete>> advancedSearchAthletes({
    String searchText = '',
    String weightClass = 'All',
    String country = 'All',
    String athleteType = 'All',
    String gym = 'All',
    String coach = 'All',
  }) async {
    var query = supabase.from('athletes').select();

    if (searchText.trim().isNotEmpty) {
      query = query.or(
        'full_name.ilike.%$searchText%,nickname.ilike.%$searchText%',
      );
    }

    if (weightClass != 'All') {
      query = query.eq('weight_class', weightClass);
    }

    if (country != 'All') {
      query = query.eq('country', country);
    }

    if (athleteType != 'All') {
      query = query.eq('athlete_type', athleteType);
    }

    if (gym != 'All') {
      query = query.eq('gym', gym);
    }

    if (coach != 'All') {
      query = query.eq('coach', coach);
    }

    final response = await query.order(
      'ranking_points',
      ascending: false,
    );

    return response.map<Athlete>((item) {
      return Athlete.fromJson(item);
    }).toList();
  }

  Future<void> addAthlete(Athlete athlete) async {
    await supabase.from('athletes').insert(athlete.toJson());
  }

  Future<void> updateAthlete(Athlete athlete) async {
    if (athlete.id == null) {
      throw Exception('Athlete ID is missing');
    }

    await supabase
        .from('athletes')
        .update(athlete.toJson())
        .eq('id', athlete.id!);
  }

  Future<void> deleteAthlete(String id) async {
    await supabase.from('athletes').delete().eq('id', id);
  }
}