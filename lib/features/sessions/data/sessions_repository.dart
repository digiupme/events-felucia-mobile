import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../core/config/app_config.dart';
import '../../../core/network/api_client.dart';
import 'session.dart';

class SessionsRepository {
  Future<List<Session>> fetchSessions() async {
    print("headers:");
    print(ApiClient.instance.headers);
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
      print(
        'Erro ao carregar sessões: ${response.statusCode} - ${response.body}',
      );
      throw Exception('Erro ao carregar sessões.');
    }
  }
}
