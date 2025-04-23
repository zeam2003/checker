import 'package:checker/features/tickets/presentation/screens/ticket_selection_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/landing/presentation/screens/landing_screen.dart';
import '../../features/checks/presentation/screens/check_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/landing',
        builder: (context, state) => const LandingScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/check/:type',
        builder: (context, state) {
          final checkType = state.pathParameters['type'] ?? 'complete';
          return CheckScreen(checkType: checkType);
        },
      ),
    ],
  );
});