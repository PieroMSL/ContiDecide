import 'package:contidecide/core/constants.dart';
import 'package:contidecide/viewmodels/auth_viewmodel.dart';
import 'package:contidecide/views/profile_verification_screen.dart'; // Next step
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Manejo centralizado del login exitoso
  Future<void> _handleLoginSuccess() async {
    if (mounted) {
      // Navegación directa a Verificación de Perfil (NO dashboard)
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const ProfileVerificationScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

    // Pantalla limpia y centrada
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 1. Logo Institucional (Top)
                Container(
                  width: 180, // Tamaño adecuado
                  height: 180,
                  margin: const EdgeInsets.only(bottom: 60),
                  child: Image.asset(
                    'assets/images/Logo_Continental.png',
                    fit: BoxFit.contain,
                  ),
                ),

                // Título de bienvenida opcional (o eliminar según gusto minimalista)
                Text(
                  "Bienvenido",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary, // Guinda
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Ingresa con tu cuenta institucional",
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
                const SizedBox(height: 48),

                // 2. Mensaje de Error (si existe)
                if (authViewModel.errorMessage != null)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 24),
                    decoration: BoxDecoration(
                      color: AppColors.error.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.error),
                    ),
                    child: Text(
                      authViewModel.errorMessage!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppColors.error,
                        fontSize: 14,
                      ),
                    ),
                  ),

                // 3. Botón Único: Google
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton(
                    onPressed: authViewModel.isLoading
                        ? null
                        : () async {
                            final success = await authViewModel
                                .loginWithGoogle();
                            if (success) {
                              await _handleLoginSuccess();
                            }
                          },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF2D2D2D), // Texto oscuro
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: Colors.grey), // Borde suave
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: authViewModel.isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.grey,
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Logo de Google (simulado con texto o icono si no hay asset específico de Google)
                              // Idealmente usar 'assets/images/google_logo.png' si existiera,
                              // por ahora usaremos un texto estilizado o icono.
                              // El prompt pedía "Logo oficial de Google a color",
                              // como no tengo el asset, usaré un hack visual o Icono genérico
                              // ya que no puedo crear imagenes de marcas registradas.
                              // Asumiremos que el usuario prefiere limpieza.
                              const Text(
                                "G ",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.blue,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                "Ingresar con Google",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),

                const SizedBox(height: 24),

                // Footer Institucional
                const Text(
                  "Ingeniería de Sistemas – Universidad Continental",
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
