import 'package:go_router/go_router.dart';

import '../screens/accessibility_screen.dart';
import '../screens/help_screen.dart';
import '../screens/home_screen.dart';
import '../screens/info_screen.dart';
import '../screens/language_screen.dart';
import '../screens/map_screen.dart';
import '../screens/splash_screen.dart';

class AppRoutes {
  static const String splash = '/splash';
  static const String language = '/language';
  static const String home = '/home';
  static const String map = '/map';
  static const String help = '/help';
  static const String info = '/info';
  static const String accessibility = '/accessibility';
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      name: 'splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: AppRoutes.language,
      name: 'language',
      builder: (context, state) => const LanguageScreen(),
    ),
    GoRoute(
      path: AppRoutes.home,
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: AppRoutes.map,
      name: 'map',
      builder: (context, state) => const MapScreen(),
    ),
    GoRoute(
      path: AppRoutes.help,
      name: 'help',
      builder: (context, state) => const HelpScreen(),
    ),
    GoRoute(
      path: AppRoutes.info,
      name: 'info',
      builder: (context, state) => const InfoScreen(),
    ),
    GoRoute(
      path: AppRoutes.accessibility,
      name: 'accessibility',
      builder: (context, state) => const AccessibilityScreen(),
    ),
  ],
);
