import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../core/config/app_config.dart';
import '../../../core/network/api_client.dart';

class AuthRepository {
  Future<void> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('${AppConfig.baseUrl}/auth/login'),
      headers: ApiClient.instance.headers,
      body: jsonEncode({
        'email': email,
        'password': password,
        'event_id': AppConfig.eventId,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      ApiClient.instance.setToken(data['token'] as String);
    } else {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      throw Exception(body['message'] ?? 'Erro ao autenticar.');
    }
  }

  Future<void> logout() async {
    await http.post(
      Uri.parse('${AppConfig.baseUrl}/auth/logout'),
      headers: ApiClient.instance.headers,
    );
    ApiClient.instance.clearToken();
  }
}
