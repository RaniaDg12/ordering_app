import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final String baseUrl = 'http://192.168.56.1:3000';
  final storage = FlutterSecureStorage();

  Future<String?> signIn(String username, String password) async {
    final url = Uri.parse('$baseUrl/auth/signin?name=$username&password=$password');
    final response = await http.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final token = responseData['token'];
      await storage.write(key: 'token', value: token);

    } else {
      final responseData = jsonDecode(response.body);
      return responseData['message'];
    }
  }

  Future<void> signOut() async {
    await storage.delete(key: 'token');
  }

  Future<String?> getToken() async {
    return await storage.read(key: 'token');
  }
}
