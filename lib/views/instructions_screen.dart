import 'package:contidecide/core/constants.dart';
import 'package:contidecide/views/location_check_screen.dart'; // Next Step
import 'package:flutter/material.dart';

class InstructionsScreen extends StatelessWidget {
  const InstructionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Instrucciones",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false, // Bloquear Back
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "Antes de votar, por favor lee atentamente:",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D2D2D),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // Paso 1
              _buildInstructionStep(
                context,
                icon: Icons.people_outline,
                title: "Revisa los candidatos",
                description:
                    "Al ingresar verás la lista de candidatos disponibles con sus propuestas.",
              ),
              const SizedBox(height: 24),

              // Paso 2
              _buildInstructionStep(
                context,
                icon: Icons.how_to_vote_outlined,
                title: "Elige a tu representante",
                description:
                    "Selecciona cuidadosamente. Solo podrás emitir un voto y no se podrá cambiar.",
              ),
              const SizedBox(height: 24),

              // Paso 3
              _buildInstructionStep(
                context,
                icon: Icons.security,
                title: "Voto único y seguro",
                description:
                    "Tu voto es anónimo y se registra de forma segura en nuestro sistema.",
              ),

              const Spacer(),

              // Botón Continuar
              SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    // Ir a validación de Ubicación
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (_) => const LocationCheckScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary, // Guinda
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: const Text(
                    "Entendido, validar ubicación",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInstructionStep(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColors.primary, size: 28),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D2D2D),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
