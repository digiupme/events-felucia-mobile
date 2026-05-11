import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../../core/config/app_config.dart';
import '../../../core/network/api_client.dart';
import 'attendee.dart';
import 'manual_checkin_result.dart';
import 'session_detail.dart';

class AlreadyCheckedInException implements Exception {
  final String attendeeName;
  const AlreadyCheckedInException(this.attendeeName);
}

class CheckinResult {
  final String attendeeName;
  const CheckinResult({required this.attendeeName});
}

class CheckinRepository {
  Future<SessionDetail> fetchSession(String sessionId) async {
    try {
      final response = await http.get(
        Uri.parse('${AppConfig.baseUrl}/checkin/events/${AppConfig.eventId}/sessions/$sessionId'),
        headers: ApiClient.instance.headers,
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        return SessionDetail.fromJson(body);
      } else {
        throw Exception('Erro ao carregar sessão.');
      }
    } on SocketException {
      throw Exception('Sem ligação à internet.');
    }
  }

  Future<List<Attendee>> fetchAttendees(String sessionId) async {
    try {
      final response = await http.get(
        Uri.parse('${AppConfig.baseUrl}/checkin/events/${AppConfig.eventId}/sessions/$sessionId/attendees'),
        headers: ApiClient.instance.headers,
      );

      if (response.statusCode == 200) {
        final list = jsonDecode(response.body) as List<dynamic>;
        return list.map((e) => Attendee.fromJson(e as Map<String, dynamic>)).toList();
      } else {
        throw Exception('Erro ao carregar participantes.');
      }
    } on SocketException {
      throw Exception('Sem ligação à internet.');
    }
  }

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

  Future<ManualCheckinResult> checkInById(String attendeeId, String sessionId) async {
    try {
      final response = await http.post(
        Uri.parse('${AppConfig.baseUrl}/checkin/events/${AppConfig.eventId}/sessions/$sessionId/attendees/$attendeeId/checkin'),
        headers: ApiClient.instance.headers,
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        return ManualCheckinResult.fromJson(body);
      } else {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        throw Exception(body['message'] ?? 'Erro ao realizar check-in.');
      }
    } on SocketException {
      throw Exception('Sem ligação à internet.');
    }
  }
}
