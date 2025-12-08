import 'package:flutter/material.dart';
import '/api/api_profile.dart';
import 'Home_page.dart';
import 'my_saved.dart';

class PatientProfileScreen extends StatefulWidget {
  const PatientProfileScreen({super.key});

  @override
  State<PatientProfileScreen> createState() => _PatientProfileScreenState();
}

class _PatientProfileScreenState extends State<PatientProfileScreen> {
  final api = PatientProfileApiService();
  final _formKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();

  final name = TextEditingController();
  final email = TextEditingController();
  final phone = TextEditingController();
  final address = TextEditingController();

  final currentPass = TextEditingController();
  final newPass = TextEditingController();
  final confirmPass = TextEditingController();

  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final profile = await api.getMyProfile();
    if (profile != null) {
      name.text = profile.name;
      email.text = profile.email;
      phone.text = profile.phoneNumber;
      address.text = profile.address;
    }
    setState(() => loading = false);
  }

  Future<void> saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => loading = true);

    final res = await api.updateProfile(
      name: name.text.trim(),
      email: email.text.trim(),
      phoneNumber: phone.text.trim(),
      address: address.text.trim(),
    );

    setState(() => loading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          res["success"] == true
              ? "تم تحديث البيانات بنجاح"
              : res["message"] ?? "حدث خطأ",
        ),
      ),
    );
  }

  Future<void> changePassword() async {
    if (!_passwordFormKey.currentState!.validate()) return;

    setState(() => loading = true);

    final res = await api.changePassword(
      currentPassword: currentPass.text.trim(),
      newPassword: newPass.text.trim(),
      confirmNewPassword: confirmPass.text.trim(),
    );

    setState(() => loading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          res["success"] == true
              ? "تم تغيير كلمة المرور بنجاح"
              : res["message"] ?? "فشل تغيير كلمة المرور",
        ),
      ),
    );

    if (res["success"] == true) {
      currentPass.clear();
      newPass.clear();
      confirmPass.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
          title: Align(
            alignment: Alignment.centerLeft,
            child: Image.asset("Image/Logo.png", height: 45),
          ),
        ),

        body: SafeArea(
          child: loading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        "الملف الشخصي",
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 3, 32, 61),
                        ),
                      ),
                      const SizedBox(height: 20),

                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 242, 247, 252),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              _arabicField(name, "الاسم الكامل", Icons.person),
                              const SizedBox(height: 10),
                              _arabicField(
                                email,
                                "البريد الإلكتروني",
                                Icons.email,
                              ),
                              const SizedBox(height: 10),
                              _arabicField(phone, "رقم الهاتف", Icons.phone),
                              const SizedBox(height: 10),
                              _arabicField(
                                address,
                                "العنوان",
                                Icons.location_on,
                              ),
                              const SizedBox(height: 20),

                              Form(
                                key: _passwordFormKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "تغيير كلمة المرور",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    _smallPasswordField(
                                      currentPass,
                                      "كلمة المرور الحالية",
                                    ),
                                    const SizedBox(height: 8),
                                    _smallPasswordField(
                                      newPass,
                                      "كلمة المرور الجديدة",
                                    ),
                                    const SizedBox(height: 8),
                                    _smallPasswordField(
                                      confirmPass,
                                      "تأكيد كلمة المرور الجديدة",
                                    ),
                                    const SizedBox(height: 10),
                                    GestureDetector(
                                      onTap: changePassword,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 10,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius: BorderRadius.circular(
                                            15,
                                          ),
                                        ),
                                        child: const Center(
                                          child: Text(
                                            "تغيير كلمة المرور",
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Color.fromARGB(
                                                255,
                                                1,
                                                13,
                                                33,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 20),

                              GestureDetector(
                                onTap: saveProfile,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 15,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      "حفظ التغييرات",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromARGB(255, 1, 13, 33),
                                      ),
                                    ),
                                  ),
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
        bottomNavigationBar: Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(Icons.person_outline, color: Colors.blue),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => PatientProfileScreen()),
                  );
                },
              ),

              IconButton(
                icon: const Icon(Icons.favorite_border, color: Colors.blue),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => MySavedServicesPage()),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.home, color: Colors.blue),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => HomePagem(),
                    ), // your home page
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _arabicField(
    TextEditingController controller,
    String label,
    IconData icon,
  ) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 15,
        ),
      ),
      validator: (v) => v!.trim().isEmpty ? "هذا الحقل مطلوب" : null,
    );
  }

  Widget _smallPasswordField(TextEditingController controller, String label) {
    return TextFormField(
      controller: controller,
      obscureText: true,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.lock, size: 18),
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 10,
        ),
      ),
      style: const TextStyle(fontSize: 14),
      validator: (v) => v!.trim().isEmpty ? "هذا الحقل مطلوب" : null,
    );
  }
}
