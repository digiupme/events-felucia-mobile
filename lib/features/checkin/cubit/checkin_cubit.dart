import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/checkin_repository.dart';
import 'checkin_state.dart';

class CheckinCubit extends Cubit<CheckinState> {
  final CheckinRepository _repository;

  CheckinCubit(this._repository) : super(CheckinInitial());

  Future<void> checkInByQr(String qrCode, String sessionId) async {
    if (qrCode.trim().isEmpty) {
      emit(const CheckinFailure('Código inválido.'));
      return;
    }

    emit(CheckinLoading());
    try {
      final result = await _repository.checkInByQr(qrCode.trim(), sessionId);
      emit(CheckinSuccess(attendeeName: result.attendeeName));
    } on AlreadyCheckedInException catch (e) {
      emit(CheckinAlreadyCheckedIn(attendeeName: e.attendeeName));
    } catch (e) {
      emit(CheckinFailure(e.toString()));
    }
  }

  Future<void> checkInById(String attendeeId, String sessionId) async {
    if (attendeeId.trim().isEmpty) {
      emit(const CheckinFailure('Participante inválido.'));
      return;
    }

    emit(CheckinLoading());
    try {
      final result = await _repository.checkInById(attendeeId.trim(), sessionId);
      emit(CheckinSuccess(attendeeName: result.attendeeName));
    } on AlreadyCheckedInException catch (e) {
      emit(CheckinAlreadyCheckedIn(attendeeName: e.attendeeName));
    } catch (e) {
      emit(CheckinFailure(e.toString()));
    }
  }

  void reset() => emit(CheckinInitial());
}
