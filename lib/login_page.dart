import 'package:flutter/material.dart';
import 'api_service.dart';
import 'register_page.dart';
import 'Home_page.dart';

class LoginPage extends StatefulWidget {
  final ApiService api;

  const LoginPage({super.key, required this.api});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _loading = false;
  String _message = "";

  void _login() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _message = "يرجى إدخال البريد الإلكتروني وكلمة المرور";
      });
      return;
    }

    setState(() {
      _loading = true;
      _message = "";
    });

    bool success = await widget.api.loginUser(email: email, password: password);

    setState(() {
      _loading = false;
    });

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("تم تسجيل الدخول بنجاح")),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePagem()),
      );
    } else {
      setState(() {
        _message = "البريد الإلكتروني أو كلمة المرور غير صحيحة";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // 🔥 Arabic RTL
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              // ---------------- HEADER ----------------
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => HomePagem()),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 3, 32, 61),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Text(
                          "الرئيسية",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    Image.asset('Image/Logo.png', width: 90, height: 90),

                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => RegisterPage(api: widget.api)),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 69, 117, 157),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Text(
                              "تسجيل",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(width: 10),

                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(
                                color: Color.fromARGB(255, 1, 13, 33),
                                width: 2,
                              ),
                            ),
                            child: Text(
                              "دخول",
                              style: TextStyle(
                                color: Color.fromARGB(255, 1, 13, 33),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 30),

              // ---------------- BODY ----------------
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Image.asset('Image/Doctors_bro_1.png', width: 250, height: 250),
                      SizedBox(height: 20),

                      Image.asset(
                        'Image/Container.png',
                        width: double.infinity,
                        height: 120,
                        fit: BoxFit.cover,
                      ),

                      SizedBox(height: 25),

                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: "البريد الإلكتروني",
                          prefixIcon: Icon(Icons.email),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                        ),
                      ),

                      SizedBox(height: 15),

                      TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "كلمة المرور",
                          prefixIcon: Icon(Icons.lock),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                        ),
                      ),

                      SizedBox(height: 25),

                      GestureDetector(
                        onTap: _loading ? null : _login,
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 117, 169, 220),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: _loading
                                ? CircularProgressIndicator(color: Colors.white)
                                : Text(
                                    "دخول",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                      ),

                      SizedBox(height: 20),

                      Text(
                        _message,
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
