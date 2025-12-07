import 'package:flutter/material.dart';
import 'api_profile.dart';

class PatientProfileScreen extends StatefulWidget {
  const PatientProfileScreen({super.key});

  @override
  State<PatientProfileScreen> createState() => _PatientProfileScreenState();
}

class _PatientProfileScreenState extends State<PatientProfileScreen> {
  final api = PatientProfileApiService();
  final _formKey = GlobalKey<FormState>();
  bool loading = true;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    final data = await api.getMyProfile();
    if (mounted && data != null) {
      nameController.text = data["name"] ?? "";
      emailController.text = data["email"] ?? "";
      phoneController.text = data["phoneNumber"] ?? "";
      addressController.text = data["address"] ?? "";
    }
    setState(() {
      loading = false;
    });
  }

  Future<void> saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    // التحقق من كلمة المرور إذا تم إدخالها
    if (passwordController.text.isNotEmpty &&
        passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("كلمة المرور وتأكيدها غير متطابقين")),
      );
      return;
    }

    bool profileUpdated = await api.updateProfile(
      name: nameController.text,
      email: emailController.text,
      phoneNumber: phoneController.text,
      address: addressController.text,
    );

    bool passwordUpdated = true;
    if (passwordController.text.isNotEmpty) {
      passwordUpdated = await api.changePassword(
        currentPassword: "", // لو عندك الحقل الحالي من تسجيل الدخول
        newPassword: passwordController.text,
        confirmNewPassword: confirmPasswordController.text,
      );
    }

    if (profileUpdated && passwordUpdated) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("تم حفظ التغييرات بنجاح")),
      );
      passwordController.clear();
      confirmPasswordController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("حدث خطأ أثناء الحفظ")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F9FC),
        appBar: AppBar(
          backgroundColor: const Color(0xFF0D416A),
          title: const Text("تعديل البيانات الشخصية"),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              width: 600,
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // صورة البروفايل
                    Center(
                      child: Stack(
                        alignment: Alignment.bottomLeft,
                        children: [
                          Container(
                            height: 110,
                            width: 110,
                            decoration: const BoxDecoration(
                              color: Color(0xFFE0E0E0),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.person_outline,
                              color: Color(0xFF0D416A),
                              size: 60,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.camera_alt_outlined,
                              size: 20,
                              color: Color(0xFF0D416A),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),

                    // الاسم و الايميل
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            controller: nameController,
                            label: "الاسم الكامل",
                            hint: "Karim",
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: _buildTextField(
                            controller: emailController,
                            label: "البريد الإلكتروني",
                            hint: "karim@example.com",
                          ),
                        ),
                      ],
                    ),
                    _buildTextField(
                      controller: phoneController,
                      label: "رقم الهاتف",
                      hint: "",
                    ),
                    _buildTextField(
                      controller: addressController,
                      label: "العنوان",
                      hint: "",
                    ),

                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        'كلمة المرور',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0D416A),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            controller: passwordController,
                            label: "كلمة المرور الجديدة",
                            hint: "",
                            isPassword: true,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: _buildTextField(
                            controller: confirmPasswordController,
                            label: "تأكيد كلمة المرور",
                            hint: "",
                            isPassword: true,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0D416A),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: saveProfile,
                        child: const Text(
                          "حفظ التغييرات",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    bool isPassword = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        textAlign: TextAlign.right,
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelText: label,
          labelStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
          hintText: hint,
          hintStyle: const TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
          suffixIcon: isPassword ? const Icon(Icons.remove_red_eye_outlined) : null,
          contentPadding: const EdgeInsets.symmetric(vertical: 17, horizontal: 15),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFF0D416A), width: 1.5),
          ),
          filled: true,
          fillColor: Colors.grey[50],
        ),
     ),
);
}
}