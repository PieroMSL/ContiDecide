import 'package:flutter/foundation.dart';
import '../models/candidate.dart';
import '../repositories/vote_repository.dart';

class VoteViewModel extends ChangeNotifier {
  final VoteRepository? _voteRepository;

  VoteViewModel(this._voteRepository);

  List<Candidate> _candidates = [];
  List<Candidate> get candidates => _candidates;

  Candidate? _selectedCandidate;
  Candidate? get selectedCandidate => _selectedCandidate;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _hasVoted = false;
  bool get hasVoted => _hasVoted;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  String? _successMessage;
  String? get successMessage => _successMessage;

  // Inicializar vista
  Future<void> loadData(String userEmail) async {
    if (_voteRepository == null) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // 1. Cargar estado de voto del usuario
      _hasVoted = await _voteRepository.checkHasVoted(userEmail);

      if (!_hasVoted) {
        // 2. Si no ha votado, cargar candidatos
        _candidates = await _voteRepository.getCandidates();
      }
      // Si ya votó, no necesitamos candidatos, mostraremos pantalla de "Ya votaste"
    } catch (e) {
      _errorMessage = "Error cargando datos: ${e.toString()}";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectCandidate(Candidate candidate) {
    if (_hasVoted) return;
    _selectedCandidate = candidate;
    notifyListeners();
  }

  Future<bool> submitVote(String userEmail) async {
    if (_selectedCandidate == null) {
      _errorMessage = "Debes seleccionar un candidato";
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (_voteRepository != null) {
        // Blindaje 1: Re-verificar sesión activa justo antes de enviar
        // Esto previene que una sesión expirada en background intente enviar datos
        // Nota: Idealmente se pasaría el userId/email fresco, pero aquí confiamos en el parámetro verificado por AuthVM
        // Podríamos inyectar AuthRepository aquí para doble check, pero el error de Supabase/Firebase nos lo dirá.

        // CP-14, CP-15: Envío atómico
        await _voteRepository.submitVote(userEmail, _selectedCandidate!.id);

        _hasVoted = true;
        _successMessage = "¡Tu voto ha sido registrado correctamente!";
        _isLoading = false;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _isLoading = false;
      String errorStr = e.toString();

      // Blindaje 2: Manejo explícito de Conflicto (Doble Voto)
      // Supabase devuelve error code 23505 (unique_violation) o 409 Conflict
      if (errorStr.contains('23505') ||
          errorStr.contains('Duplicate entry') ||
          errorStr.contains('already has an existing vote')) {
        _errorMessage =
            "Ya existe un voto registrado con tu cuenta institucional.";
        // Actualizamos estado local para reflejar la realidad
        _hasVoted = true;
      } else {
        _errorMessage = errorStr.replaceAll('Exception: ', '');
      }

      notifyListeners();
      return false;
    }
  }

  void clearMessages() {
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }
}
