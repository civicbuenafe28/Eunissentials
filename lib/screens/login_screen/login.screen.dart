import 'package:eunissentials/utils/global.colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eunissentials/utils/shared_prefs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:eunissentials/screens/home_screen/main_menu.screen.dart';  // Import MainMenuScreen

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            // Top red header with "Sign In" text
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(
                top: 60, // Adjust for safe area
                left: 20,
                right: 20,
                bottom: 15,
              ),
              color: GlobalColors.textColor,
              child: const Text(
                'Sign In',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Main content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 30),

                      // Welcome back text
                      const Center(
                        child: Text(
                          'WELCOME BACK!',
                          style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Sign in to your account text
                      const Center(
                        child: Text(
                          'Sign in to your account',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                      const SizedBox(height: 80),

                      // Email Address field
                      const Text(
                        'Email Address',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: 'Enter your email address',
                          hintStyle: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 14,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 15,
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),

                      // Password field
                      const Text(
                        'Password',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: 'Enter your password',
                          hintStyle: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 14,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 15,
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Sign In button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () async {
                            final enteredEmail = _emailController.text.trim();
                            final enteredPassword = _passwordController.text.trim();

                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            String? savedEmail = prefs.getString('registeredEmail');
                            String? savedPassword = prefs.getString('registeredPassword');

                            if (savedEmail == null || savedPassword == null) {
                              showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: const Text("Error"),
                                  content: const Text("No account found. Please sign up first."),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pop(),
                                      child: const Text("OK"),
                                    ),
                                  ],
                                ),
                              );
                              return;
                            }

                            if (enteredEmail == savedEmail && enteredPassword == savedPassword) {
                              // Retrieve user data and save it
                              Map<String, dynamic> userData = await SharedPrefs.getUserData();

                              await SharedPrefs.saveUserData(
                                userName: userData['userName']?.toString() ?? '[Name Here]',
                                membershipType: userData['membershipType']?.toString() ?? '[Membership Type Here]',
                                birthday: userData['birthday']?.toString() ?? '[Birthday Here]',
                                email: enteredEmail,
                                contactNumber: userData['contactNumber']?.toString() ?? '[Contact Number Here]',
                              );

                              // Navigate to MainMenuScreen
                              Get.off(() => const MainMenuScreen());  // Correct usage of MainMenuScreen
                            } else {
                              showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: const Text("Error"),
                                  content: const Text("Invalid email or password."),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pop(),
                                      child: const Text("OK"),
                                    ),
                                  ],
                                ),
                              );
                            }
                          },

                          style: ElevatedButton.styleFrom(
                            backgroundColor: GlobalColors.textColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          child: const Text(
                            'Sign In',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Go Back button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            Get.back();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey.shade300,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          child: Text(
                            'Go Back',
                            style: TextStyle(
                              color: GlobalColors.textColor,
                              fontSize: 25,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
