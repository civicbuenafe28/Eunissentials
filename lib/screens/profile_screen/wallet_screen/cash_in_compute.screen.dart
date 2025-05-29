import 'package:flutter/material.dart';
import 'package:eunissentials/services/wallet.service.dart';

// CashInScreen widget
class CashInScreen extends StatefulWidget {
  final String paymentMethod;
  final String accountNumber;

  const CashInScreen({
    super.key,
    required this.paymentMethod,
    required this.accountNumber,
  });

  @override
  State<CashInScreen> createState() => _CashInScreenState();
}

class _CashInScreenState extends State<CashInScreen> {
  final walletService = WalletService();
  String _input = "";

  void _onKeyTap(String value) {
    setState(() {
      if (value == "x") {
        if (_input.isNotEmpty) {
          _input = _input.substring(0, _input.length - 1);
        }
      } else {
        if (_input.length < 8) {
          _input += value;
        }
      }
    });
  }

  String get _formattedAmount {
    if (_input.isEmpty) return "0.00";
    final padded = _input.padLeft(3, '0');
    final pesos = padded.substring(0, padded.length - 2);
    final centavos = padded.substring(padded.length - 2);
    final formattedPesos = _formatWithCommas(pesos);
    return "$formattedPesos.$centavos";
  }

  String _formatWithCommas(String number) {
    String result = '';
    int count = 0;

    for (int i = number.length - 1; i >= 0; i--) {
      count++;
      result = number[i] + result;
      if (count % 3 == 0 && i > 0) {
        result = ',$result';
      }
    }

    return result;
  }

  void _showPurposeDialog() {
    final TextEditingController _purposeController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Purpose',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _purposeController,
                  decoration: InputDecoration(
                    hintText: 'Enter purpose for cash in',
                    hintStyle: const TextStyle(color: Colors.black38),
                    filled: true,
                    fillColor: Colors.grey[200],
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        final purpose = _purposeController.text.trim();
                        if (purpose.isNotEmpty) {
                          Navigator.pop(context);
                          _showConfirmationDialog(purpose);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Please enter a purpose.")),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[700],
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'OK',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8B1E1E),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'CANCEL',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showConfirmationDialog(String purpose) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Cash In"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Please review the transaction details:"),
            const SizedBox(height: 16),
            _detailRow("Amount", "₱$_formattedAmount"),
            _detailRow("Payment Method", widget.paymentMethod),
            _detailRow("Account Number", widget.accountNumber),
            _detailRow("Purpose", purpose),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
              double amount = double.parse(_formattedAmount.replaceAll(',', ''));

              walletService.add(amount);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Cash In of ₱$_formattedAmount successful\nPurpose: $purpose"),
                  backgroundColor: Colors.green,
                ),
              );

              Future.delayed(const Duration(seconds: 1), () {
                Navigator.pop(context, amount); // Return amount to previous screen
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF800000),
            ),
            child: const Text(
              "Confirm",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.grey),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildNumpadButton(String label) {
    return GestureDetector(
      onTap: () => _onKeyTap(label),
      child: Container(
        margin: const EdgeInsets.all(10),
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey.shade700,
        ),
        child: Center(
          child: label == 'x'
              ? const Icon(Icons.backspace_outlined, color: Colors.white, size: 28)
              : Text(label, style: const TextStyle(fontSize: 24, color: Colors.white)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF800000),
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: const Text(
          'Cash In',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Payment Method Info
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade200,
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.grey.shade300,
                    radius: 30,
                    child: Icon(Icons.account_balance_wallet, color: Colors.grey.shade700, size: 30),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.paymentMethod, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text(widget.accountNumber, style: TextStyle(color: Colors.grey)),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Amount Display
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const Text('Enter an amount:', style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '₱$_formattedAmount',
                      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Numpad
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 40),
                children: [
                  ...List.generate(9, (index) => _buildNumpadButton('${index + 1}')),
                  Container(),
                  _buildNumpadButton('0'),
                  _buildNumpadButton('x'),
                ],
              ),
            ),
            // Cash In Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    if (_input.isEmpty || _formattedAmount == "0.00") {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Please enter a valid amount")),
                      );
                    } else {
                      _showPurposeDialog();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF800000),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Cash In',
                    style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
