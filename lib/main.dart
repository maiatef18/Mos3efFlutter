import 'package:flutter/material.dart';
import 'package:hello_flutter/service_details.dart';
import 'api_service.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final ApiService api = ApiService();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: RegisterPage(api: api),
      home: ServiceDetailsPage(id: 2),
    );
  }
}
