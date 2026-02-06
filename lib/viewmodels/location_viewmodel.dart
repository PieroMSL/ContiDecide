import 'dart:async'; // Importación correcta para TimeoutException

import 'package:contidecide/core/constants.dart';
import 'package:contidecide/services/location_service.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

enum LocationStatus {
  initial,
  loading,
  permissionDenied,
  gpsDisabled,
  outOfRange,
  validLocation,
  error,
}

class LocationViewModel extends ChangeNotifier {
  final LocationService _locationService = LocationService();

  LocationStatus _status = LocationStatus.initial;
  LocationStatus get status => _status;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // Validar ubicación (Regla de negocio principal)
  Future<bool> validateLocation() async {
    _status = LocationStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      // 1. CP-08 GPS Apagado
      bool serviceEnabled = await _locationService.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _status = LocationStatus.gpsDisabled;
        _errorMessage = "El GPS está desactivado. Actívalo para continuar.";
        notifyListeners();
        // Intentar abrir configuración (opcional)
        // await _locationService.openLocationSettings();
        return false;
      }

      // 2. CP-09 Permisos (Lógica solicitada)
      LocationPermission permission = await _locationService.checkPermission();

      if (permission == LocationPermission.denied) {
        // Solicitar permisos explícitamente para que salga el pop-up
        permission = await _locationService.requestPermission();

        if (permission == LocationPermission.denied) {
          _status = LocationStatus.permissionDenied;
          _errorMessage = "Permiso de ubicación denegado.";
          notifyListeners();
          return false;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _status = LocationStatus.permissionDenied;
        _errorMessage =
            "Permisos denegados permanentemente. Habilítalos en configuración.";
        notifyListeners();
        return false;
      }

      // 3. Obtener Ubicación (Con TimeoutException de Dart)
      Position position = await _locationService.getCurrentPosition();

      // 4. Defensa: Detección de Fake GPS / Mock Location
      if (position.isMocked) {
        _status = LocationStatus.error;
        _errorMessage =
            "Ubicación simulada detectada (Fake GPS). Por seguridad, usa un dispositivo real sin simuladores.";
        notifyListeners();
        return false;
      }

      // 5. Calcular Distancia (Geofencing)
      double distance = _locationService.distanceBetween(
        position.latitude,
        position.longitude,
        AppConstants.ucLat,
        AppConstants.ucLng,
      );

      // 5. Validar Rango (CP-06 Fuera, CP-07 Dentro)
      if (distance > AppConstants.maxDistanceMeters) {
        _status = LocationStatus.outOfRange;
        _errorMessage =
            "Estás fuera del campus (${distance.toStringAsFixed(0)}m). Acércate a la universidad.";
        notifyListeners();
        return false;
      }

      // Éxito
      _status = LocationStatus.validLocation;
      notifyListeners();
      return true;
    } on TimeoutException catch (_) {
      // Excepción nativa de Dart
      _status = LocationStatus.error;
      _errorMessage = "Tiempo de espera agotado. Verifica tu señal GPS.";
      notifyListeners();
      return false;
    } catch (e) {
      _status = LocationStatus.error;
      _errorMessage = "Error: $e";
      notifyListeners();
      return false;
    }
  }

  void resetStatus() {
    _status = LocationStatus.initial;
    _errorMessage = null;
    notifyListeners();
  }
}
