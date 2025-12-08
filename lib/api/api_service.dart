import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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

    final body = jsonEncode({"email": email, "password": password});

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data['isSuccess'] == true) {
        final token = data['token']; // extract the token

        // Save token locally
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);
        await prefs.setString('userId', data['userId']);
        await prefs.setString('email', data['email']);
        await prefs.setString('password', password);

        print("Login successful, token saved: $token");
      }
      return true;
    } else {
      print("Login Error: ${response.statusCode} - ${response.body}");
      return false;
    }
  }

  // ================= Search Services =================
  Future<List<dynamic>> searchServices({
    String? keyword,
    String? category,
  }) async {
    Map<String, String> queryParams = {};

    if (keyword != null && keyword.isNotEmpty) {
      queryParams['keyword'] = keyword.trim();
    }
    if (category != null && category.isNotEmpty) {
      queryParams['category'] = category;
    }

    final uri = Uri.parse(
      '$baseUrl/Services/search',
    ).replace(queryParameters: queryParams);
    print("Search URL: $uri"); // Debug: check the full URL

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print('Search Error: ${response.statusCode} - ${response.body}');
      throw Exception('Failed to fetch services');
    }
  }
}

//rstore token
Future<String?> getToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('auth_token');
}
