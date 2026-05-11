import 'package:equatable/equatable.dart';

import '../data/attendee.dart';

abstract class ManualCheckinState extends Equatable {
  const ManualCheckinState();

  @override
  List<Object?> get props => [];
}

class ManualCheckinLoading extends ManualCheckinState {}

class ManualCheckinLoaded extends ManualCheckinState {
  final List<Attendee> attendees;
  final String query;

  const ManualCheckinLoaded({required this.attendees, this.query = ''});

  List<Attendee> get filtered => query.isEmpty
      ? attendees
      : attendees
          .where((a) => a.name.toLowerCase().contains(query.toLowerCase()))
          .toList();

  ManualCheckinLoaded copyWith({List<Attendee>? attendees, String? query}) =>
      ManualCheckinLoaded(
        attendees: attendees ?? this.attendees,
        query: query ?? this.query,
      );

  @override
  List<Object?> get props => [attendees, query];
}

class ManualCheckinFailure extends ManualCheckinState {
  final String message;

  const ManualCheckinFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class ManualCheckinSubmitting extends ManualCheckinState {
  final List<Attendee> attendees;
  final String query;
  final String attendeeId;

  const ManualCheckinSubmitting({
    required this.attendees,
    required this.attendeeId,
    this.query = '',
  });

  @override
  List<Object?> get props => [attendees, query, attendeeId];
}

class ManualCheckinSuccess extends ManualCheckinState {
  final String attendeeName;
  final DateTime checkedInAt;

  const ManualCheckinSuccess({required this.attendeeName, required this.checkedInAt});

  @override
  List<Object?> get props => [attendeeName, checkedInAt];
}

class ManualCheckinAlreadyCheckedIn extends ManualCheckinState {
  final String attendeeName;
  final DateTime checkedInAt;

  const ManualCheckinAlreadyCheckedIn({required this.attendeeName, required this.checkedInAt});

  @override
  List<Object?> get props => [attendeeName, checkedInAt];
}

class ManualCheckinSubmitFailure extends ManualCheckinState {
  final String message;

  const ManualCheckinSubmitFailure(this.message);

  @override
  List<Object?> get props => [message];
}
