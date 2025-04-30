import 'package:checker/features/checks/presentation/screens/new_ticket_screen.dart';
import 'package:checker/features/tickets/presentation/screens/ticket_selection_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/providers/user_session_provider.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/landing/presentation/screens/landing_screen.dart';
import '../../features/checks/presentation/screens/check_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final userSessionState = ref.watch(userSessionProvider);

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final isLoggedIn = userSessionState != null;
      final isGoingToLogin = state.matchedLocation == '/login';

      // Si no está autenticado y no va al login, redirigir al login
      if (!isLoggedIn && !isGoingToLogin) {
        return '/login';
      }

      // Si está autenticado y va al login, redirigir a home
      if (isLoggedIn && isGoingToLogin) {
        return '/';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const LandingScreen(),
      ),
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
      // Eliminar la ruta duplicada y agregar la ruta correcta para 'complete/new'
      GoRoute(
        path: '/checks/complete/new',
        builder: (context, state) {
          return const NewTicketScreen(checkType: 'complete');
        },
      ),
      GoRoute(
        path: '/check/:type/new',
        builder: (context, state) {
          final checkType = state.pathParameters['type'] ?? 'complete';
          return NewTicketScreen(checkType: checkType);
        },
      ),
    ],
  );
});
