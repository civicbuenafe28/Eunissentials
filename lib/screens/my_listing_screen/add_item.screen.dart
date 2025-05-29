import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'package:eunissentials/screens/home_screen/main_menu.screen.dart';
import 'package:eunissentials/screens/history_screen/transaction_history.screen.dart';
import 'package:eunissentials/screens/profile_screen/profile.screen.dart';

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({super.key});

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  String? _imagePath;
  final picker = ImagePicker();

  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _categoryController = TextEditingController();
  final _quantityController = TextEditingController();
  final _dateAddedController = TextEditingController();
  final _expirationDateController = TextEditingController();

  int _currentIndex = 1;

  @override
  void initState() {
    super.initState();
    _dateAddedController.text = DateFormat('MM/dd/yyyy').format(DateTime.now());
  }

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
      });
    }
  }

  Future<void> _selectDate(TextEditingController controller) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      controller.text = DateFormat('MM/dd/yyyy').format(picked);
    }
  }

  void _onNavItemTapped(int index) {
    setState(() => _currentIndex = index);
    switch (index) {
      case 0:
        Get.off(() => const MainMenuScreen());
        break;
      case 1:
        break;
      case 2:
        Get.off(() => const TransactionHistoryScreen());
        break;
      case 3:
        Get.off(() => const ProfileScreen());
        break;
    }
  }

  void _saveItem() {
    if (_nameController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _quantityController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all required fields')),
      );
      return;
    }

    final newItem = {
      'id': DateTime.now().millisecondsSinceEpoch,
      'name': _nameController.text.trim(),
      'price': _priceController.text.trim(),
      'description': _descriptionController.text.trim(),
      'category': _categoryController.text.trim(),
      'quantity': _quantityController.text.trim(),
      'dateAdded': _dateAddedController.text,
      'expirationDate': _expirationDateController.text,
      'image': _imagePath, // renamed to match detail screen
    };

    Get.back(result: newItem);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Item',
            style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF8B1E1E),
        centerTitle: true,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: const Color(0xFF8B1E1E),
        unselectedItemColor: Colors.grey,
        onTap: _onNavItemTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Inventory'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: 'Records'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildImageSection(),
            const SizedBox(height: 20),
            _buildTextField(_nameController, 'Product Name'),
            const SizedBox(height: 10),
            _buildTextField(_priceController, 'Product Price', TextInputType.number),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImage,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black87,
                side: const BorderSide(color: Colors.black26),
              ),
              child: const Text('Import Photo'),
            ),
            const SizedBox(height: 25),
            _buildTextField(_descriptionController, 'Item Descriptions', TextInputType.multiline),
            const SizedBox(height: 25),
            Row(
              children: [
                Expanded(child: _buildCategoryDropdown()),
                const SizedBox(width: 16),
                Expanded(child: _buildTextField(_quantityController, 'Quantity', TextInputType.number)),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildDateField(_dateAddedController, 'Date Added')),
                const SizedBox(width: 16),
                Expanded(child: _buildDateField(_expirationDateController, 'Expiration Date')),
              ],
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _saveItem,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8B1E1E),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 48),
              ),
              child: const Text('Add Item', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        color: Colors.white,
      ),
      child: _imagePath == null
          ? const Center(child: Text("Product Photo", style: TextStyle(color: Colors.black54)))
          : Image.file(File(_imagePath!), fit: BoxFit.cover),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      [TextInputType keyboardType = TextInputType.text, int maxLines = 1]) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return DropdownButtonFormField<String>(
      value: _categoryController.text.isEmpty ? null : _categoryController.text,
      items: ['Food', 'Drinks', 'Hygiene', 'School Supplies', 'Clothing']
          .map((category) => DropdownMenuItem(value: category, child: Text(category)))
          .toList(),
      onChanged: (value) => setState(() => _categoryController.text = value!),
      decoration: const InputDecoration(
        labelText: 'Category',
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
    );
  }

  Widget _buildDateField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      readOnly: true,
      onTap: () => _selectDate(controller),
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: const OutlineInputBorder(),
        suffixIcon: const Icon(Icons.calendar_today, size: 20),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
    );
  }
}
