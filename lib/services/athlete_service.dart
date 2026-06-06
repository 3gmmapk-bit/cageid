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
          'full_name.ilike.%$query%,nickname.ilike.%$query%,gym.ilike.%$query%,weight_class.ilike.%$query%,country.ilike.%$query%',
        )
        .order('ranking_points', ascending: false);

    return response.map<Athlete>((item) {
      return Athlete.fromJson(item);
    }).toList();
  }

  Future<void> addAthlete(Athlete athlete) async {
    await supabase.from('athletes').insert(athlete.toJson());
  }

  Future<void> deleteAthlete(String id) async {
    await supabase.from('athletes').delete().eq('id', id);
  }
}