import 'package:flutter/material.dart';
import 'cash_in_compute.screen.dart';

class CashInMenuScreen extends StatefulWidget {
  const CashInMenuScreen({Key? key}) : super(key: key);

  @override
  _CashInMenuScreenState createState() => _CashInMenuScreenState();
}

class _CashInMenuScreenState extends State<CashInMenuScreen> {
  final TextEditingController _accountNumberController = TextEditingController();
  String? _selectedPaymentMethod;
  final List<String> _paymentOptions = [
    'BDO',
    'BPI',
    'GCash',
    'PayMaya',
    'Metrobank',
    'Landbank',
    'UnionBank'
  ];

  @override
  void dispose() {
    _accountNumberController.dispose();
    super.dispose();
  }

  Future<void> _proceedToCashIn() async {
    if (_selectedPaymentMethod != null && _accountNumberController.text.isNotEmpty) {
      final result = await Navigator.push<double>(
        context,
        MaterialPageRoute(
          builder: (context) => CashInScreen(
            paymentMethod: _selectedPaymentMethod!,
            accountNumber: _accountNumberController.text,
          ),
        ),
      );

      if (result != null && result > 0) {
        print('CashInMenuScreen - Passing back: {amount: $result, bankSource: $_selectedPaymentMethod}'); // LOGGING
        Navigator.pop(context, {
          'amount': result,
          'bankSource': _selectedPaymentMethod, // Pass the selected payment method
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF8B1D1D),
        foregroundColor: Colors.white,
        title: const Text(
          'Cash In',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 80),
            // Payment Method
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF8B1D1D),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(16),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Cash in With:',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        hintText: '(BDO, GCash, Paymaya, etc)',
                        contentPadding: EdgeInsets.symmetric(horizontal: 12),
                        border: InputBorder.none,
                      ),
                      value: _selectedPaymentMethod,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedPaymentMethod = newValue;
                        });
                      },
                      items: _paymentOptions.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Account Number
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF8B1D1D),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(16),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Account Number:',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: TextField(
                      controller: _accountNumberController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'Enter account number',
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50),
            // Proceed Button
            ElevatedButton(
              onPressed: _proceedToCashIn,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8B1D1D),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                minimumSize: const Size(150, 48),
              ),
              child: const Text(
                'Proceed to Cash In',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}