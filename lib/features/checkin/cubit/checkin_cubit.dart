import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/checkin_repository.dart';
import '../data/session_detail.dart';
import 'checkin_state.dart';

class CheckinCubit extends Cubit<CheckinState> {
  final CheckinRepository _repository;
  SessionDetail? _session;
  SessionDetail? get session => _session;
  String? _sessionId;

  CheckinCubit(this._repository) : super(CheckinSessionLoading());

  Future<void> loadSession(String sessionId) async {
    _sessionId = sessionId;
    emit(CheckinSessionLoading());
    try {
      _session = await _repository.fetchSession(sessionId);
      emit(CheckinReady(_session!));
    } catch (e) {
      emit(CheckinSessionFailure(e.toString()));
    }
  }

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

  void reset() {
    if (_sessionId != null) loadSession(_sessionId!);
  }
}
