import 'package:email_validator/email_validator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utils/strings.dart';

import '../data/auth_repository.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository _repository;

  LoginCubit([AuthRepository? repository])
      : _repository = repository ?? AuthRepository(),
        super(LoginInitial());

  Future<void> login(String email, String password) async {
    if (!EmailValidator.validate(email)) {
      emit(LoginFailure(Strings.login.invalidEmail));
      return;
    }
    if (password.isEmpty) {
      emit(LoginFailure(Strings.login.invalidPassword));
      return;
    }

    emit(LoginLoading());
    try {
      await _repository.login(email, password);
      emit(LoginSuccess());
    } catch (e) {
      emit(LoginFailure(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    emit(LoginInitial());
  }
}
