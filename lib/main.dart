import 'package:flutter/material.dart';
import 'package:ekskulku/core/constants/constants.dart';
import 'package:ekskulku/services/services.dart';
import 'package:go_router/go_router.dart';
import 'package:ekskulku/presentation/screens/landing_screen.dart';
import 'package:ekskulku/presentation/screens/auth/school_auth_screen.dart';
import 'package:ekskulku/presentation/screens/auth/student_auth_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Supabase
  await SupabaseService.initialize();
  
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = _createRouter();
  }

  GoRouter _createRouter() {
    return GoRouter(
      initialLocation: '/',
      routes: [
        // Landing page
        GoRoute(
          path: '/',
          builder: (context, state) => const LandingScreen(),
        ),
        
        // Auth routes
        GoRoute(
          path: '/auth/school',
          builder: (context, state) => const SchoolAuthScreen(),
        ),
        GoRoute(
          path: '/auth/student',
          builder: (context, state) => const StudentAuthScreen(),
        ),
        
        // School routes
        GoRoute(
          path: '/school/dashboard',
          builder: (context, state) => const Scaffold(
            body: Center(child: Text('School Dashboard - Coming Soon')),
          ),
        ),
        
        // Student routes
        GoRoute(
          path: '/student/dashboard',
          builder: (context, state) => const Scaffold(
            body: Center(child: Text('Student Dashboard - Coming Soon')),
          ),
        ),
      ],
      redirect: (context, state) async {
        // Check if user is logged in
        final isLoggedIn = AuthService.isLoggedIn;
        final isAuthRoute = state.matchedLocation.startsWith('/auth');
        final isLandingRoute = state.matchedLocation == '/';
        
        if (!isLoggedIn && !isAuthRoute && !isLandingRoute) {
          return '/';
        }
        
        if (isLoggedIn && (isAuthRoute || isLandingRoute)) {
          final userType = await AuthService.getUserType();
          if (userType == UserType.school) {
            return '/school/dashboard';
          } else if (userType == UserType.student) {
            return '/student/dashboard';
          }
        }
        
        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppConstants.appName,
      theme: AppTheme.lightTheme,
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}
