import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Stream para cambios de estado de autenticación
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  // Obtener usuario actual
  User? get currentUser => _firebaseAuth.currentUser;

  // Login con Email y Password
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      return await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthError(e);
    } catch (e) {
      throw Exception(
        'Ocurrió un error inesperado durante el inicio de sesión.',
      );
    }
  }

  // Login con Google
  Future<UserCredential> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        throw Exception('El inicio de sesión con Google fue cancelado.');
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google User Credentials
      return await _firebaseAuth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthError(e);
    } catch (e) {
      if (e.toString().contains('cancelado')) rethrow;
      throw Exception('Error al iniciar sesión con Google: $e');
    }
  }

  // Cerrar sesión
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _firebaseAuth.signOut();
  }

  // Manejo de errores amigables (Español)
  Exception _handleFirebaseAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return Exception('No existe una cuenta con este correo.');
      case 'wrong-password':
        return Exception('La contraseña es incorrecta.');
      case 'invalid-email':
        return Exception('El formato del correo no es válido.');
      case 'user-disabled':
        return Exception('Esta cuenta ha sido deshabilitada.');
      case 'too-many-requests':
        return Exception('Demasiados intentos fallidos. Inténtalo más tarde.');
      case 'network-request-failed': // CP-20 Error sin conexión
        return Exception('Sin conexión a internet. Verifica tu red.');
      case 'credential-already-in-use':
        return Exception('Esta cuenta ya está vinculada a otro usuario.');
      default:
        return Exception('Error de autenticación: ${e.message}');
    }
  }
}
