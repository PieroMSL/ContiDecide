import '../models/candidate.dart';
import '../services/supabase_service.dart';

class VoteRepository {
  final SupabaseService _supabaseService;

  VoteRepository(this._supabaseService);

  Future<List<Candidate>> getCandidates() async {
    return await _supabaseService.getCandidates();
  }

  Future<bool> checkHasVoted(String email) async {
    return await _supabaseService.hasUserVoted(email);
  }

  Future<void> submitVote(String email, int candidateId) async {
    return await _supabaseService.castVote(email, candidateId);
  }
}
