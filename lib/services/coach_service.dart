import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/coach.dart';
import '../models/athlete.dart';

class CoachService {
  final supabase = Supabase.instance.client;

  Future<List<Coach>> getCoaches() async {
    final response = await supabase
        .from('coaches')
        .select()
        .order('name');

    return response.map<Coach>((item) {
      return Coach.fromJson(item);
    }).toList();
  }

  Future<void> addCoach(Coach coach) async {
    await supabase.from('coaches').insert(coach.toJson());
  }

  Future<void> deleteCoach(String id) async {
    await supabase.from('coaches').delete().eq('id', id);
  }

  Future<List<Athlete>> getAthletesByCoach(String coachName) async {
    final response = await supabase
        .from('athletes')
        .select()
        .eq('coach', coachName)
        .order('full_name');

    return response.map<Athlete>((item) {
      return Athlete.fromJson(item);
    }).toList();
  }
}