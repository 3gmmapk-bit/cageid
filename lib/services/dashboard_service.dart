import 'package:supabase_flutter/supabase_flutter.dart';

class DashboardService {
  final supabase = Supabase.instance.client;

  Future<int> getAthleteCount() async {
    final data = await supabase.from('athletes').select();
    return data.length;
  }

  Future<int> getGymCount() async {
    final data = await supabase.from('gyms').select();
    return data.length;
  }

  Future<int> getCoachCount() async {
    final data = await supabase.from('coaches').select();
    return data.length;
  }

  Future<int> getEventCount() async {
    final data = await supabase.from('events').select();
    return data.length;
  }

  Future<List<Map<String, dynamic>>> getTopRankedAthletes() async {
    final data = await supabase
        .from('athletes')
        .select()
        .order('ranking_points', ascending: false)
        .limit(10);

    return List<Map<String, dynamic>>.from(data);
  }

  Future<List<Map<String, dynamic>>> getAllAthletes() async {
    final data = await supabase.from('athletes').select();

    return List<Map<String, dynamic>>.from(data);
  }
}