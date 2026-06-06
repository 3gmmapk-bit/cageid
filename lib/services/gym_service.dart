import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/gym.dart';
import '../models/athlete.dart';

class GymService {
  final supabase = Supabase.instance.client;

  Future<List<Gym>> getGyms() async {
    final response = await supabase
        .from('gyms')
        .select()
        .order('name');

    return response.map<Gym>((item) {
      return Gym.fromJson(item);
    }).toList();
  }

  Future<void> addGym(Gym gym) async {
    await supabase.from('gyms').insert(gym.toJson());
  }

  Future<void> deleteGym(String id) async {
    await supabase.from('gyms').delete().eq('id', id);
  }

  Future<List<Athlete>> getAthletesByGym(String gymName) async {
    final response = await supabase
        .from('athletes')
        .select()
        .eq('gym', gymName)
        .order('full_name');

    return response.map<Athlete>((item) {
      return Athlete.fromJson(item);
    }).toList();
  }
}