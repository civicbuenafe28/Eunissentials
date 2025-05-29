import 'package:flutter/material.dart';
import 'package:eunissentials/screens/profile_screen/wallet_screen/bank_screen/menu_bank_transfer.screen.dart';
import 'contacts_screen/send_money_contacts.screen.dart';
import 'ewallet_screen/e-wallet_menu.screen.dart';

class SendMoneySelection extends StatelessWidget {
  const SendMoneySelection({super.key});

  @override
  Widget build(BuildContext context) {
    return const SendMoneyScreen();
  }
}

class SendMoneyScreen extends StatefulWidget {
  const SendMoneyScreen({super.key});

  @override
  State<SendMoneyScreen> createState() => _SendMoneyScreenState();
}

class _SendMoneyScreenState extends State<SendMoneyScreen> {
  String _selectedTab = 'Recent';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF8B1D1D),
        foregroundColor: Colors.white,
        title: const Text(
          'Send Money',
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF8B1E1E),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Select your option',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _OptionButton(
                          icon: Icons.account_box,
                          label: 'Contact',
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        SendMoneyContactsScreen()));
                          },
                        ),
                        _OptionButton(
                          icon: Icons.account_balance,
                          label: 'Bank Account',
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                    const BankTransferMain()));
                          },
                        ),
                        _OptionButton(
                          icon: Icons.account_balance_wallet, // Changed to account_balance_wallet
                          label: 'Other E-wallets',
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ToEWalletScreen()));
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _TabButton(
                  label: 'Recent',
                  isSelected: _selectedTab == 'Recent',
                  onPressed: () {
                    setState(() {
                      _selectedTab = 'Recent';
                      // Implement logic to show recent transfers
                    });
                  },
                ),
                _TabButton(
                  label: 'Favorites',
                  isSelected: _selectedTab == 'Favorites',
                  onPressed: () {
                    setState(() {
                      _selectedTab = 'Favorites';
                      // Implement logic to show favorite transfers
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.receipt_long, size: 60, color: Colors.grey[400]),
                  const SizedBox(height: 10),
                  Text(
                    _selectedTab == 'Recent'
                        ? 'No Recent Transfer Found'
                        : 'No Favorites Found',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const Text("Let's make a Transfer!",
                      style: TextStyle(color: Colors.blue)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _OptionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(30),
          child: CircleAvatar(
            radius: 30,
            backgroundColor: Colors.black,
            child: Icon(icon, color: Colors.white, size: 28),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _TabButton({
    required String label,
    required bool isSelected,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 36),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFB71C1C) : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFF8B1E1E)),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF8B1E1E),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}