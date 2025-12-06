import 'package:flutter/material.dart';
import 'api_service.dart';
import 'search_page.dart';
import 'Register_page.dart';
import 'service_details.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ApiService api = ApiService();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Directionality(
        textDirection: TextDirection.rtl, 
       child:
       // ServicesPage(api: api),
        RegisterPage(api:api),
       // ServiceDetailsPage(id: 2)
      ),
    );
  }
}
