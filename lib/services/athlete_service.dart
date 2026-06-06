import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/athlete.dart';

class AthleteService {
  final supabase = Supabase.instance.client;

  Future<List<Athlete>> getAthletes() async {
    final response =
        await supabase.from('athletes').select();

    return (response as List)
        .map((e) => Athlete.fromJson(e))
        .toList();
  }

  Future<void> addAthlete(Athlete athlete) async {
    await supabase
        .from('athletes')
        .insert(athlete.toJson());
  }

  Future<void> updateAthlete(
      String id,
      Athlete athlete,
      ) async {
    await supabase
        .from('athletes')
        .update(athlete.toJson())
        .eq('id', id);
  }

  Future<void> deleteAthlete(
      String id,
      ) async {
    await supabase
        .from('athletes')
        .delete()
        .eq('id', id);
  }
}