import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'api_service.dart';

class PatientProfile {
  final String name;
  final String email;
  final String phoneNumber;
  final String address;

  PatientProfile({
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.address,
  });

  factory PatientProfile.fromJson(Map<String, dynamic> json) {
    return PatientProfile(
      name: json["name"] ?? "",
      email: json["email"] ?? "",
      phoneNumber: json["phoneNumber"] ?? "",
      address: json["address"] ?? "",
    );
  }
}

class PatientProfileApiService {
  final String baseUrl = "http://10.0.2.2:5000/api/Patients";

  // GET PROFILE
  Future<PatientProfile?> getMyProfile() async {
    try {
      final token = await getToken();
      if (token == null) throw Exception("No token");

      final url = Uri.parse("$baseUrl/my-profile");
      final response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return PatientProfile.fromJson(data);
      } else {
        print("GET PROFILE ERROR: ${response.statusCode} ${response.body}");
        return null;
      }
    } catch (e) {
      print("GET PROFILE EXCEPTION: $e");
      return null;
    }
  }

  // UPDATE PROFILE (Multipart/form-data)
  Future<Map<String, dynamic>> updateProfile({
    required String name,
    required String email,
    required String phoneNumber,
    required String address,
    File? profilePicture,
  }) async {
    try {
      final token = await getToken();
      if (token == null) {
        return {"success": false, "message": "User not logged in"};
      }

      final url = Uri.parse("$baseUrl/my-profile");
      var request = http.MultipartRequest("PUT", url);
      request.headers["Authorization"] = "Bearer $token";

      request.fields["Name"] = name;
      request.fields["Email"] = email;
      request.fields["PhoneNumber"] = phoneNumber;
      request.fields["Address"] = address;

      if (profilePicture != null) {
        request.files.add(await http.MultipartFile.fromPath(
          "ProfilePicture",
          profilePicture.path,
          contentType: MediaType("image", "jpeg"),
        ));
      }

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      if (response.statusCode == 204) {
        return {"success": true, "message": "Profile updated"};
      } else {
        return {"success": false, "message": responseBody};
      }
    } catch (e) {
      return {"success": false, "message": e.toString()};
    }
  }

  // CHANGE PASSWORD
  Future<Map<String, dynamic>> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmNewPassword,
  }) async {
    try {
      final token = await getToken();
      if (token == null) return {"success": false, "message": "User not logged in."};

      final url = Uri.parse("http://10.0.2.2:5000/api/Account/change-password");

      final body = {
        "CurrentPassword": currentPassword,
        "NewPassword": newPassword,
        "ConfirmNewPassword": confirmNewPassword,
      };

      final response = await http.post(
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
        String msg = response.body.isNotEmpty
            ? response.body
            : "Server error ${response.statusCode}";
        return {"success": false, "message": msg};
      }
    } catch (e) {
      return {"success": false, "message": e.toString()};
    }
  }
}
