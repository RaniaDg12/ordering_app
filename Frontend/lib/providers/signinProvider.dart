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

  Future<void> signIn(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    try {
      _errorMessage = await _authService.signIn(context, _username, _password);

      if (_errorMessage == null) {
      } else {}
    } catch (e) {
      _errorMessage = 'Failed to sign in. Please try again.';
    }

    _isLoading = false;
    notifyListeners();
  }
}
