import 'package:equatable/equatable.dart';

import '../data/session_detail.dart';

abstract class CheckinState extends Equatable {
  const CheckinState();

  @override
  List<Object?> get props => [];
}

class CheckinSessionLoading extends CheckinState {}

class CheckinSessionFailure extends CheckinState {
  final String message;

  const CheckinSessionFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class CheckinReady extends CheckinState {
  final SessionDetail session;

  const CheckinReady(this.session);

  @override
  List<Object?> get props => [session];
}

class CheckinLoading extends CheckinState {}

class CheckinSuccess extends CheckinState {
  final String attendeeName;

  const CheckinSuccess({required this.attendeeName});

  @override
  List<Object?> get props => [attendeeName];
}

class CheckinAlreadyCheckedIn extends CheckinState {
  final String attendeeName;

  const CheckinAlreadyCheckedIn({required this.attendeeName});

  @override
  List<Object?> get props => [attendeeName];
}

class CheckinFailure extends CheckinState {
  final String message;

  const CheckinFailure(this.message);

  @override
  List<Object?> get props => [message];
}
