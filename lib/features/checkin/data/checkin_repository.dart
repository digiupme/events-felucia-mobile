class AlreadyCheckedInException implements Exception {
  final String attendeeName;
  const AlreadyCheckedInException(this.attendeeName);
}

class CheckinResult {
  final String attendeeName;

  const CheckinResult({required this.attendeeName});
}

class CheckinRepository {
  Future<CheckinResult> checkInByQr(String qrCode, String sessionId) async {
    // TODO: POST /checkin/qr with qrCode and sessionId
    await Future.delayed(const Duration(seconds: 1));
    if (qrCode.contains('duplicado')) {
      throw const AlreadyCheckedInException('Test User');
    }
    if (qrCode.contains('erro')) {
      throw Exception('Participante não encontrado.');
    }
    return const CheckinResult(attendeeName: 'Test User');
  }

  Future<CheckinResult> checkInById(String attendeeId, String sessionId) async {
    // TODO: POST /checkin/manual with attendeeId and sessionId
    await Future.delayed(const Duration(seconds: 1));
    return const CheckinResult(attendeeName: 'Test User');
  }
}
