import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

class AuthRepository {
  final AuthService _authService;

  AuthRepository(this._authService);

  // Escuchar estado de sesión
  Stream<User?> get authStateChanges => _authService.authStateChanges;

  // Usuario actual
  User? get currentUser => _authService.currentUser;

  // Login Email
  Future<UserCredential> login(String email, String password) async {
    return _authService.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // Login Google
  Future<UserCredential> loginWithGoogle() async {
    return _authService.signInWithGoogle();
  }

  // Logout
  Future<void> logout() async {
    return _authService.signOut();
  }
}
