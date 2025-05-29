import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'wallet.screen.dart';
import 'password_security.screen.dart';
import '../login_screen/welcome_home.screen.dart';
import 'package:eunissentials/utils/shared_prefs.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _image;

  // Controllers now have empty initial values as we'll load them from SharedPrefs
  final _nameController = TextEditingController();
  final _membershipTypeController = TextEditingController();
  final _birthdayController = TextEditingController(text: 'Enter your birthday (MM/DD/YYYY)');
  final _emailController = TextEditingController();
  final _contactController = TextEditingController(text: 'Enter your contact number');

  @override
  void initState() {
    super.initState();

    // For debugging - directly check SharedPreferences
    _checkSharedPrefsDirectly();

    // Load user data when screen initializes
    _loadUserData();
  }

  // Debug method to check raw SharedPreferences values
  Future<void> _checkSharedPrefsDirectly() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('userName');
    final type = prefs.getString('membershipType');
    final email = prefs.getString('userEmail');

    print("DIRECT PREFS CHECK: Name=$name, Type=$type, Email=$email");
  }

  // Load user data from SharedPrefs
  Future<void> _loadUserData() async {
    final userData = await SharedPrefs.getUserData();

    // Print for debugging
    print("LOADED USER DATA: $userData");

    setState(() {
      _nameController.text = userData['userName'] ?? '[Name Displayed Here]';
      _membershipTypeController.text = userData['membershipType'] ?? '[Membership Type Displayed Here]';
      _birthdayController.text = userData['birthday']?.isNotEmpty == true ? userData['birthday']! : 'Enter your birthday (MM/DD/YYYY)';
      _emailController.text = userData['userEmail'] ?? '[Email Display Here]'; // Changed 'email' to 'userEmail' to match SharedPrefs
      _contactController.text = userData['contactNumber']?.isNotEmpty == true ? userData['contactNumber']! : 'Enter your contact number';
    });
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _editFieldDialog(String title, TextEditingController controller) {
    if (title == "Birthday") {
      _pickBirthday();
    } else {
      final tempController = TextEditingController(text: controller.text);
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Edit $title'),
            content: TextField(
              controller: tempController,
              decoration: InputDecoration(hintText: 'Enter new $title'),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  setState(() {
                    controller.text = tempController.text;
                  });

                  // Save the updated data to SharedPrefs
                  if (title == "Contact Number") {
                    await SharedPrefs.saveUserData(
                        userName: _nameController.text,
                        membershipType: _membershipTypeController.text,
                        birthday: _birthdayController.text,
                        email: _emailController.text,
                        contactNumber: tempController.text
                    );
                  }

                  Navigator.of(context).pop();
                },
                child: const Text('Save'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _pickBirthday() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      final newBirthday = "${pickedDate.month}/${pickedDate.day}/${pickedDate.year}";
      setState(() {
        _birthdayController.text = newBirthday;
      });

      // Save the updated birthday to SharedPrefs
      await SharedPrefs.saveUserData(
          userName: _nameController.text,
          membershipType: _membershipTypeController.text,
          birthday: newBirthday,
          email: _emailController.text,
          contactNumber: _contactController.text
      );
    }
  }

  Widget _displayField(String label, TextEditingController controller, {bool isEditable = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white)),
          const SizedBox(height: 4),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: Text(controller.text, style: const TextStyle(fontSize: 14))),
                if (isEditable)
                  GestureDetector(
                    onTap: () => _editFieldDialog(label, controller),
                    child: const Text(
                      'Edit',
                      style: TextStyle(
                          color: Color(0xFF8B1E1E), fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const darkRed = Color(0xFF8B1E1E);
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: AppBar(
        backgroundColor: darkRed,
        centerTitle: true,
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 28),
        ),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile Card
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: darkRed,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          color: Colors.white,
                        ),
                        child: _image == null
                            ? const Center(child: Text("Profile Photo"))
                            : ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Image.file(_image!, fit: BoxFit.cover),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          children: [
                            // Name and membership fields are not editable now
                            _displayField('Name', _nameController),
                            const SizedBox(height: 6),
                            _displayField('Membership Type', _membershipTypeController),
                            const SizedBox(height: 10),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (_) => const WalletScreen()));
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey[200],
                                  foregroundColor: Colors.black,
                                ),
                                child: const Text("EUniWallet"),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ElevatedButton(
                      onPressed: _pickImage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[800],
                        foregroundColor: Colors.white,
                      ),
                      child: const Text("Change Profile Photo"),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Details Card
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: darkRed,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  _displayField("Birthday", _birthdayController, isEditable: true),
                  _displayField("Email Address", _emailController),
                  _displayField("Contact Number", _contactController, isEditable: true),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Get.to(() => const PassSecurityScreen()),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[200],
                        foregroundColor: Colors.black,
                      ),
                      child: const Text("Password and Security"),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Get.offAll(() => const HomeScreen()),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[700],
                        foregroundColor: Colors.white,
                      ),
                      child: const Text("Log out"),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}