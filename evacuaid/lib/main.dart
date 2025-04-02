// Important Packages
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:evacuaid/auth/firebase_auth_service.dart';
import 'dart:async';

// Imported Screens
import 'package:evacuaid/auth/blgu_user_login.dart';
import 'package:evacuaid/screens/blgu_user_option.dart';
import 'package:evacuaid/auth/blgu_user_register.dart';
import 'package:evacuaid/screens/campmanager_user_option.dart';
import 'package:evacuaid/screens/create_evac_center.dart';
import 'package:evacuaid/screens/family_list.dart';
import 'package:evacuaid/screens/evac_center_list.dart';
import 'package:evacuaid/screens/notifications.dart';
import 'package:evacuaid/screens/splash_screen.dart';
import 'package:evacuaid/screens/summary.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

// Helper class to convert auth state Stream to a ChangeNotifier
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners(); // Initial notification
    _subscription = stream.listen(
      (_) => notifyListeners(),
    );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final FirebaseAuthService _authService;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _authService = FirebaseAuthService();
    
    _router = GoRouter(
      initialLocation: '/',
      refreshListenable: GoRouterRefreshStream(_authService.authStateChanges),
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
          builder: (context, state) => const BlguNotifications(),
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
        // Check if the user is logged in
        final isLoggedIn = _authService.currentUser != null;
        
        // Check if we're on login, register, or splash routes
        final isLoggingIn = state.matchedLocation == '/login';
        final isRegistering = state.matchedLocation == '/register';
        final isSplash = state.matchedLocation == '/';
        
        // Allow access to splash, login and register pages regardless of auth state
        if (isSplash || isLoggingIn || isRegistering) {
          return null;
        }

        // If not logged in, redirect to login
        if (!isLoggedIn) {
          return '/login';
        }
        
        // No redirection needed
        return null;
      },
      debugLogDiagnostics: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
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
          background: Colors.white,
          onBackground: Color(0xff212121),
        ),
      ),
    );
  }
}