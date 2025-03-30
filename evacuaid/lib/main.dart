import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Screens
import 'package:evacuaid/screens/blguCreateEvacCenter.dart';
import 'package:evacuaid/screens/blguFamilyList.dart';
import 'package:evacuaid/screens/blgunotifications.dart';
import 'package:evacuaid/screens/blgusummary.dart';
import 'package:evacuaid/screens/splash_screen.dart';
import 'package:evacuaid/screens/blgu_user_option.dart';
import 'package:evacuaid/screens/campmanager_user_option.dart';
import 'package:evacuaid/screens/blgu_user_register.dart';
import 'package:evacuaid/screens/blgu_user_login.dart';

final _router = GoRouter(
  initialLocation: '/',
  routes: [
    // Splash screen route
    GoRoute(
      name: 'splash',
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      name: 'summary',
      path: '/summary',
      builder: (context, state) => BlguSummary(),
    ),
    GoRoute(
      name: 'families',
      path: '/families',
      builder: (context, state) => BlguFamilyList(),
    ),
    GoRoute(
      name: 'notifications',
      path: '/notifications',
      builder: (context, state) => BlguNotifications(),
    ),
    GoRoute(
      name: 'centers',
      path: '/centers',
      builder: (context, state) => BlguCreateEvacCenter(),
    ),
    GoRoute(
      name: 'blgu_option',
      path: '/blgu_option',
      builder: (context, state) => const BLGUScreen(),
    ),
    GoRoute(
      name: 'campmanager_option',
      path: '/campmanager_option',
      builder: (context, state) => const CampManagerScreen(),
    ),
    GoRoute(
      name: 'login',
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      name: 'register',
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
  ],
);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      theme: ThemeData(
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: Color(0xff0438D1),
          // Change this from primaryVariant to primaryContainer
          primaryContainer: Color(0xff032A9E),
          onPrimary: Colors.white,
          secondary: Color(0xffD10438),
          // Change this from secondaryVariant to secondaryContainer
          secondaryContainer: Color(0xffA8032A),
          onSecondary: Colors.white,
          error: Color(0xffff3333),
          onError: Colors.white,
          background: Colors.white,
          onBackground: Color(0xff212121),
          surface: Colors.white,
          onSurface: Color(0xff212121),
        ),
        // Rest of your theme configuration remains the same
      ),
    );
  }
}