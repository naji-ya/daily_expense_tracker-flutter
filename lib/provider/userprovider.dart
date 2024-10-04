import 'package:daily_expense_tracker/screens/auth/loginRegisterScreen.dart';
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

    // Get the stored email and password
    String? storedEmail = prefs.getString('email');
    String? storedPassword = prefs.getString('password');

    // Check if email and password match
    if (storedEmail == email && storedPassword == password) {
      _username = prefs.getString('username') ?? '';
      _email = email;
      _isLoggedIn = true;
      await prefs.setBool('isLoggedIn', true);
      notifyListeners();
    } else {
      throw Exception('Invalid email or password'); // This exception will be caught in the UI
    }
  }

  Future<void> logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    _isLoggedIn = false;
    _username = '';
    _email = '';
    notifyListeners();

    // Navigate to the Login Screen
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginRegisterScreen()), // Replace with your actual LoginScreen widget
          (route) => false, // Remove all previous routes
    );
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
