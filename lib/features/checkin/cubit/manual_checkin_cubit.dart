import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/attendee.dart';
import '../data/checkin_repository.dart';
import 'manual_checkin_state.dart';

class ManualCheckinCubit extends Cubit<ManualCheckinState> {
  final CheckinRepository _repository;
  final String sessionId;

  ManualCheckinCubit(this._repository, {required this.sessionId})
    : super(ManualCheckinLoading());

  Future<void> loadAttendees() async {
    emit(ManualCheckinLoading());
    try {
      final attendees = await _repository.fetchAttendees(sessionId);
      emit(ManualCheckinLoaded(attendees: attendees));
    } catch (e) {
      emit(ManualCheckinFailure(e.toString()));
    }
  }

  void search(String query) {
    final current = state;
    if (current is ManualCheckinLoaded) {
      emit(current.copyWith(query: query));
    }
  }

  Future<void> checkIn(Attendee attendee) async {
    final current = state;
    if (current is! ManualCheckinLoaded) return;

    emit(
      ManualCheckinSubmitting(
        attendees: current.attendees,
        query: current.query,
        attendeeId: attendee.id,
      ),
    );

    // // TODO: remove before release
    // emit(
    //   // ManualCheckinFailure(
    //   //   attendeeName: attendee.name,
    //   //   checkedInAt: DateTime.now(),
    //   // ),
    //   ManualCheckinSubmitFailure('Check-in manual desabilitado para testes.'),
    // );
    // return;

    try {
      final result = await _repository.checkInById(attendee.id, sessionId);
      if (result.isGranted) {
        emit(
          ManualCheckinSuccess(
            attendeeName: result.attendeeName,
            checkedInAt: result.checkedInAt,
          ),
        );
      } else if (result.isAlreadyCheckedIn) {
        emit(
          ManualCheckinAlreadyCheckedIn(
            attendeeName: result.attendeeName,
            checkedInAt: result.checkedInAt,
          ),
        );
      } else {
        emit(ManualCheckinSubmitFailure('Erro ao realizar check-in.'));
      }
    } catch (e) {
      emit(ManualCheckinSubmitFailure(e.toString()));
    }
  }
}
