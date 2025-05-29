import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PassSecurityScreen extends StatefulWidget {
  const PassSecurityScreen({super.key});

  @override
  State<PassSecurityScreen> createState() => _PassSecurityScreenState();
}

class _PassSecurityScreenState extends State<PassSecurityScreen> {
  final TextEditingController currentPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  final TextEditingController currentEmailController = TextEditingController();
  final TextEditingController newEmailController = TextEditingController();
  final TextEditingController confirmEmailController = TextEditingController();

  @override
  void dispose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    currentEmailController.dispose();
    newEmailController.dispose();
    confirmEmailController.dispose();
    super.dispose();
  }

  Widget buildTextField(String hint, TextEditingController controller, {bool obscureText = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hint,
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          filled: true,
          fillColor: Colors.white,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget buildConfirmButton(VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Center(
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF880000),
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
          ),
          child: const Text("Confirm", style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }

  Future<void> changePassword() async {
    final currentPassword = currentPasswordController.text.trim();
    final newPassword = newPasswordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (currentPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      _showErrorDialog("All fields are required.");
      return;
    }

    if (newPassword != confirmPassword) {
      _showErrorDialog("New password and confirm password do not match.");
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedPassword = prefs.getString('registeredPassword');
    if (savedPassword != currentPassword) {
      _showErrorDialog("Current password is incorrect.");
      return;
    }

    await prefs.setString('registeredPassword', newPassword);
    _showSuccessDialog("Password changed successfully!");
  }

  Future<void> changeEmail() async {
    final currentEmail = currentEmailController.text.trim();
    final newEmail = newEmailController.text.trim();
    final confirmEmail = confirmEmailController.text.trim();

    if (currentEmail.isEmpty || newEmail.isEmpty || confirmEmail.isEmpty) {
      _showErrorDialog("All fields are required.");
      return;
    }

    if (newEmail != confirmEmail) {
      _showErrorDialog("New email and confirm email do not match.");
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedEmail = prefs.getString('registeredEmail');
    if (savedEmail != currentEmail) {
      _showErrorDialog("Current email is incorrect.");
      return;
    }

    await prefs.setString('registeredEmail', newEmail);
    _showSuccessDialog("Email changed successfully!");
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Success"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF880000),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          'Password & Security',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            children: [
              // Change Password Section
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Center(
                      child: Text(
                        "Change Password",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 10),
                    buildTextField("Current Password", currentPasswordController, obscureText: true),
                    buildTextField("New Password", newPasswordController, obscureText: true),
                    buildTextField("Confirm Password", confirmPasswordController, obscureText: true),
                    buildConfirmButton(() {
                      changePassword();
                    }),
                  ],
                ),
              ),

              // Change Email Section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Center(
                      child: Text(
                        "Change Email",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 10),
                    buildTextField("Current Email", currentEmailController),
                    buildTextField("New Email", newEmailController),
                    buildTextField("Confirm Email", confirmEmailController),
                    buildConfirmButton(() {
                      changeEmail();
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
