import 'package:equatable/equatable.dart';

import '../data/session.dart';

abstract class SessionsState extends Equatable {
  const SessionsState();

  @override
  List<Object?> get props => [];
}

class SessionsInitial extends SessionsState {}

class SessionsLoading extends SessionsState {}

class SessionsLoaded extends SessionsState {
  final List<Session> sessions;

  const SessionsLoaded(this.sessions);

  @override
  List<Object?> get props => [sessions];
}

class SessionsFailure extends SessionsState {
  final String message;

  const SessionsFailure(this.message);

  @override
  List<Object?> get props => [message];
}
