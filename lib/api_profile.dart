import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_service.dart'; // يفترض فيه getToken()

class PatientProfileApiService {
  final String baseUrl = "http://10.0.2.2:5000/api/Patients";

  // GET PROFILE
  Future<Map<String, dynamic>?> getMyProfile() async {
    try {
      final token = await getToken();
      if (token == null) throw Exception("token null");

      final url = Uri.parse("$baseUrl/my-profile");
      final response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        print("GET PROFILE ERROR: ${response.statusCode} ${response.body}");
        return null;
      }
    } catch (e) {
      print("GET PROFILE EXCEPTION: $e");
      return null;
    }
  }

  // UPDATE PROFILE -> returns { success: bool, message: String }
  Future<Map<String, dynamic>> updateProfile({
  required String name,
  required String email,
  required String phoneNumber,
  required String address,
  String profilePicture = "",
}) async {
  try {
    final token = await getToken();
    if (token == null) {
      return {"success": false, "message": "User not logged in"};
    }

    final url = Uri.parse("$baseUrl/update");

    final Map<String, dynamic> body = {
      "Name": name,
      "Email": email,
      "Address": address,
      "PhoneNumber": phoneNumber,
      "ProfilePicture": profilePicture, // لو مش هتبعت صورة سيبيه فاضية
    };

    final response = await http.put(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      return {"success": true, "message": "Profile updated successfully"};
    } else {
      return {
        "success": false,
        "message": response.body.isNotEmpty
            ? response.body
            : "Error ${response.statusCode}"
      };
    }
  } catch (e) {
    return {"success": false, "message": e.toString()};
}
}
  // CHANGE PASSWORD -> returns { success: bool, message: String }
  Future<Map<String, dynamic>> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmNewPassword,
  }) async {
    try {
      final token = await getToken();
      if (token == null) return {"success": false, "message": "User not logged in."};

      final url = Uri.parse("$baseUrl/change-password");

      final Map<String, dynamic> body = {
        "currentPassword": currentPassword,
        "newPassword": newPassword,
        "confirmNewPassword": confirmNewPassword,
      };

      final response = await http.put(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        return {"success": true, "message": "Password changed"};
      } else {
        String msg = response.body.isNotEmpty ? response.body : "Server error ${response.statusCode}";
        return {"success": false, "message": msg};
      }
    } catch (e) {
      print("CHANGE PASSWORD EXCEPTION: $e");
      return {"success": false, "message": e.toString()};
}
}
}