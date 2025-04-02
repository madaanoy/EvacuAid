import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:evacuaid/auth/firebase_auth_service.dart';

// Screens
import 'package:evacuaid/screens/blguCreateEvacCenter.dart';
import 'package:evacuaid/screens/blguFamilyList.dart';
import 'package:evacuaid/screens/blgunotifications.dart';
import 'package:evacuaid/screens/blgusummary.dart';
import 'package:evacuaid/screens/splash_screen.dart';
import 'package:evacuaid/screens/blgu_user_option.dart';
import 'package:evacuaid/screens/campmanager_user_option.dart';
import 'package:evacuaid/auth/blgu_user_register.dart';
import 'package:evacuaid/auth/blgu_user_login.dart';

final _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      name: 'splash',
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      name: 'summary',
      path: '/summary',
      builder: (context, state) => const BlguSummary(),
    ),
    GoRoute(
      name: 'families',
      path: '/families',
      builder: (context, state) => const BlguFamilyList(),
    ),
    GoRoute(
      name: 'notifications',
      path: '/notifications',
      builder: (context, state) => const BlguNotifications(),
    ),
    GoRoute(
      name: 'centers',
      path: '/centers',
      builder: (context, state) => const BlguCreateEvacCenter(),
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
  redirect: (context, state) {
    final authService = FirebaseAuthService();
    // Add redirection logic based on authentication state
    final isLoggedIn = authService.currentUser != null;
    // Use fullPath property instead of location
    final isLoginRoute = state.fullPath == '/login';
    
    // If not logged in and not on login page, redirect to login
    if (!isLoggedIn && !isLoginRoute) {
      return '/login';
    }
    
    // If logged in and on login page, redirect to summary or home
    if (isLoggedIn && isLoginRoute) {
      return '/summary';
    }
    
    // No redirection needed
    return null;
  },
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
          primaryContainer: Color(0xff032A9E),
          onPrimary: Colors.white,
          secondary: Color(0xffD10438),
          secondaryContainer: Color(0xffA8032A),
          onSecondary: Colors.white,
          error: Color(0xffff3333),
          onError: Colors.white,
          surface: Colors.white,
          onSurface: Color(0xff212121),
        ),
      ),
    );
  }
}