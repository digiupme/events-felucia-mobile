import 'package:equatable/equatable.dart';

abstract class CheckinState extends Equatable {
  const CheckinState();

  @override
  List<Object?> get props => [];
}

class CheckinInitial extends CheckinState {}

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
