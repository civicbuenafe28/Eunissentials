import 'package:flutter/material.dart';
import 'e-wallet_compute.screen.dart';

void main() => runApp(ToEWalletApp());

class ToEWalletApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ToEWalletScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ToEWalletScreen extends StatefulWidget {
  @override
  _ToEWalletScreenState createState() => _ToEWalletScreenState();
}

class _ToEWalletScreenState extends State<ToEWalletScreen> {
  Map<String, List<Map<String, String>>> savedRecipients = {
    'A': [{'username': 'Axel Doe', 'contact': '+1234567890'}],
    'B': [{'username': 'Blake Smith', 'contact': '+0987654321'}],
    'C': [{'username': 'Chris Evans', 'contact': '+1122334455'}],
    'D': [{'username': 'Diana Prince', 'contact': '+5566778899'}],
  };

  bool isEditing = false;

  void removeRecipient(String key, int index) {
    setState(() {
      savedRecipients[key]!.removeAt(index);
      if (savedRecipients[key]!.isEmpty) {
        savedRecipients.remove(key);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFF8B1E1E),
        title: Text(
          'To E-Wallet',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => SendMoneyScreen()),
                );
              },
              child: Container(
                margin: EdgeInsets.all(16),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.account_balance_wallet_outlined, color: Colors.red[900]),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Transfer to A New E-Wallet',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios, size: 16),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Saved Recipients',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isEditing = !isEditing;
                      });
                    },
                    child: Text(
                      isEditing ? 'Done' : 'Edit',
                      style: TextStyle(color: Colors.red[900], fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: savedRecipients.keys.length,
                itemBuilder: (context, index) {
                  String key = savedRecipients.keys.elementAt(index);
                  List<Map<String, String>> users = savedRecipients[key]!;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Text(
                          key,
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      ...users.asMap().entries.map((entry) {
                        int userIndex = entry.key;
                        Map<String, String> user = entry.value;

                        return GestureDetector(
                          onTap: () {
                            if (!isEditing) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => SendMoneyScreen(
                                    name: user['username'],
                                    contact: user['contact'],
                                  ),
                                ),
                              );
                            }
                          },
                          child: Stack(
                            children: [
                              RecipientCard(
                                username: user['username']!,
                                contact: user['contact']!,
                              ),
                              if (isEditing)
                                Positioned(
                                  right: 16,
                                  top: 12,
                                  child: GestureDetector(
                                    onTap: () => removeRecipient(key, userIndex),
                                    child: Icon(Icons.close, color: Colors.red),
                                  ),
                                )
                            ],
                          ),
                        );
                      })
                    ],
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class RecipientCard extends StatelessWidget {
  final String username;
  final String contact;

  const RecipientCard({
    Key? key,
    required this.username,
    required this.contact,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.grey[300],
            child: Icon(Icons.person, color: Colors.white),
          ),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(username, style: TextStyle(fontWeight: FontWeight.bold)),
              Text(contact, style: TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }
}

class SendMoneyScreen extends StatefulWidget {
  final String? name;
  final String? contact;

  SendMoneyScreen({this.name, this.contact});

  @override
  _SendMoneyScreenState createState() => _SendMoneyScreenState();
}

class _SendMoneyScreenState extends State<SendMoneyScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String? _selectedWallet;

  final List<String> _walletOptions = ['GCash', 'PayMaya', 'Coins.ph'];

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.name ?? '';
    _phoneController.text = widget.contact ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFF8B1E1E),
        title: Text(
          'Send Money to E-Wallet',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: BackButton(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            buildInputCard(
              label: 'Full Name',
              child: TextField(
                controller: _nameController,
                decoration: InputDecoration(hintText: 'Name', border: InputBorder.none),
              ),
            ),
            SizedBox(height: 20),
            buildInputCard(
              label: 'E-Wallet',
              child: DropdownButtonFormField<String>(
                value: _selectedWallet,
                items: _walletOptions
                    .map((wallet) => DropdownMenuItem(value: wallet, child: Text(wallet)))
                    .toList(),
                onChanged: (value) => setState(() => _selectedWallet = value),
                decoration: InputDecoration.collapsed(hintText: 'Select E-Wallet'),
              ),
            ),
            SizedBox(height: 20),
            buildInputCard(
              label: 'Phone No.',
              child: TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: 'Please enter a full phone number',
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF8B1E1E),
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
              onPressed: () {
                String name = _nameController.text.trim();
                String contact = _phoneController.text.trim();

                if (name.isEmpty || contact.isEmpty || _selectedWallet == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please fill all the fields in before confirming.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EWalletComputeScreen(
                      username: name,
                      contact: contact,
                      wallet: _selectedWallet!,
                    ),
                  ),
                );
              },
              child: Text('Confirm', style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildInputCard({required String label, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF8B1E1E),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
            child: child,
          ),
        ],
      ),
    );
  }
}
