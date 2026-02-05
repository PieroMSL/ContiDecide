import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../core/constants.dart';
import '../repositories/auth_repository.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepository? _authRepository;

  AuthViewModel(this._authRepository);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  User? get currentUser => _authRepository?.currentUser;

  // Validar formato de email
  bool isValidEmail(String email) {
    return RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    ).hasMatch(email);
  }

  // Validar dominio institucional (QA CRÍTICO)
  bool isInstitutionalEmail(String email) {
    return email.trim().toLowerCase().endsWith(AppConstants.emailDomain);
  }

  Future<bool> login(String email, String password) async {
    // 1. Validaciones Locales
    if (email.isEmpty || password.isEmpty) {
      _errorMessage = 'Por favor, completa todos los campos.';
      notifyListeners();
      return false;
    }

    // 2. Validación de Dominio (Antes de enviar a Firebase)
    if (!isInstitutionalEmail(email)) {
      _errorMessage = 'Solo correos institucionales (@continental.edu.pe)';
      notifyListeners();
      return false;
    }

    // 3. Intento de Login
    return _performLogin(() async {
      final repo = _authRepository;
      if (repo != null) {
        await repo.login(email.trim(), password);
      }
    });
  }

  Future<bool> loginWithGoogle() async {
    return _performLogin(() async {
      final repo = _authRepository;
      if (repo == null) return;

      // 1. Intentar Login con Google
      final credential = await repo.loginWithGoogle();

      // 2. Verificar el email obtenido
      final email = credential.user?.email;
      if (email == null || !isInstitutionalEmail(email)) {
        // Logout inmediato si no cumple el dominio
        await repo.logout();
        throw Exception(
          'Solo correos institucionales (@continental.edu.pe). Tu cuenta de Google no cumple con este requisito.',
        );
      }
    });
  }

  Future<bool> _performLogin(Future<void> Function() loginAction) async {
    if (_authRepository == null) {
      _errorMessage = 'Repositorio no inicializado';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await loginAction();
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    try {
      await _authRepository?.logout();
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Error al cerrar sesión';
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
