import 'package:contidecide/core/constants.dart';
import 'package:contidecide/models/candidate.dart';
import 'package:contidecide/viewmodels/auth_viewmodel.dart';
import 'package:contidecide/viewmodels/vote_viewmodel.dart';
import 'package:contidecide/views/login_screen.dart'; // Para logout
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VotingDashboard extends StatefulWidget {
  const VotingDashboard({super.key});

  @override
  State<VotingDashboard> createState() => _VotingDashboardState();
}

class _VotingDashboardState extends State<VotingDashboard> {
  @override
  void initState() {
    super.initState();
    // Cargar candidatos al iniciar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authVM = context.read<AuthViewModel>();
      final voteVM = context.read<VoteViewModel>();
      if (authVM.currentUser?.email != null) {
        voteVM.loadData(authVM.currentUser!.email!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final voteViewModel = Provider.of<VoteViewModel>(context);
    final authViewModel = Provider.of<AuthViewModel>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Candidatos",
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true, // Estilo iOS/Moderno
        iconTheme: const IconThemeData(color: AppColors.primary),
        automaticallyImplyLeading: false, // Bloquear Back Navigation
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () async {
              await authViewModel.logout();
              if (context.mounted) {
                // Navegar a Login y limpiar historial
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: voteViewModel.isLoading
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              )
            : _buildContent(context, voteViewModel, authViewModel),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    VoteViewModel voteViewModel,
    AuthViewModel authViewModel,
  ) {
    // 1. Estado: Ya votó
    if (voteViewModel.hasVoted) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.check_circle_outline,
                color: AppColors.success,
                size: 100,
              ),
              const SizedBox(height: 24),
              const Text(
                "¡Voto Registrado!",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D2D2D),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                "Gracias por participar en las elecciones de Ingeniería de Sistemas.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
              const SizedBox(height: 48),
              SizedBox(
                width: 200,
                child: OutlinedButton(
                  onPressed: () async {
                    await authViewModel.logout();
                    if (context.mounted) {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                        (route) => false,
                      );
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.primary),
                  ),
                  child: const Text("Cerrar Sesión"),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // 2. Estado: Error de Carga
    if (voteViewModel.errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: AppColors.error, size: 60),
              const SizedBox(height: 16),
              Text(
                voteViewModel.errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.error),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (authViewModel.currentUser?.email != null) {
                    voteViewModel.loadData(authViewModel.currentUser!.email!);
                  }
                },
                child: const Text("Reintentar"),
              ),
            ],
          ),
        ),
      );
    }

    // 3. Estado: Lista de Candidatos
    if (voteViewModel.candidates.isEmpty) {
      return const Center(child: Text("No hay candidatos disponibles"));
    }

    return Column(
      children: [
        // Encabezado Informativo
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          color: Colors.grey.shade50,
          child: const Row(
            children: [
              Icon(Icons.info_outline, size: 20, color: Colors.grey),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  "Selecciona un candidato para votar.",
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ),
            ],
          ),
        ),

        // Lista
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: voteViewModel.candidates.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final candidate = voteViewModel.candidates[index];
              return _buildCandidateCard(
                context,
                candidate,
                voteViewModel,
                authViewModel,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCandidateCard(
    BuildContext context,
    Candidate candidate,
    VoteViewModel voteViewModel,
    AuthViewModel authViewModel,
  ) {
    return Card(
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                // Avatar / Foto
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    shape: BoxShape.circle,
                    image: candidate.imageUrl != null
                        ? DecorationImage(
                            image: NetworkImage(candidate.imageUrl!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: candidate.imageUrl == null
                      ? const Icon(Icons.person, color: Colors.grey)
                      : null,
                ),
                const SizedBox(width: 16),

                // Info Textual
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        candidate.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D2D2D),
                        ),
                      ),
                      if (candidate.description.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          candidate.description,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),

            // Botón Votar
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _confirmVote(
                    context,
                    candidate,
                    voteViewModel,
                    authViewModel,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "VOTAR",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmVote(
    BuildContext context,
    Candidate candidate,
    VoteViewModel voteViewModel,
    AuthViewModel authViewModel,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text("Confirmar Voto"),
        content: RichText(
          text: TextSpan(
            style: const TextStyle(color: Colors.black, fontSize: 16),
            children: [
              const TextSpan(text: "¿Estás seguro de votar por \n\n"),
              TextSpan(
                text: candidate.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const TextSpan(text: "?\n\nEsta acción no se puede deshacer."),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancelar", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx); // Cerrar diálogo
              voteViewModel.selectCandidate(candidate);
              if (authViewModel.currentUser?.email != null) {
                await voteViewModel.submitVote(
                  authViewModel.currentUser!.email!,
                );
                // El viewModel actualizará el estado a hasVoted = true
                // y la UI se reconstruirá mostrando la pantalla de éxito.
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: const Text("CONFIRMAR"),
          ),
        ],
      ),
    );
  }
}
