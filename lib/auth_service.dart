import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User {
  final String email;
  User(this.email);
}

class AuthService with ChangeNotifier {
  static const String _loggedInKey = 'loggedIn';
  static const String _emailKey = 'email';
  final SharedPreferences _prefs;
  User? _currentUser;

  AuthService(this._prefs) {
    _loadUser();
  }

  User? get currentUser => _currentUser;

  void _loadUser() {
    final isLoggedIn = _prefs.getBool(_loggedInKey) ?? false;
    if (isLoggedIn) {
      final email = _prefs.getString(_emailKey);
      if (email != null) {
        _currentUser = User(email);
      }
    }
    notifyListeners();
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    await _prefs.setBool(_loggedInKey, true);
    await _prefs.setString(_emailKey, email);
    _currentUser = User(email);
    notifyListeners();
  }

  Future<void> createUserWithEmailAndPassword(String email, String password) async {
    await _prefs.setBool(_loggedInKey, true);
    await _prefs.setString(_emailKey, email);
    _currentUser = User(email);
    notifyListeners();
  }

  Future<void> signOut() async {
    await _prefs.setBool(_loggedInKey, false);
    await _prefs.remove(_emailKey);
    _currentUser = null;
    notifyListeners();
  }

  bool isLoggedIn() {
    return _prefs.getBool(_loggedInKey) ?? false;
  }
}