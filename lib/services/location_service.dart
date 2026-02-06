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

  // Obtener posición actual con configuración robusta
  Future<Position> getCurrentPosition() async {
    // Configuración específica para Android
    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    );

    // Si es Android, usamos configuraciones específicas
    /* 
    // Nota: Para usar AndroidSettings se requiere importar geolocator_android
    // pero el paquete base geolocator ya abstrae bastante.
    // Simplemente aumentaremos el timeout y aseguraremos la precisión.
    */

    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        timeLimit: Duration(
          seconds: 15,
        ), // Aumentar timeout por si es emulador lento
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
