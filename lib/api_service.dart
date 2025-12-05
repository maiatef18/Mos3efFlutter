import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = "http://10.0.2.2:5000/api";

  // ================= Register =================
  Future<bool> registerUser({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    final url = Uri.parse('$baseUrl/Account/register/patient');

    final body = jsonEncode({
      "name": name,
      "email": email,
      "password": password,
      "confirmPassword": confirmPassword,
    });

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      print("Register Error: ${response.statusCode} - ${response.body}");
      return false;
    }
  }

  // ================= Login =================
  Future<bool> loginUser({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/Account/login');

    final body = jsonEncode({
      "email": email,
      "password": password,
    });

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    if (response.statusCode == 200) {
      print("Login successful");
      print("Response: ${response.body}");
      return true;
    } else {
      print("Login Error: ${response.statusCode} - ${response.body}");
      return false;
    }
  }
}
