import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final firebase_auth.FirebaseAuth auth =
      firebase_auth.FirebaseAuth.instance;

  final SupabaseClient supabase = Supabase.instance.client;

  firebase_auth.User? get currentUser => auth.currentUser;

  Stream<firebase_auth.User?> get authStateChanges =>
      auth.authStateChanges();

  Future<void> register({
    required String email,
    required String password,
    required String fullName,
  }) async {
    final credential = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = credential.user;

    if (user == null) {
      throw Exception('User registration failed');
    }

    await user.updateDisplayName(fullName);

    await supabase.from('app_users').insert({
      'firebase_uid': user.uid,
      'email': email,
      'full_name': fullName,
      'role': 'Public User',
    });
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    await auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> logout() async {
    await auth.signOut();
  }

  Future<String> getUserRole() async {
    final user = auth.currentUser;

    if (user == null) {
      return 'Public User';
    }

    final response = await supabase
        .from('app_users')
        .select('role')
        .eq('firebase_uid', user.uid)
        .maybeSingle();

    if (response == null) {
      return 'Public User';
    }

    return response['role'] ?? 'Public User';
  }

  Future<bool> isAdmin() async {
    final role = await getUserRole();

    return role == 'Super Admin' ||
        role == 'Promotion Admin' ||
        role == 'Gym Admin';
  }
}