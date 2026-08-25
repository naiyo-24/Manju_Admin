import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_client.dart';

class AuthNotifier extends Notifier<bool> {
  @override
  bool build() {
    _checkLoginStatus();
    return false;
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    
    if (token != null && token.isNotEmpty) {
      ApiClient().setToken(token);
      state = true;
    } else {
      state = false;
    }
  }

  Future<void> login(String email, String password) async {
    try {
      final response = await ApiClient().dio.post('/api/auth/admin-login', data: {
        'email': email,
        'password': password,
      });

      final token = response.data['access_token'];
      if (token == null) throw Exception("No access token found");

      // Save token securely
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('access_token', token);
      
      // Inject token into network clients
      ApiClient().setToken(token);
      
      state = true;
    } catch (e) {
      throw Exception(ApiClient().handleError(e));
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    
    // Clear network token
    ApiClient().clearToken();
    
    state = false;
  }
}
