import 'package:event_checkin/features/checkin/cubit/checkin_cubit.dart';
import 'package:event_checkin/features/checkin/data/checkin_repository.dart';
import 'package:event_checkin/features/checkin/presentation/pages/checkin_scanner.dart';
import 'package:event_checkin/features/checkin/cubit/manual_checkin_cubit.dart';
import 'package:event_checkin/features/checkin/presentation/pages/manual_checkin_screen.dart';
import 'package:event_checkin/features/sessions/cubit/sessions_cubit.dart';
import 'package:event_checkin/features/sessions/data/sessions_repository.dart';
import 'package:event_checkin/features/sessions/presentation/sessions_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../network/api_client.dart';
import '../../features/login/presentation/login_screen.dart';
import 'paths.dart';

final GoRouter _router = GoRouter(
  initialLocation: loginRoute,
  refreshListenable: ApiClient.instance.authNotifier,
  redirect: (context, state) {
    final isLoggedIn = ApiClient.instance.isAuthenticated;
    final isOnLoginPage = state.matchedLocation == loginRoute;
    if (!isLoggedIn && !isOnLoginPage) return loginRoute;
    if (isLoggedIn && isOnLoginPage) return sessionsRoute;
    return null;
  },
  routes: [
    GoRoute(path: loginRoute, builder: (context, state) => const LoginScreen()),
    GoRoute(
      path: sessionsRoute,
      builder: (context, state) => BlocProvider(
        create: (_) => SessionsCubit(SessionsRepository())..fetchSessions(),
        child: const SessionsScreen(),
      ),
    ),
    GoRoute(
      path: checkinScannerRoute,
      builder: (context, state) {
        final params = state.extra! as Map;
        return BlocProvider(
          create: (_) =>
              CheckinCubit(CheckinRepository())
                ..loadSession(params['sessionId'] as String),
          child: CheckinScanner(sessionId: params['sessionId'] as String),
        );
      },
    ),
    GoRoute(
      path: manualCheckinRoute,
      builder: (context, state) {
        final params = state.extra! as Map<String, String>;
        return BlocProvider(
          create: (_) => ManualCheckinCubit(
            CheckinRepository(),
            sessionId: params['sessionId']!,
          )..loadAttendees(),
          child: ManualCheckinScreen(sessionName: params['sessionName']!),
        );
      },
    ),
  ],
);

GoRouter createRouter() => _router;
