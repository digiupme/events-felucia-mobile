import 'dart:convert';
import 'dart:io';

import '../../../utils/strings.dart';

import 'package:http/http.dart' as http;
import 'package:http/http.dart' show ClientException;

import '../../../core/config/app_config.dart';
import '../../../core/network/api_client.dart';

class AuthRepository {
  Future<void> login(String email, String password) async {
    try {
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
        String? serverMessage;
        try {
          final body = jsonDecode(response.body) as Map<String, dynamic>;
          serverMessage = body['message'] as String?;
        } catch (_) {}
        throw Exception(serverMessage ?? Strings.login.authError);
      }
    } on SocketException {
      throw Exception(Strings.noInternet);
    } on ClientException {
      throw Exception(Strings.noInternet);
    }
  }

  Future<void> logout() async {
    try {
      await http.post(
        Uri.parse('${AppConfig.baseUrl}/auth/logout'),
        headers: ApiClient.instance.headers,
      );
    } catch (_) {}
    ApiClient.instance.clearToken();
  }
}
