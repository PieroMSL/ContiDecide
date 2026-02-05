import 'package:flutter/material.dart';
import 'package:contidecide/core/constants.dart';
import 'package:contidecide/views/login_screen.dart'; // Will be created next

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _controller.forward();

    // Navigate to Login after animation + small delay
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        // TODO: Check auth state here to decide navigation (Login vs Vote)
        // For now, go to Login
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary, // Guinda Institucional
      body: Center(
        child: FadeTransition(
          opacity: _opacityAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Container(
                width: 200, // Reasonable size
                height: 200,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      'assets/images/logo_universidad_continental_uc.png',
                    ),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Optional: App Name or Loading Indicator if needed by design,
              // but design doc says "Logo blanco centrado" (image probably has text or just logo)
              // If the image is the one provided, it likely has the text 'Universidad Continental'.
            ],
          ),
        ),
      ),
    );
  }
}
