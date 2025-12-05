import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = "http://10.0.2.2:5000/api";

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
      return true; // Registered successfully
    } else {
      print("Error: ${response.statusCode} - ${response.body}");
      return false;
    }
  }
}
