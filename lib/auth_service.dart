import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService with ChangeNotifier {
  static const String _loggedInKey = 'loggedIn';
  final SharedPreferences _prefs;

  AuthService(this._prefs);

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    // In a real app, you would validate the email and password against stored credentials.
    // For this example, we'll just simulate a successful login.
    await _prefs.setBool(_loggedInKey, true);
    notifyListeners();
  }

  Future<void> createUserWithEmailAndPassword(String email, String password) async {
    // In a real app, you would store the new user's credentials.
    // For this example, we'll just simulate a successful sign-up and log the user in.
    await _prefs.setBool(_loggedInKey, true);
    notifyListeners();
  }

  Future<void> signOut() async {
    await _prefs.setBool(_loggedInKey, false);
    notifyListeners();
  }

  bool isLoggedIn() {
    return _prefs.getBool(_loggedInKey) ?? false;
  }
}
