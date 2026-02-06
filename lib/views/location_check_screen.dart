import 'package:contidecide/core/constants.dart';
import 'package:contidecide/viewmodels/location_viewmodel.dart';
import 'package:contidecide/views/voting_dashboard.dart'; // Final Step
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LocationCheckScreen extends StatefulWidget {
  const LocationCheckScreen({super.key});

  @override
  State<LocationCheckScreen> createState() => _LocationCheckScreenState();
}

class _LocationCheckScreenState extends State<LocationCheckScreen> {
  @override
  Widget build(BuildContext context) {
    // Escuchar cambios en el ViewModel
    final locationViewModel = Provider.of<LocationViewModel>(context);

    // Navegación automática al éxito (opcional, pero mejor con botón explícito por UX)
    // Aquí solo reconstruimos la UI basada en el estado.

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Validación de Ubicación",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false, // Bloquear Back
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 1. Icono de Estado
              _buildLocationIcon(locationViewModel.status),
              const SizedBox(height: 32),

              // 2. Título de Estado
              Text(
                _getStatusTitle(locationViewModel.status),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D2D2D),
                ),
              ),
              const SizedBox(height: 12),

              // 3. Descripción / Error
              if (locationViewModel.errorMessage != null)
                Text(
                  locationViewModel.errorMessage!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.error, fontSize: 16),
                )
              else
                Text(
                  _getStatusDescription(locationViewModel.status),
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey, fontSize: 16),
                ),

              const SizedBox(height: 48),

              // 4. Botón de Acción
              if (locationViewModel.status == LocationStatus.loading)
                const CircularProgressIndicator(color: AppColors.primary)
              else if (locationViewModel.status == LocationStatus.validLocation)
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      // Navegar a Votación (Último paso)
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (_) => const VotingDashboard(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.success, // Verde éxito
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Ingresar a votación",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                )
              else
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      locationViewModel.validateLocation();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      locationViewModel.status == LocationStatus.initial
                          ? "Permitir ubicación"
                          : "Reintentar",
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLocationIcon(LocationStatus status) {
    IconData iconData;
    Color color;

    switch (status) {
      case LocationStatus.validLocation:
        iconData = Icons.check_circle_outline;
        color = AppColors.success;
        break;
      case LocationStatus.error:
      case LocationStatus.permissionDenied:
      case LocationStatus.gpsDisabled:
      case LocationStatus.outOfRange:
        iconData = Icons.location_off_outlined;
        color = AppColors.error;
        break;
      default:
        iconData = Icons.location_on_outlined;
        color = AppColors.primary;
    }

    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(iconData, size: 60, color: color),
    );
  }

  String _getStatusTitle(LocationStatus status) {
    switch (status) {
      case LocationStatus.initial:
        return "Confirmar ubicación";
      case LocationStatus.loading:
        return "Validando posición satelital...";
      case LocationStatus.validLocation:
        return "Estás dentro del campus";
      case LocationStatus.outOfRange:
        return "Fuera de zona permitida";
      case LocationStatus.gpsDisabled:
        return "GPS Desactivado";
      case LocationStatus.permissionDenied:
        return "Permiso denegado";
      default:
        return "Error de ubicación";
    }
  }

  String _getStatusDescription(LocationStatus status) {
    switch (status) {
      case LocationStatus.initial:
        return "Para garantizar la transparencia, necesitamos verificar que te encuentras dentro del campus universitario.";
      case LocationStatus.loading:
        return "Por favor espera un momento...";
      case LocationStatus.validLocation:
        return "Verificación exitosa. Puedes proceder a emitir tu voto.";
      default:
        return "";
    }
  }
}
