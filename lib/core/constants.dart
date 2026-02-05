import 'package:flutter/material.dart';

class AppConstants {
  // Supabase
  static const String supabaseUrl = 'https://txuxpqibjszxhycambkw.supabase.co';
  static const String supabaseAnonKey =
      'sb_publishable_6tHaWFUBdekWxB6IZyXdCg_Lw1PIusI';

  // Geolocation - Universidad Continental (Huancayo)
  static const double ucLat = -12.0431;
  static const double ucLng = -75.2117;
  static const double maxDistanceMeters = 300.0;

  // Validation
  static const String emailDomain = '@continental.edu.pe';
}

class AppColors {
  static const Color primary = Color(
    0xFF7D1126,
  ); // Guinda Universidad Continental
  static const Color secondary = Color(0xFF2C3E50); // Azul Oscuro
  static const Color background = Color(0xFFF5F5F5); // Gris suave
  static const Color surface = Color(0xFFFFFFFF); // Blanco
  static const Color error = Color(0xFFB00020); // Material Error
  static const Color success = Color(0xFFF1C40F); // Dorado sutil / Acento
}

class AppTextStyles {
  // Se definirán en el Theme, pero pueden haber referencias aquí si es necesario
}
