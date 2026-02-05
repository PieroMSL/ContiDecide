import 'package:geolocator/geolocator.dart';

class LocationService {
  // Verificar si el servicio de ubicación está habilitado
  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  // Verificar y solicitar permisos
  Future<LocationPermission> checkPermission() async {
    return await Geolocator.checkPermission();
  }

  Future<LocationPermission> requestPermission() async {
    return await Geolocator.requestPermission();
  }

  // Obtener posición actual con alta precisión
  Future<Position> getCurrentPosition() async {
    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 10),
      ),
    );
  }

  // Calcular distancia entre dos coordenadas (en metros)
  double distanceBetween(
    double startLat,
    double startLng,
    double endLat,
    double endLng,
  ) {
    return Geolocator.distanceBetween(startLat, startLng, endLat, endLng);
  }

  // Abrir configuración si es necesario
  Future<bool> openLocationSettings() async {
    return await Geolocator.openLocationSettings();
  }
}
