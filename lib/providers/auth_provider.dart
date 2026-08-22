import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthNotifier extends Notifier<bool> {
  @override
  bool build() {
    _checkLoginStatus();
    return false;
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    state = isLoggedIn;
  }

  Future<void> login() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    state = true;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    state = false;
  }
}

final authProvider = NotifierProvider<AuthNotifier, bool>(() {
  return AuthNotifier();
});
