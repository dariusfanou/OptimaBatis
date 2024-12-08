import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:optimabatis/pages/welcome.dart';

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
          onLoaded: (composition) {
            // Après la fin de l'animation, passez à la page suivante
            Future.delayed(Duration(seconds: 3), () {
              Navigator.push(
                context,
                  MaterialPageRoute(builder: (context) {
                    return WelcomePage();
                  })
              );
            });
          },
        ),
      ),
    );
  }
}
