import 'package:evacuaid/screens/blgu_user_login.dart';
import 'package:evacuaid/screens/blgu_user_option.dart';
import 'package:evacuaid/screens/blgu_user_register.dart';
import 'package:evacuaid/screens/campmanager_user_option.dart';
import 'package:evacuaid/screens/create_evac_center.dart';
import 'package:evacuaid/screens/family_list.dart';
import 'package:evacuaid/screens/evac_center_list.dart';
import 'package:evacuaid/screens/notifications.dart';
import 'package:evacuaid/screens/splash_screen.dart';
import 'package:evacuaid/screens/summary.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
      name: 'centers',
      path: '/centers',
      builder: (context, state) => BlguEvacCenterList(),
      routes: <RouteBase>[
        GoRoute(
          name: 'establish_evac',
          path: 'establish_evac',
          builder: (context, state) => BlguCreateEvacCenter(),
        ),
      ],
    ),
    GoRoute(
      name: 'notifications',
      path: '/notifications',
      builder: (context, state) => BlguNotifications(),
    ),
    GoRoute(
      name: 'centers',
      path: '/centers',
      builder: (context, state) => BlguEvacCenterList(),
      routes: <RouteBase>[
        GoRoute(
          name: 'establish_evac',
          path: 'establish_evac',
          builder: (context, state) => BlguCreateEvacCenter(),
        ),
      ],
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
          onPrimary: Colors.white,
          secondary: Color(0xffD10438),
          onSecondary: Colors.white,
          error: Color(0xffff3333),
          onError: Colors.white,
          surface: Colors.white,
          onSurface: Color(0xff212121),
          outline: Color(0xffE5E5E5),
          surfaceContainer: Color(0xffF4F4F4),
          surfaceContainerLow: Color(0xffD9D9D9),
        ),
        textTheme: TextTheme(
          headlineSmall: TextStyle(
            fontSize: 28,
            color: Color(0xff000000),
            fontWeight: FontWeight.bold,
          ),
          titleLarge: TextStyle(
            fontSize: 20,
            color: Color(0xff000000),
            fontWeight: FontWeight.w500,
          ),
          titleMedium: TextStyle(
            fontSize: 20,
            color: Color(0xff212121),
            fontStyle: FontStyle.italic,
          ),
          titleSmall: TextStyle(
            fontSize: 16,
            color: Color(0xff212121),
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    ));
  }
}