import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class AuthService {
  final String baseUrl = 'http://192.168.56.1:3000';
  final storage = FlutterSecureStorage();

  Future<String?> signIn(BuildContext context, String username, String password) async {
    // Check internet connectivity
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      // If no internet connection, attempt to use cached token
      String? token = await storage.read(key: 'token');
      if (token != null) {
        // Assuming the token is valid for offline use
        Navigator.pushReplacementNamed(context, '/orderlist');
      } else {
        // If no token available, throw an exception or show an error
        throw Exception('No internet connection and no cached token available.');
      }
    } else {
      // If internet connection is available, proceed with online sign-in
      final url = Uri.parse('$baseUrl/auth/signin?name=$username&password=$password');
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final token = responseData['token'];

        await storage.write(key: 'token', value: token);

        Navigator.pushReplacementNamed(context, '/orderlist');
      } else {
        final responseData = jsonDecode(response.body);
        throw Exception(responseData['message']);
      }
    }
  }

  Future<void> signOut() async {
    await storage.delete(key: 'token');
  }

  Future<String?> getCurrentUserToken() async {
    String? token = await storage.read(key: 'token');
    return token;
  }

  Future<bool> isSignedIn() async {
    String? token = await storage.read(key: 'token');
    return token != null;
  }

  Future<void> checkSignIn(BuildContext context) async {
    if (await isSignedIn()) {
      Navigator.pushReplacementNamed(context, '/orderlist');
    } else {
      Navigator.pushReplacementNamed(context, '/signin');
    }
  }
}
