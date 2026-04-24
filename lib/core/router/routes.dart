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
    GoRoute(path: sessionsRoute, builder: (context, state) => SessionsScreen()),
  ],
);

GoRouter createRouter() => _router;
