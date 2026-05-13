class Strings {
  const Strings._();

  static const retry = 'Tentar novamente';
  static const next = 'Próximo';
  static const noInternet = 'Sem ligação à internet.';
  static const genericError = 'Ocorreu um problema. Por favor, tente novamente.';

  static const login = _LoginStrings();
  static const sessions = _SessionsStrings();
  static const scanner = _ScannerStrings();
  static const checkinPages = _CheckinPageStrings();
  static const manual = _ManualStrings();
  static const dialogs = _DialogStrings();
}

class _LoginStrings {
  const _LoginStrings();
  final email = 'Email';
  final password = 'Palavra-passe';
  final submit = 'Iniciar sessão';
  final invalidEmail = 'Verifique o endereço de email.';
  final invalidPassword = 'Verifique a palavra-passe.';
  final authError = 'Erro ao autenticar.';
}

class _SessionsStrings {
  const _SessionsStrings();
  final title = 'Sessões Disponíveis';
  final subtitle = 'Selecione a sessão desejada';
  final loadError =
      'Não foi possível carregar as sessões. Verifique a sua ligação e tente novamente.';
  final fetchError = 'Erro ao carregar sessões.';
}

class _ScannerStrings {
  const _ScannerStrings();
  final hint = 'Posicione o código no centro';
  final processing = 'A processar...';
  final manualButton = 'check-in manual';
  final loadError =
      'Não foi possível carregar a sessão. Verifique a sua ligação e tente novamente.';
  final fetchError = 'Erro ao carregar sessão.';
  final invalidCode = 'Código inválido.';
  final denied = 'Check-in negado.';
}

class _CheckinPageStrings {
  const _CheckinPageStrings();
  final successTitle = 'CHECK-IN REALIZADO';
  final successDescription = 'Código de acesso processado com sucesso!';
  final alreadyTitle = 'CHECK-IN JÁ REALIZADO';
  final alreadyDescription =
      'Este código de acesso já foi processado anteriormente em nossa base de dados.';
  final wrongSessionTitle = 'SESSÃO INCORRETA';
  final wrongSessionDescription =
      'O código de acesso lido pertence a uma sessão diferente.\nPor favor, verifique os detalhes e tente novamente.';
  final failureTitle = 'ANOMALIA REGISTADA';

  String checkedInAt(String date) => 'Check-in feito em: $date';
}

class _ManualStrings {
  const _ManualStrings();
  final title = 'Check-in Manual';
  final searchHint = 'Pesquisar';
  final noAttendees = 'Nenhum participante encontrado.';
  final checkinButton = 'check-in';
  final loadError =
      'Não foi possível carregar os participantes. Verifique a sua ligação e tente novamente.';
  final submitError = 'Erro ao realizar check-in.';
}

class _DialogStrings {
  const _DialogStrings();
  final successTitle = 'Check In Realizado';
  final alreadyTitle = 'Já Registado';
  final failureTitle = 'Falha no Check In';
  final failureFallback = 'Houve uma falha. Tente novamente mais tarde.';
  final scannerButton = 'Scanner';
  final listButton = 'Lista';

  String successDescription(String date) =>
      'Check in manual realizado com sucesso em $date.';
  String alreadyDescription(String date) => 'Check-in realizado em $date.';
}
