import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider with ChangeNotifier {
  String _username = '';
  String _email = '';
  bool _isLoggedIn = false;

  String get username => _username;
  String get email => _email;
  bool get isLoggedIn => _isLoggedIn;

  Future<void> initializeUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _username = prefs.getString('username') ?? '';
    _email = prefs.getString('email') ?? '';
    _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    notifyListeners();
  }

  Future<void> register(String username, String email, String password) async {
    // Simulate a registration process (you would typically send this to a backend)
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
    await prefs.setString('email', email);
    await prefs.setString('password', password); // Note: Storing passwords like this is not secure
    await prefs.setBool('isLoggedIn', true);

    _username = username;
    _email = email;
    _isLoggedIn = true;
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Simulate a login process (you would typically verify with a backend)
    if (prefs.getString('email') == email && prefs.getString('password') == password) {
      _username = prefs.getString('username') ?? '';
      _email = email;
      _isLoggedIn = true;
      await prefs.setBool('isLoggedIn', true);
      notifyListeners();
    } else {
      throw Exception('Invalid email or password');
    }
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    _isLoggedIn = false;
    _username = '';
    _email = '';
    notifyListeners();
  }

  Future<void> clearUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');
    await prefs.remove('email');
    await prefs.remove('password');
    await prefs.setBool('isLoggedIn', false);
    _isLoggedIn = false;
    _username = '';
    _email = '';
    notifyListeners();
  }
}
