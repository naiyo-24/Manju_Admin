import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../screens/auth/login_screen.dart';
import '../screens/dashboard/dashboard_shell.dart';
import '../screens/dashboard/dashboard_screen.dart';
import '../screens/doctors/doctor_bookings_screen.dart';
import '../screens/medicines/medicine_delivery_screen.dart';
import '../screens/lab_tests/lab_tests_screen.dart';
import '../screens/appointments/appointments_screen.dart';
import '../screens/lab_bookings/lab_bookings_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/dashboard',
    redirect: (context, state) {
      final isLoggingIn = state.matchedLocation == '/login';
      
      if (!authState && !isLoggingIn) return '/login';
      if (authState && isLoggingIn) return '/dashboard';
      
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return DashboardShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/dashboard',
                builder: (context, state) => const DashboardScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/doctors',
                builder: (context, state) => const DoctorBookingsScreen(),
              ),
            ],
          ),
          // StatefulShellBranch(
          //   routes: [
          //     GoRoute(
          //       path: '/medicines',
          //       builder: (context, state) => const MedicineDeliveryScreen(),
          //     ),
          //   ],
          // ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/appointments',
                builder: (context, state) => const AppointmentsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/lab-bookings',
                builder: (context, state) => const LabBookingsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/lab_tests',
                builder: (context, state) => const LabTestsScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
