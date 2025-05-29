import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eunissentials/screens/profile_screen/wallet_screen/contacts_screen/send_money_contacts.screen.dart';
import 'package:eunissentials/screens/profile_screen/wallet_screen/bank_screen/menu_bank_transfer.screen.dart';
import 'package:eunissentials/screens/profile_screen/wallet_screen/ewallet_screen/e-wallet_menu.screen.dart'; // ✅ Import added

class MenuSendMoneyScreen extends StatefulWidget {
  const MenuSendMoneyScreen({super.key});

  @override
  _MenuSendMoneyScreenState createState() => _MenuSendMoneyScreenState();
}

class _MenuSendMoneyScreenState extends State<MenuSendMoneyScreen> {
  String selectedOption = 'Contact';
  String selectedTab = 'Recent';

  final List<String> sendOptions = [
    'Contact',
    'Bank Account',
    'Other E-wallets',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFF8B1E1E),
        leading: const BackButton(color: Colors.white),
        title: const Text(
          "Send Money",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Red rounded container
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF8B1E1E),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Select your option",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _OptionButton(
                            label: 'Contact',
                            icon: Icons.contacts,
                            isSelected: selectedOption == 'Contact',
                            onTap: () {
                              setState(() {
                                selectedOption = 'Contact';
                              });
                              Get.to(() => SendMoneyContactsScreen());
                            },
                          ),
                          _OptionButton(
                            label: 'Bank Transfer',
                            icon: Icons.account_balance,
                            isSelected: selectedOption == 'Bank Transfer',
                            onTap: () {
                              setState(() {
                                selectedOption = 'Bank Transfer';
                              });
                              Get.to(() => const BankTransferMain());
                            },
                          ),
                          _OptionButton(
                            label: 'Other E-wallets',
                            icon: Icons.account_balance_wallet,
                            isSelected: selectedOption == 'Other E-wallets',
                            onTap: () {
                              setState(() {
                                selectedOption = 'Other E-wallets';
                              });
                              Get.to(() => ToEWalletScreen());
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              // Tab buttons (Recent and Favorites)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _TabButton(
                    label: "Recent",
                    isSelected: selectedTab == "Recent",
                    onTap: () {
                      setState(() {
                        selectedTab = "Recent";
                      });
                    },
                  ),
                  _TabButton(
                    label: "Favorites",
                    isSelected: selectedTab == "Favorites",
                    onTap: () {
                      setState(() {
                        selectedTab = "Favorites";
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // No Recent Transfer Found
              Expanded(
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.search,
                          size: 50,
                          color: Colors.black,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          selectedTab == "Recent"
                              ? "No Recent Transfer Found"
                              : "No Favorites Found",
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Let’s make a Transfer!",
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 14,
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
      ),
    );
  }
}

class _OptionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _OptionButton({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(
                color: Colors.black,
                width: 2,
              ),
            ),
            child: Icon(
              icon,
              size: 32,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF8B1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFF8B1E1E),
            width: 2,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF8B1E1E),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
