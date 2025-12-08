import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>?> fetchServiceById(int id) async {
  final url = Uri.parse('http://10.0.2.2:5000/api/Services/$id');

  final response = await http.get(url);
  if (response.statusCode == 200) {
    final jsonResponse = jsonDecode(response.body);
    return jsonResponse['data'];
  } else {
    print("Error: ${response.statusCode}");
    return null;
  }
}
