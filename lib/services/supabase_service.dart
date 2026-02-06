import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/candidate.dart';

class SupabaseService {
  final SupabaseClient _client = Supabase.instance.client;

  // Cargar candidatos
  Future<List<Candidate>> getCandidates() async {
    try {
      final List<dynamic> data = await _client
          .from('candidatos')
          .select()
          .order('nombre', ascending: true);

      return data.map((json) => Candidate.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Error al cargar candidatos: $e');
    }
  }

  // Verificar si usuario ya votó
  Future<bool> hasUserVoted(String email) async {
    try {
      final data = await _client
          .from('votos')
          .select('id')
          .eq('user_email', email)
          .maybeSingle();

      return data != null; // Si existe registro, ya votó
    } catch (e) {
      throw Exception('Error al verificar voto: $e');
    }
  }

  // Registrar voto
  Future<void> castVote(String email, int candidateId) async {
    try {
      // Doble check de seguridad (CP-15)
      final hasVoted = await hasUserVoted(email);
      if (hasVoted) {
        throw Exception('El usuario ya ha registrado un voto.');
      }

      await _client.from('votos').insert({
        'user_email': email,
        'candidate_id': candidateId,
        'voted_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      if (e.toString().contains('duplicate key') ||
          e.toString().contains('unique constraint')) {
        throw Exception('Ya has votado anteriormente.');
      }
      throw Exception('Error al registrar voto: $e');
    }
  }
}
