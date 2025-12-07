import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_service.dart';   // <-- هنا عشان نستدعي getToken()

class PatientProfileApiService {
  final String baseUrl = "http://10.0.2.2:5000/api/Patients";

  // ======================= GET PROFILE =======================
  Future<Map<String, dynamic>?> getMyProfile() async {
    try {
      final url = Uri.parse("$baseUrl/my-profile");
      final token = await getToken();

      if (token == null) throw Exception("Token is null");

      final response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print("PROFILE ERROR: ${response.body}");
        return null;
      }
    } catch (e) {
      print("GET PROFILE EXCEPTION: $e");
      return null;
    }
  }

  // ======================= UPDATE PROFILE =======================
  Future<bool> updateProfile({
    required String name,
    required String email,
    required String phoneNumber,
    required String address,
    String profilePicture = "",
  }) async {
    try {
      final url = Uri.parse("$baseUrl/update");

      final body = {
        "Name": name,
        "Email": email,
        "PhoneNumber": phoneNumber,
        "Address": address,
        "ProfilePicture": profilePicture,
      };

      final token = await getToken();
      if (token == null) throw Exception("Token is null");

      final response = await http.put(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        },
        body: jsonEncode(body),
      );

      return response.statusCode == 200;
    } catch (e) {
      print("UPDATE EXCEPTION: $e");
      return false;
    }
  }

  // ======================= CHANGE PASSWORD =======================
  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmNewPassword,
  }) async {
    try {
      final url = Uri.parse("$baseUrl/change-password");

      final body = {
        "currentPassword": currentPassword,
        "newPassword": newPassword,
        "confirmNewPassword": confirmNewPassword,
      };

      final token = await getToken();
      if (token == null) throw Exception("Token is null");

      final response = await http.put(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        },
        body: jsonEncode(body),
      );

      return response.statusCode == 200;
    } catch (e) {
      print("CHANGE PASSWORD EXCEPTION: $e");
      return false;
}
}
}