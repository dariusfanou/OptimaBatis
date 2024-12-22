import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3172B8), // Couleur de fond
      body: Center(
        child: Lottie.asset(
          'assets/animations/logo.json',
          repeat: false,
        ),
      ),
    );
  }
}
