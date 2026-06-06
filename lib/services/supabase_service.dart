import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: 'https://suxvdsailpsopllzeaus.supabase.co',
      publishableKey: 'sb_publishable_Tbt5Vo060Zotjp7Cya_nbA_xmPbpUO-',
    );
  }
}