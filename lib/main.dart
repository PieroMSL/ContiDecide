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

// Dummy stubs for initial compilation before actual implementation
// These will be replaced by actual files in the next steps
// but we need them imported to make main.dart valid or we create empty ones now.
// Strategy: I will generate the empty placeholders for the imported files immediately after this
// to avoid compilation errors if the user tries to run it.

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  await Supabase.initialize(
    url: AppConstants.supabaseUrl,
    anonKey: AppConstants.supabaseAnonKey,
  );

  // Initialize Firebase
  try {
    await Firebase.initializeApp();
    debugPrint('Firebase initialized successfully');
  } catch (e) {
    debugPrint('Firebase initialization failed: $e');
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
