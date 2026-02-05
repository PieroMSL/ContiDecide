import 'package:contidecide/core/constants.dart';
import 'package:contidecide/viewmodels/auth_viewmodel.dart';
import 'package:contidecide/viewmodels/location_viewmodel.dart';
import 'package:contidecide/viewmodels/vote_viewmodel.dart';
import 'package:contidecide/views/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VoteScreen extends StatefulWidget {
  const VoteScreen({super.key});

  @override
  State<VoteScreen> createState() => _VoteScreenState();
}

class _VoteScreenState extends State<VoteScreen> {
  @override
  void initState() {
    super.initState();
    // Cargar datos al iniciar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authVM = Provider.of<AuthViewModel>(context, listen: false);
      final userEmail = authVM.currentUser?.email;
      if (userEmail != null) {
        Provider.of<VoteViewModel>(context, listen: false).loadData(userEmail);
      }
    });
  }

  void _handleLogout() async {
    final authVM = Provider.of<AuthViewModel>(context, listen: false);
    await authVM.logout();
    if (mounted) {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const LoginScreen()));
    }
  }

  Future<void> _handleVote() async {
    final locationVM = Provider.of<LocationViewModel>(context, listen: false);
    final voteVM = Provider.of<VoteViewModel>(context, listen: false);
    final authVM = Provider.of<AuthViewModel>(context, listen: false);

    // Blindaje: Verificar sesión activa antes de cualquier operación costosa
    if (authVM.currentUser == null) {
      _handleLogout(); // Redirige a login si perdió sesión
      return;
    }

    // 1. Validar Ubicación
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    final isValidLocation = await locationVM.validateLocation();

    // Cerrar dialog de carga
    if (mounted) Navigator.of(context).pop();

    if (!isValidLocation) {
      // Mostrar error de ubicación
      if (mounted && locationVM.errorMessage != null) {
        _showErrorDialog(locationVM.errorMessage!);
      }
      return;
    }

    // 2. Confirmación (Dialogo Obligatorio CP-13)
    if (!mounted) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Confirmar Voto"),
        content: Text(
          "¿Estás seguro de votar por ${voteVM.selectedCandidate?.name}?\n\nEsta acción no se puede deshacer.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text("CANCELAR"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text("CONFIRMAR"),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      // 3. Enviar Voto
      final email = authVM.currentUser?.email;
      if (email != null) {
        final success = await voteVM.submitVote(email);
        if (success) {
          // Éxito - El estado _hasVoted cambiará y la UI se actualizará
        } else if (mounted && voteVM.errorMessage != null) {
          _showErrorDialog(voteVM.errorMessage!);
        }
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.error_outline, color: AppColors.error),
            const SizedBox(width: 8),
            const Text("Atención"),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text("ENTENDIDO"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Escuchar cambios
    final voteVM = Provider.of<VoteViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Elecciones Continental"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _handleLogout,
            tooltip: "Cerrar Sesión",
          ),
        ],
      ),
      body: voteVM.isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildContent(voteVM),
    );
  }

  Widget _buildContent(VoteViewModel voteVM) {
    if (voteVM.hasVoted) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.check_circle_outline,
                size: 100,
                color: AppColors.success,
              ),
              const SizedBox(height: 24),
              Text(
                "¡Voto Registrado!",
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                "Gracias por participar en las elecciones estudiantiles.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      );
    }

    if (voteVM.errorMessage != null && !voteVM.isLoading) {
      // Mensaje de error (ej. carga fallida) con botón de reintentar
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.cloud_off, size: 60, color: Colors.grey),
            const SizedBox(height: 16),
            Text(voteVM.errorMessage!),
            TextButton(
              onPressed: () => voteVM.loadData(
                Provider.of<AuthViewModel>(
                      context,
                      listen: false,
                    ).currentUser?.email ??
                    '',
              ),
              child: const Text("REINTENTAR"),
            ),
          ],
        ),
      );
    }

    // Lista de Candidatos
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "Elige a tu candidato",
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: voteVM.candidates.length,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemBuilder: (context, index) {
              final candidate = voteVM.candidates[index];
              final isSelected = voteVM.selectedCandidate?.id == candidate.id;

              return Card(
                elevation: isSelected ? 8 : 2,
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: isSelected
                      ? const BorderSide(color: AppColors.primary, width: 2)
                      : BorderSide.none,
                ),
                child: InkWell(
                  onTap: () => voteVM.selectCandidate(candidate),
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        // Avatar / Imagen
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.grey.shade200,
                          child: Text(
                            candidate.name.substring(0, 1),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                candidate.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              if (candidate.description.isNotEmpty)
                                Text(
                                  candidate.description,
                                  style: TextStyle(color: Colors.grey[600]),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                            ],
                          ),
                        ),
                        if (isSelected)
                          const Icon(
                            Icons.check_circle,
                            color: AppColors.primary,
                            size: 30,
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        // Botón de Votar
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: voteVM.selectedCandidate == null
                  ? null // CP-12 Deshabilitado sin selección
                  : _handleVote, // Logic con geolocalización y confirmación
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                disabledBackgroundColor: Colors.grey.shade300,
              ),
              child: const Text(
                "VOTAR",
                style: TextStyle(fontSize: 16, letterSpacing: 1.2),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
