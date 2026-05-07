import 'package:event_checkin/core/router/paths.dart';
import 'package:event_checkin/features/login/cubit/login_cubit.dart';
import 'package:event_checkin/features/login/cubit/login_state.dart';
import 'package:event_checkin/features/sessions/cubit/sessions_cubit.dart';
import 'package:event_checkin/features/sessions/cubit/sessions_state.dart';
import 'package:event_checkin/features/sessions/data/session.dart';
import 'package:event_checkin/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SessionsScreen extends StatelessWidget {
  const SessionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginInitial) {
          context.go(loginRoute);
        }
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                onPressed: () => context.read<LoginCubit>().logout(),
                icon: const Icon(Icons.logout_outlined, color: Colors.black),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Sessões Disponíveis',
                        style: TextStyle(
                          color: redColor,
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Selecione a sessão desejada',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  BlocBuilder<SessionsCubit, SessionsState>(
                    builder: (context, state) {
                      if (state is SessionsLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (state is SessionsFailure) {
                        return Center(child: Text(state.message));
                      }
                      if (state is SessionsLoaded) {
                        return Column(
                          children: state.sessions
                              .map((session) => _SessionCard(session: session))
                              .toList(),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SessionCard extends StatelessWidget {
  final Session session;

  const _SessionCard({required this.session});

  String _formatTime(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xffEAEEF5),
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: ListTile(
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          child: Text(
            session.name,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
          child: Row(
            children: [
              const Icon(Icons.access_time, size: 16),
              const SizedBox(width: 4),
              Text('${_formatTime(session.startAt)} - ${_formatTime(session.endAt)}'),
            ],
          ),
        ),
        onTap: () {
          context.push(
            checkinScannerRoute,
            extra: {
              'title': session.name,
              'sessionId': session.id,
            },
          );
        },
      ),
    );
  }
}
