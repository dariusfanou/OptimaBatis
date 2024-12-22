import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:optimabatis/auth_provider.dart';
import 'package:optimabatis/pages/activity_onload.dart';
import 'package:optimabatis/pages/description_date.dart';
import 'package:optimabatis/pages/detail_intervention.dart';
import 'package:optimabatis/pages/document_photos.dart';
import 'package:optimabatis/pages/edit_profile.dart';
import 'package:optimabatis/pages/email.dart';
import 'package:optimabatis/pages/felicitation.dart';
import 'package:optimabatis/pages/help.dart';
import 'package:optimabatis/pages/home.dart';
import 'package:optimabatis/pages/informatique.dart';
import 'package:optimabatis/pages/notification.dart';
import 'package:optimabatis/pages/password.dart';
import 'package:optimabatis/pages/password_creation.dart';
import 'package:optimabatis/pages/personal_datas.dart';
import 'package:optimabatis/pages/preference.dart';
import 'package:optimabatis/pages/profile.dart';
import 'package:optimabatis/pages/publicite.dart';
import 'package:optimabatis/pages/splash_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:optimabatis/pages/verification.dart';
import 'package:optimabatis/pages/welcome.dart';
import 'package:provider/provider.dart';

// GoRouter configuration
final _router = GoRouter(
  initialLocation: '/',
  redirect: (context, state) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final isAuthenticated = authProvider.isAuthenticated;

    // Si l'utilisateur est authentifié, ne redirigez pas vers /home si la destination est déjà la page d'accueil
    if (isAuthenticated && (state.uri.toString() == '/authentication' || state.uri.toString() == '/email')) {
      return '/home'; // Rediriger vers /home si l'utilisateur est authentifié et essaie d'accéder à /welcome
    }

    // Si l'utilisateur n'est pas authentifié, ne redirigez pas vers /welcome si la destination est déjà la page de bienvenue
    if (!isAuthenticated && state.uri.toString() == '/profile') {
      return '/welcome'; // Rediriger vers /welcome si l'utilisateur n'est pas authentifié
    }

    return null; // Pas de redirection si l'utilisateur est déjà à la bonne page
  },
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);

        return FutureBuilder(
          future: Future.delayed(const Duration(seconds: 3)),  // Attente de 3 secondes
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              // Utilisez WidgetsBinding pour effectuer la navigation après la construction
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (authProvider.isAuthenticated) {
                  // Si authentifié, redirige vers la page d'accueil
                  context.go('/home');
                } else {
                  // Si non authentifié, redirige vers la page de bienvenue
                  context.go('/welcome');
                }
              });
              return const SplashScreen();
            }
            return const SplashScreen();  // Afficher l'écran de splash pendant le délai
          },
        );
      },
    ),
    GoRoute(
      path: '/welcome',
      builder: (context, state) => WelcomePage(),
    ),
    GoRoute(
      path: '/authentication',
      builder: (context, state) => PasswordPage(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => HomePage(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => ProfilePage(),
    ),
    GoRoute(
      path: '/help',
      builder: (context, state) => Help(),
    ),
    GoRoute(
      path: '/numberVerification',
      builder: (context, state) => VerificationPage(),
    ),
    GoRoute(
      path: '/editProfile',
      builder: (context, state) => EditProfile(),
    ),
    GoRoute(
      path: '/notifications',
      builder: (context, state) => NotificationPage(),
    ),
    GoRoute(
      path: '/activities',
      builder: (context, state) => Activity_onload(),
    ),
    GoRoute(
      path: '/pub',
      builder: (context, state) => Publicite(),
    ),
    GoRoute(
      path: '/createPassword',
      builder: (context, state) => CreatePassword(),
    ),
    GoRoute(
      path: '/personalDatas',
      builder: (context, state) => PersonalDatas(),
    ),
    GoRoute(
      path: '/email',
      builder: (context, state) => EmailPage(),
    ),
    GoRoute(
      path: '/typeDemande',
      builder: (context, state) {
        final service = state.uri.queryParameters['service'];
        return DetailsInterventionPage(service: service);
      },
    ),
    GoRoute(
      path: '/describeIntervention',
      builder: (context, state) => Description(),
    ),
    GoRoute(
      path: '/takePictures',
      builder: (context, state) => DocumentPhotoPage(),
    ),
    GoRoute(
      path: '/congratulations',
      builder: (context, state) => Felicitation(),
    ),
    GoRoute(
      path: '/informatique',
      builder: (context, state) => Informatique(),
    ),
    GoRoute(
      path: '/preference',
      builder: (context, state) => Preference(),
    ),
  ],
);

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          final currentLocation = GoRouter.of(context).routeInformationProvider.value.uri.toString();
          if (currentLocation == '/home' || currentLocation == '/welcome') {
            // Si l'utilisateur est sur la page d'accueil ou la page de bienvenue
            return true; // Quitte l'application
          } else {
            GoRouter.of(context).pop(); // Revient à la page précédente
            return false; // Intercepte le retour
          }
        },
        child: MaterialApp.router(
          routerConfig: _router,
          title: 'OptimaBâtis',
          theme: ThemeData(
            scaffoldBackgroundColor: Colors.white,
            colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF3172B8)),
            useMaterial3: true,
            fontFamily: "Poppins",
          ),
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('fr'), // Français
          ],
          locale: const Locale('fr'),
        )
    );
  }
}
