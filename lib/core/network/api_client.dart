import 'package:flutter/foundation.dart';

class ApiClient {
  ApiClient._();
  static final ApiClient instance = ApiClient._();

  String? _token;
  final authNotifier = ValueNotifier<bool>(false);

  bool get isAuthenticated => _token != null;

  void setToken(String token) {
    _token = token;
    authNotifier.value = true;
  }

  void clearToken() {
    _token = null;
    authNotifier.value = false;
  }

  Map<String, String> get headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (_token != null) 'Authorization': 'Bearer $_token',
      };
}
