import 'package:contidecide/viewmodels/auth_viewmodel.dart';
import 'package:contidecide/views/login_screen.dart';
import 'package:contidecide/views/profile_verification_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    // Escucha activamente el estado de autenticación via ViewModel o Repository
    final authViewModel = Provider.of<AuthViewModel>(context);

    // NOTA: AuthViewModel debería exponer el estado actual del usuario (User?)
    // que viene del repositorio->servicio.

    // Si hay usuario logueado -> Verificación de Perfil
    if (authViewModel.currentUser != null) {
      return const ProfileVerificationScreen();
    }

    // Si NO hay usuario -> Pantalla de Login
    return const LoginScreen();
  }
}
