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

  // controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();

  // password controllers
  final currentPassController = TextEditingController();
  final newPassController = TextEditingController();
  final confirmPassController = TextEditingController();

  // obscure toggles
  bool obscureCurrent = true;
  bool obscureNew = true;
  bool obscureConfirm = true;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  @override
  void dispose() {
    // dispose controllers
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    currentPassController.dispose();
    newPassController.dispose();
    confirmPassController.dispose();
    super.dispose();
  }

  Future<void> loadProfile() async {
    setState(() => loading = true);
    final data = await api.getMyProfile();
    if (mounted) {
      if (data != null) {
        // تأكدي أسماء الحقول هنا تطابق اللي بيرجعوه من السيرفر
      nameController.text = data["Name"] ?? "";
     emailController.text = data["Email"] ?? "";
     phoneController.text = data["PhoneNumber"] ?? "";
     addressController.text = data["Address"]??"";
      }
      setState(() => loading = false);
    }
  }

  Future<void> saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    // check password match if entered
    if (newPassController.text.isNotEmpty) {
      if (newPassController.text != confirmPassController.text) {
        showSnack("كلمة المرور وتأكيدها غير متطابقين");
        return;
      }
      if (currentPassController.text.isEmpty) {
        showSnack("رجاءً أدخلي كلمة المرور الحالية لتغييرها");
        return;
      }
    }

    // call update profile
    showLoadingDialog();
    final updateRes = await api.updateProfile(
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      phoneNumber: phoneController.text.trim(),
      address: addressController.text.trim(),
    );

    bool okUpdate = updateRes["success"] == true;
    String updateMsg = updateRes["message"]?.toString() ?? "";

    bool okPass = true;
    String passMsg = "";

    // if user wants to change password
    if (newPassController.text.isNotEmpty) {
      final passRes = await api.changePassword(
        currentPassword: currentPassController.text,
        newPassword: newPassController.text,
        confirmNewPassword: confirmPassController.text,
      );
      okPass = passRes["success"] == true;
      passMsg = passRes["message"]?.toString() ?? "";
    }

    Navigator.of(context).pop(); // close loading dialog

    // aggregate results
    if (okUpdate && okPass) {
      showSnack("تم حفظ التغييرات بنجاح");
      // clear password fields
      currentPassController.clear();
      newPassController.clear();
      confirmPassController.clear();
    } else {
      // show combined message (prefer server messages)
      String msg = "";
      if (!okUpdate) msg += "حفظ البيانات فشل: $updateMsg";
      if (!okPass) {
        if (msg.isNotEmpty) msg += "\n";
        msg += "تغيير كلمة المرور فشل: $passMsg";
      }
      showSnack(msg);
    }
  }

  void showSnack(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text, textAlign: TextAlign.right)),
    );
  }

  void showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
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
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 3))],
              ),
              child: Form(
                key: _formKey,
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  // --- name & email
                  Row(children: [
                    Expanded(
                      child: _buildTextField(controller: nameController, label: "الاسم الكامل", hint: "Karim"),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: _buildTextField(controller: emailController, label: "البريد الإلكتروني", hint: "karim@example.com"),
                    ),
                  ]),
                  _buildTextField(controller: phoneController, label: "رقم الهاتف", hint: ""),
                  _buildTextField(controller: addressController, label: "العنوان", hint: ""),

                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text('تغيير كلمة المرور (اختياري)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0D416A))),
                  ),

                  // current password
                  _buildPasswordField(
                    controller: currentPassController,
                    label: "كلمة المرور الحالية",
                    obscure: obscureCurrent,
                    onToggle: () => setState(() => obscureCurrent = !obscureCurrent),
                  ),

                  Row(children: [
                    Expanded(
                      child: _buildPasswordField(
                        controller: newPassController,
                        label: "كلمة المرور الجديدة",
                        obscure: obscureNew,
                        onToggle: () => setState(() => obscureNew = !obscureNew),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: _buildPasswordField(
                        controller: confirmPassController,
                        label: "تأكيد كلمة المرور",
                        obscure: obscureConfirm,
                        onToggle: () => setState(() => obscureConfirm = !obscureConfirm),
                      ),
                    ),
                  ]),

                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0D416A), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                      onPressed: saveProfile,
                      child: const Text("حفظ التغييرات", style: TextStyle(color: Colors.white, fontSize: 18)),
                    ),
                  ),
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({required TextEditingController controller, required String label, required String hint}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25),
      child: TextFormField(
        controller: controller,
        textAlign: TextAlign.right,
        validator: (v) {
          if (label == "الاسم الكامل" && (v == null || v.trim().length < 3)) return "الاسم يجب أن يكون 3 أحرف على الأقل";
          if (label == "البريد الإلكتروني" && (v == null || !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(v.trim()))) return "اكتب بريد إلكتروني صالح";
          return null;
        },
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelText: label,
          hintText: hint,
          contentPadding: const EdgeInsets.symmetric(vertical: 17, horizontal: 15),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          filled: true,
          fillColor: Colors.grey[50],
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool obscure,
    required VoidCallback onToggle,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25),
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        textAlign: TextAlign.right,
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelText: label,
          contentPadding: const EdgeInsets.symmetric(vertical: 17, horizontal: 15),
          suffixIcon: IconButton(
            icon: Icon(obscure ? Icons.visibility_off : Icons.visibility),
            onPressed: onToggle,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          filled: true,
          fillColor: Colors.grey[50],
        ),
     ),
);
}
}
