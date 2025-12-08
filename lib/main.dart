import 'package:flutter/material.dart';
import 'api/api_service.dart';
//import 'search_page.dart';
import '/pages/Register_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ApiService api = ApiService();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: RegisterPage(api: api),
      ),
    );
  }
}
