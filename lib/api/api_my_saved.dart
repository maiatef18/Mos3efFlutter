import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_service.dart';

class SavedServicesApi {
  final String baseUrl = "http://10.0.2.2:5000";

  Future<List<dynamic>> getSavedServices() async {
    final url = Uri.parse(
      "$baseUrl/api/Patients/my-saved-services?pageNumber=1&pageSize=10",
    );
    final token = await getToken();
    if (token == null) {
      throw Exception("User not logged in – token is null");
    }
    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["items"];
    } else {
      throw Exception("Failed to load saved services");
    }
  }

  Future<bool> removeFromSaved(int serviceId) async {
    final url = Uri.parse("$baseUrl/api/Patients/my-saved-services/$serviceId");
    final token = await getToken();
    if (token == null) {
      throw Exception("User not logged in – token is null");
    }
    final response = await http.delete(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    return response.statusCode == 200 || response.statusCode == 204;
  }

  Future<bool> addToSaved(int serviceId) async {
    final url = Uri.parse("$baseUrl/api/Patients/my-saved-services/$serviceId");
    final token = await getToken();
    if (token == null) {
      throw Exception("User not logged in – token is null");
    }

    final response = await http.post(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    return response.statusCode == 200 ||
        response.statusCode == 201 ||
        response.statusCode == 204;
  }
}
