import 'package:event_checkin/features/checkin/cubit/checkin_cubit.dart';
import 'package:event_checkin/features/checkin/data/checkin_repository.dart';
import 'package:event_checkin/features/checkin/presentation/pages/checkin_already_checked_in.dart';
import 'package:event_checkin/features/checkin/presentation/pages/checkin_failure.dart';
import 'package:event_checkin/features/checkin/presentation/pages/checkin_scanner.dart';
import 'package:event_checkin/features/checkin/presentation/pages/checkin_success.dart';
import 'package:event_checkin/features/sessions/presentation/sessions_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/login/cubit/login_cubit.dart';
import '../../features/login/data/auth_repository.dart';
import '../../features/login/presentation/login_screen.dart';
import 'paths.dart';

final GoRouter _router = GoRouter(
  initialLocation: loginRoute,
  routes: [
    GoRoute(
      path: loginRoute,
      builder: (context, state) => BlocProvider(
        create: (_) => LoginCubit(AuthRepositoryImpl()),
        child: const LoginScreen(),
      ),
    ),
    GoRoute(
      path: sessionsRoute,
      builder: (context, state) => const SessionsScreen(),
    ),
    GoRoute(
      path: checkinScannerRoute,
      builder: (context, state) {
        final params = state.extra! as Map;
        return BlocProvider(
          create: (_) => CheckinCubit(CheckinRepository()),
          child: CheckinScanner(params: params),
        );
      },
    ),
    GoRoute(
      path: checkinSuccessRoute,
      builder: (context, state) {
        final params = state.extra! as Map;
        return CheckinSuccessScreen(attendeeName: params['attendeeName'] as String);
      },
    ),
    GoRoute(
      path: checkinAlreadyCheckedInRoute,
      builder: (context, state) {
        final params = state.extra! as Map;
        return CheckinAlreadyCheckedInScreen(attendeeName: params['attendeeName'] as String);
      },
    ),
    GoRoute(
      path: checkinFailureRoute,
      builder: (context, state) {
        final params = state.extra! as Map;
        return CheckinFailureScreen(message: params['message'] as String);
      },
    ),
  ],
);

GoRouter createRouter() => _router;
