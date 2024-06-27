
import 'package:flutter/material.dart';
import '../services/authservice.dart';

class SignInModel extends ChangeNotifier {
  String _username = '';
  String _password = '';
  String? _errorMessage;
  bool _isLoading = false;

  final AuthService _authService = AuthService();

  String get username => _username;
  String get password => _password;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;

  void setUsername(String username) {
    _username = username;
    notifyListeners();
  }

  void setPassword(String password) {
    _password = password;
    notifyListeners();
  }

  Future<void> signIn() async {
    _isLoading = true;
    notifyListeners();

    _errorMessage = await _authService.signIn(_username, _password);

    if (_errorMessage == null) {
    } else {
      // Sign-in failed
    }

    _isLoading = false;
    notifyListeners();
  }
}
