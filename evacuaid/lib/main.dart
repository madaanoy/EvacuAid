// Important Packages
import 'dart:math' as developer;

import 'package:evacuaid/auth/campmanager_user_login.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:evacuaid/auth/firebase_auth_service.dart';
import 'dart:async';

// Imported Screens
import 'package:evacuaid/auth/blgu_user_login.dart';
import 'package:evacuaid/auth/blgu_user_register.dart';
import 'package:evacuaid/screens/create_evac_center.dart';
import 'package:evacuaid/screens/family_members_list.dart';
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
          // for dev
          builder: (context, state) => const BlguFamilyList(),
          // actual
          // builder: (context, state) => const SplashScreen(),
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
          routes: <RouteBase>[
            GoRoute(
              name: 'familyMembers',
              // path: '/familyMembers',
              path: '/familyMembers/:id',
              builder: (context, state) {
                // return BlguFamilyMembersList();
                final memberId = state.pathParameters['id'];
                return BlguFamilyMembersList(id: memberId!);
              },
            ),
          ]
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
          name: 'CMlogin',
          path: '/CMlogin',
          builder: (context, state) => const CMLoginScreen(),
        ),
        GoRoute(
          name: 'BLGUlogin',
          path: '/BLGUlogin',
          builder: (context, state) => const BLGULoginScreen(),
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
        scaffoldBackgroundColor: Colors.white,
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
          surface: Color(0xffF4F4F4),
          onSurface: Color(0xff212121),
          tertiary: Color(0xFF49B445),
          background: Colors.white,
          onBackground: Color(0xff212121),
        ),
      ),
    );
  }
}