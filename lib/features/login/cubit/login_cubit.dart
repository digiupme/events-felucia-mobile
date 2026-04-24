import 'package:email_validator/email_validator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/auth_repository.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository _repository;

  LoginCubit(this._repository) : super(LoginInitial());

  Future<void> login(String email, String password) async {
    if (!EmailValidator.validate(email)) {
      emit(const LoginFailure('Verifique o endereço de email.'));
      return;
    }
    if (password.isEmpty) {
      emit(const LoginFailure('Verifique a palavra-passe.'));
      return;
    }

    emit(LoginLoading());
    try {
      await _repository.login(email, password);
      emit(LoginSuccess());
    } catch (e) {
      emit(LoginFailure(e.toString()));
    }
  }
}
