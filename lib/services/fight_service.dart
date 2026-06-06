import 'package:supabase_flutter/supabase_flutter.dart';

class FightService {
  final supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> getFightsByEvent(String eventId) async {
    final response = await supabase
        .from('fights')
        .select('''
          *,
          red:athletes!fights_fighter_red_fkey(full_name),
          blue:athletes!fights_fighter_blue_fkey(full_name),
          winner:athletes!fights_winner_id_fkey(full_name)
        ''')
        .eq('event_id', eventId)
        .order('created_at');

    return List<Map<String, dynamic>>.from(response);
  }

  Future<void> addFight({
    required String eventId,
    required String fighterRed,
    required String fighterBlue,
    required String weightClass,
  }) async {
    await supabase.from('fights').insert({
      'event_id': eventId,
      'fighter_red': fighterRed,
      'fighter_blue': fighterBlue,
      'weight_class': weightClass,
      'is_completed': false,
    });
  }

  Future<void> addFightResult({
    required String fightId,
    required String winnerId,
    required String loserId,
    required String method,
    required int round,
    required String fightTime,
  }) async {
    await supabase.from('fights').update({
      'winner_id': winnerId,
      'method': method,
      'round': round,
      'fight_time': fightTime,
      'is_completed': true,
    }).eq('id', fightId);

    await supabase.rpc('increment_athlete_win', params: {
      'athlete_id_input': winnerId,
    });

    await supabase.rpc('increment_athlete_loss', params: {
      'athlete_id_input': loserId,
    });

    int bonus = 10;

    if (method == 'KO/TKO' || method == 'Submission') {
      bonus += 5;
    }

    await supabase.rpc('add_ranking_points', params: {
      'athlete_id_input': winnerId,
      'points_input': bonus,
    });
  }
}