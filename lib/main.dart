import 'package:contidecide/repositories/auth_repository.dart';
import 'package:contidecide/repositories/vote_repository.dart';
import 'package:contidecide/services/auth_service.dart';
import 'package:contidecide/services/location_service.dart';
import 'package:contidecide/services/supabase_service.dart';
import 'package:contidecide/viewmodels/auth_viewmodel.dart';
import 'package:contidecide/viewmodels/location_viewmodel.dart';
import 'package:contidecide/viewmodels/vote_viewmodel.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/constants.dart';
import 'core/theme.dart';
import 'views/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar Supabase
  await Supabase.initialize(
    url: AppConstants.supabaseUrl,
    anonKey: AppConstants.supabaseAnonKey,
  );

  // Inicializar Firebase
  try {
    await Firebase.initializeApp();
    debugPrint('Firebase inicializado correctamente');
  } catch (e) {
    debugPrint('Fallo en inicialización de Firebase: $e');
    // En producción, aquí se enviaría a Crashlytics
  }

  runApp(const ContiDecideApp());
}

class ContiDecideApp extends StatelessWidget {
  const ContiDecideApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Services
        Provider<AuthService>(create: (_) => AuthService()),
        Provider<SupabaseService>(create: (_) => SupabaseService()),
        Provider<LocationService>(create: (_) => LocationService()),

        // Repositories (depend on Services)
        ProxyProvider<AuthService, AuthRepository>(
          update: (_, authService, __) => AuthRepository(authService),
        ),
        ProxyProvider<SupabaseService, VoteRepository>(
          update: (_, supabaseService, __) => VoteRepository(supabaseService),
        ),

        // ViewModels (depend on Repositories/Services)
        ChangeNotifierProxyProvider<AuthRepository, AuthViewModel>(
          create: (_) => AuthViewModel(null), // Initial null, updated by proxy
          update: (_, repo, prev) => AuthViewModel(repo),
        ),
        ChangeNotifierProxyProvider<VoteRepository, VoteViewModel>(
          create: (_) => VoteViewModel(null),
          update: (_, repo, prev) => VoteViewModel(repo),
        ),
        ChangeNotifierProvider(create: (_) => LocationViewModel()),
      ],
      child: MaterialApp(
        title: 'ContiDecide',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const SplashScreen(),
      ),
    );
  }
}
