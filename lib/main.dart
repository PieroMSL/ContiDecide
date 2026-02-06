import 'package:contidecide/core/constants.dart';
import 'package:contidecide/repositories/auth_repository.dart';
import 'package:contidecide/repositories/vote_repository.dart';
import 'package:contidecide/services/auth_service.dart';
import 'package:contidecide/services/supabase_service.dart';
import 'package:contidecide/viewmodels/auth_viewmodel.dart';
import 'package:contidecide/viewmodels/location_viewmodel.dart';
import 'package:contidecide/viewmodels/vote_viewmodel.dart';
import 'package:contidecide/views/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  String? initializationError;
  bool firebaseInitialized = false;

  // 1. Inicializar Firebase (CRÍTICO)
  try {
    await Firebase.initializeApp();
    firebaseInitialized = true;
    debugPrint('✅ Firebase initialized successfully');
  } catch (e) {
    debugPrint('❌ Firebase initialization failed: $e');
    initializationError = 'Firebase Error: $e';
  }

  // 2. Inicializar Supabase (Solo si Firebase ok, o intentar de todas formas pero manejar error)
  // Nota: Si Firebase falla, la app igual va a ErrorApp, así que esto es secundario.
  if (firebaseInitialized) {
    try {
      await Supabase.initialize(
        url: AppConstants.supabaseUrl,
        anonKey: AppConstants.supabaseAnonKey,
      );
      debugPrint('✅ Supabase initialized successfully');
    } catch (e) {
      debugPrint('⚠️ Supabase initialization warning: $e');
      // No bloqueamos la app por Supabase, ya que VoteRepository maneja errores internos,
      // pero si el cliente necesita init, podría fallar al instanciarse.
      // Asumiremos que SupabaseService maneja sus excepciones o que el usuario puede hacer login aunque voto falle.
      // Sin embargo, para cumplir "No pantalla negra", seguimos.
    }
  }

  // 3. Ejecutar UI basada en estado
  if (firebaseInitialized) {
    runApp(const AppState());
  } else {
    runApp(
      InitializationErrorApp(error: initializationError ?? 'Unknown Error'),
    );
  }
}

/// Widget wrapper principal con Providers
class AppState extends StatelessWidget {
  const AppState({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Repositorios (Inyección explícita)
        // Se crean SOLO si estamos en AppState, lo que garantiza que Firebase ya inició.
        Provider<AuthRepository>(create: (_) => AuthRepository(AuthService())),
        Provider<VoteRepository>(
          create: (_) => VoteRepository(SupabaseService()),
        ),

        // ViewModels
        ChangeNotifierProvider<AuthViewModel>(
          create: (context) => AuthViewModel(context.read<AuthRepository>()),
        ),
        ChangeNotifierProvider<VoteViewModel>(
          create: (context) => VoteViewModel(context.read<VoteRepository>()),
        ),
        ChangeNotifierProvider<LocationViewModel>(
          create: (_) => LocationViewModel(),
        ),
      ],
      child: const MyApp(),
    );
  }
}

/// Aplicación Principal
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ContiDecide',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: const Color(0xFF7D1126), // Guinda Institucional
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF7D1126),
          primary: const Color(0xFF7D1126),
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
      ),
      home: const SplashScreen(), // Punto de entrada explícito
    );
  }
}

/// UI de Fallback para errores de inicialización
class InitializationErrorApp extends StatelessWidget {
  final String error;

  const InitializationErrorApp({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 60),
                const SizedBox(height: 16),
                const Text(
                  'Error de Inicialización',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Text(
                  error,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Por favor, reinicia la aplicación o contacta a soporte.',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
