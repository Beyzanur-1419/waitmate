import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/splash/splash_screen.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/auth/login_screen.dart';
import '../../features/auth/register_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/home/facility_detail_screen.dart';
import '../../features/home/departments_screen.dart';
import '../../features/queue/queue_screen.dart';
import '../../features/notifications/notifications_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/games/games_hub_screen.dart';
import '../../features/admin/admin_dashboard_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (ctx, state) => const SplashScreen()),
      GoRoute(path: '/onboarding', builder: (ctx, state) => const OnboardingScreen()),
      GoRoute(path: '/login', builder: (ctx, state) => const LoginScreen()),
      GoRoute(path: '/register', builder: (ctx, state) => const RegisterScreen()),
      GoRoute(path: '/home', builder: (ctx, state) => const HomeScreen()),
      GoRoute(
        path: '/facility/:id',
        builder: (ctx, state) => FacilityDetailScreen(
          facilityId: state.pathParameters['id'] ?? '',
        ),
      ),
      GoRoute(
        path: '/departments/:facilityId',
        builder: (ctx, state) => DepartmentsScreen(
          facilityId: state.pathParameters['facilityId'] ?? '',
        ),
      ),
      GoRoute(path: '/queue', builder: (ctx, state) => const QueueScreen()),
      GoRoute(path: '/notifications', builder: (ctx, state) => const NotificationsScreen()),
      GoRoute(path: '/profile', builder: (ctx, state) => const ProfileScreen()),
      GoRoute(path: '/games', builder: (ctx, state) => const GamesHubScreen()),
      GoRoute(path: '/admin', builder: (ctx, state) => const AdminDashboardScreen()),
    ],
  );
});
