import 'dart:convert';
import 'dart:io';

import '../../../utils/strings.dart';

import 'package:http/http.dart' as http;
import 'package:http/http.dart' show ClientException;

import '../../../core/config/app_config.dart';
import '../../../core/network/api_client.dart';
import 'attendee.dart';
import 'manual_checkin_result.dart';
import 'session_detail.dart';

class WrongSessionException implements Exception {}

class AlreadyCheckedInException implements Exception {
  final String attendeeName;
  final DateTime checkedInAt;
  const AlreadyCheckedInException(this.attendeeName, this.checkedInAt);
}

class CheckinResult {
  final String attendeeName;
  final DateTime checkedInAt;
  const CheckinResult({required this.attendeeName, required this.checkedInAt});
}

class CheckinRepository {
  Future<SessionDetail> fetchSession(String sessionId) async {
    try {
      final response = await http.get(
        Uri.parse(
          '${AppConfig.baseUrl}/checkin/events/${AppConfig.eventId}/sessions/$sessionId',
        ),
        headers: ApiClient.instance.headers,
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        return SessionDetail.fromJson(body);
      } else {
        throw Exception(Strings.scanner.fetchError);
      }
    } on SocketException {
      throw Exception(Strings.noInternet);
    } on ClientException {
      throw Exception(Strings.noInternet);
    }
  }

  Future<List<Attendee>> fetchAttendees(String sessionId) async {
    try {
      final response = await http.get(
        Uri.parse(
          '${AppConfig.baseUrl}/checkin/events/${AppConfig.eventId}/sessions/$sessionId/attendees',
        ),
        headers: ApiClient.instance.headers,
      );

      if (response.statusCode == 200) {
        final list = jsonDecode(response.body) as List<dynamic>;
        return list
            .map((e) => Attendee.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception(Strings.manual.loadError);
      }
    } on SocketException {
      throw Exception(Strings.noInternet);
    } on ClientException {
      throw Exception(Strings.noInternet);
    }
  }

  Future<CheckinResult> checkInByQr(String qrCode, String sessionId) async {
    try {
      final response = await http.post(
        Uri.parse('${AppConfig.baseUrl}/checkin/scan'),
        headers: ApiClient.instance.headers,
        body: jsonEncode({
          'qr_code': qrCode,
          'event_id': AppConfig.eventId,
          'session_id': sessionId,
        }),
      );

      final json = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        final checkedInAt = DateTime.parse(json['checked_in_at'] as String).toLocal();
        if (json['result'] == 'granted') {
          return CheckinResult(attendeeName: json['attendee_name'], checkedInAt: checkedInAt);
        } else if (json['deny_reason'] == 'already_checked') {
          throw AlreadyCheckedInException(json['attendee_name'], checkedInAt);
        } else if (json['deny_reason'] == 'wrong_session') {
          throw WrongSessionException();
        } else {
          throw Exception(Strings.scanner.denied);
        }
      } else {
        throw Exception(json['message'] ?? 'Erro ao realizar check-in.');
      }
    } on SocketException {
      throw Exception(Strings.noInternet);
    } on ClientException {
      throw Exception(Strings.noInternet);
    }
  }

  Future<ManualCheckinResult> checkInById(
    String attendeeId,
    String sessionId,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(
          '${AppConfig.baseUrl}/checkin/events/${AppConfig.eventId}/sessions/$sessionId/attendees/$attendeeId/checkin',
        ),
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
      throw Exception(Strings.noInternet);
    } on ClientException {
      throw Exception(Strings.noInternet);
    }
  }
}
