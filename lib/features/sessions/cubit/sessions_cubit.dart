import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/sessions_repository.dart';
import 'sessions_state.dart';

class SessionsCubit extends Cubit<SessionsState> {
  final SessionsRepository _repository;

  SessionsCubit(this._repository) : super(SessionsInitial());

  Future<void> fetchSessions() async {
    emit(SessionsLoading());
    try {
      final sessions = await _repository.fetchSessions();
      emit(SessionsLoaded(sessions));
    } catch (e) {
      emit(SessionsFailure(e.toString()));
    }
  }
}
