import 'package:flutter/material.dart';
import 'api_service.dart';
import 'login_page.dart';
import 'home_page.dart';
class RegisterPage extends StatefulWidget {
  final ApiService api;

  const RegisterPage({super.key, required this.api});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmTextController = TextEditingController();

  bool _loading = false;
  String _message = "";

  void _register() async {
    String name = _nameController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text;
    String confirmPassword = _confirmTextController.text;

    if (name.length < 3) {
      setState(() {
        _message = "Name must be at least 3 characters";
      });
      return;
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      setState(() {
        _message = "Please enter a valid email";
      });
      return;
    }

    if (password.length < 6) {
      setState(() {
        _message = "Password must be at least 6 characters";
      });
      return;
    }

    if (password != confirmPassword) {
      setState(() {
        _message = "Passwords do not match";
      });
      return;
    }

    setState(() {
      _loading = true;
      _message = "";
    });

    bool success = await widget.api.registerUser(
      name: name,
      email: email,
      password: password,
      confirmPassword: confirmPassword,
    );

    setState(() {
      _loading = false;
    });

    if (success) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Registered successfully!")));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LoginPage(api: widget.api)),
      );
    } else {
      setState(() {
        _message = "Registration failed!";
      });
    }
  }

@override
Widget build(BuildContext context) {
  return Directionality(
    textDirection: TextDirection.rtl,
    child: Scaffold(
      body: SafeArea(
        child: Column(
          children: [
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
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),

                  Image.asset('Image/Logo.png', width: 90, height: 90),

                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 69, 117, 157),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Text(
                            "تسجيل",
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),

                      SizedBox(width: 10),

                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => LoginPage(api: widget.api)),
                          );
                        },
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
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

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
                    SizedBox(height: 20),
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: "الاسم",
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                    ),
                    SizedBox(height: 10),

                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: "البريد الإلكتروني",
                        prefixIcon: Icon(Icons.email),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                    ),
                    SizedBox(height: 10),

                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "كلمة المرور",
                        prefixIcon: Icon(Icons.lock),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                    ),
                    SizedBox(height: 10),

                    TextField(
                      controller: _confirmTextController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "تأكيد كلمة المرور",
                        prefixIcon: Icon(Icons.lock_outline),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                    ),

                    SizedBox(height: 20),
                    GestureDetector(
                      onTap: _register,
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 139, 195, 240),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: _loading
                              ? CircularProgressIndicator(color: Colors.white)
                              : Text(
                                  "تسجيل",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 1, 13, 33),
                                  ),
                                ),
                        ),
                      ),
                    ),

                    SizedBox(height: 20),
                    Text(
                      _message,
                      style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
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

