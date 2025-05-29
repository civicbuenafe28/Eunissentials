import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentMethodScreen extends StatefulWidget {
  const PaymentMethodScreen({super.key});

  @override
  _PaymentMethodScreenState createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  String _selectedPaymentMethod = 'Cash On Delivery';
  String? _selectedEwallet;
  String? _selectedOnlineBanking;

  void _handlePaymentMethodChanged(String? method) {
    if (method != null) {
      setState(() {
        _selectedPaymentMethod = method;
        _selectedEwallet = null;
        _selectedOnlineBanking = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color maroon = Color(0xFF800000);
    const Color lightGrey = Color(0xFFF8F8F8);
    const Color white = Colors.white;

    return Scaffold(
      backgroundColor: lightGrey,
      appBar: AppBar(
        backgroundColor: maroon,
        elevation: 0,
        title: const Text(
          'Payment Method',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: white,
            fontSize: 20,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: white),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Text(
              'Select Option',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 12),
            // Radio buttons
            _buildPaymentOption(
              title: 'Cash On Delivery',
              value: 'Cash On Delivery',
              onChanged: _handlePaymentMethodChanged,
              groupValue: _selectedPaymentMethod,
            ),
            _buildPaymentOption(
              title: 'EuniWallet',
              value: 'EuniWallet',
              onChanged: _handlePaymentMethodChanged,
              groupValue: _selectedPaymentMethod,
            ),
            // Dropdowns
            _buildDropdownOption(
              title: 'Payment Center / E-Wallet',
              items: ['GCash', 'Maya'],
              selectedValue: _selectedEwallet,
              onChanged: (value) {
                setState(() {
                  _selectedPaymentMethod = 'Payment Center / E-Wallet';
                  _selectedEwallet = value;
                  _selectedOnlineBanking = null;
                });
              },
              isSelected: _selectedPaymentMethod == 'Payment Center / E-Wallet',
            ),
            _buildDropdownOption(
              title: 'Online Banking',
              items: [
                'UnionBank Internet Banking',
                'RCBC Online Banking',
                'BPI Online'
              ],
              selectedValue: _selectedOnlineBanking,
              onChanged: (value) {
                setState(() {
                  _selectedPaymentMethod = 'Online Banking';
                  _selectedOnlineBanking = value;
                  _selectedEwallet = null;
                });
              },
              isSelected: _selectedPaymentMethod == 'Online Banking',
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Get.back(); // Confirm action
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: maroon,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Confirm',
                style: TextStyle(
                  color: white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Radio button option (for Cash and EuniWallet)
  Widget _buildPaymentOption({
    required String title,
    required String value,
    required void Function(String?)? onChanged,
    required String groupValue,
  }) {
    const Color white = Colors.white;
    return Container(
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      margin: const EdgeInsets.only(bottom: 8),
      child: RadioListTile<String>(
        title: Text(title, style: const TextStyle(fontSize: 14)),
        value: value,
        groupValue: groupValue,
        onChanged: onChanged,
        activeColor: const Color(0xFF800000),
        dense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      ),
    );
  }

  // Dropdown option (for E-Wallet and Online Banking)
  Widget _buildDropdownOption({
    required String title,
    required List<String> items,
    required String? selectedValue,
    required void Function(String?) onChanged,
    required bool isSelected,
  }) {
    const Color white = Colors.white;

    return Container(
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isSelected ? const Color(0xFF800000) : Colors.grey.shade300,
          width: isSelected ? 2 : 1,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      margin: const EdgeInsets.only(bottom: 8),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          hint: Text(title),
          value: selectedValue,
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: onChanged,
          icon: const Icon(Icons.arrow_drop_down),
        ),
      ),
    );
  }
}
