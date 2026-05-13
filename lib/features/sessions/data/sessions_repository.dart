import 'dart:convert';
import 'dart:io';

import '../../../utils/strings.dart';

import 'package:http/http.dart' as http;
import 'package:http/http.dart' show ClientException;

import '../../../core/config/app_config.dart';
import '../../../core/network/api_client.dart';
import 'session.dart';

class SessionsRepository {
  Future<List<Session>> fetchSessions() async {
    try {
      final response = await http.get(
        Uri.parse(
          '${AppConfig.baseUrl}/checkin/events/${AppConfig.eventId}/sessions',
        ),
        headers: ApiClient.instance.headers,
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        final list = body['sessions'] as List<dynamic>;
        return list
            .map((e) => Session.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception(Strings.sessions.fetchError);
      }
    } on SocketException {
      throw Exception(Strings.noInternet);
    } on ClientException {
      throw Exception(Strings.noInternet);
    }
  }
}
