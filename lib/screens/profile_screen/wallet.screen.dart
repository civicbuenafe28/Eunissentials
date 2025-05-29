import 'package:eunissentials/screens/profile_screen/wallet_screen/cash_in_menu.screen.dart';
import 'package:eunissentials/screens/profile_screen/wallet_screen/send_money_selection.screen.dart';
import 'package:eunissentials/services/wallet.service.dart';
import 'package:flutter/material.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  late WalletService _walletService;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _walletService = WalletService();
    // Load persisted balance & transactions before showing UI
    _walletService.init().then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  Future<void> _navigateToCashIn(BuildContext context) async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(builder: (context) => const CashInMenuScreen()),
    );

    if (result != null && result['amount'] > 0) {
      await _walletService.add(
        result['amount'],
        bankSource: result['bankSource'],
      );
      setState(() {}); // Refresh UI
    }
  }

  Future<void> _navigateToSendMoney(BuildContext context) async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(builder: (context) => SendMoneySelection()),
    );

    if (result != null && result['amount'] > 0) {
      await _walletService.subtract(
        result['amount'],
        recipient: result['recipient'],
      );
      setState(() {}); // Refresh UI
    }
  }

  void _refreshBalance() => setState(() {});

  String get formattedBalance {
    double balance = _walletService.getBalance();
    final parts = balance.toStringAsFixed(2).split('.');
    final integer = parts[0];
    final decimal = parts.length > 1 ? '.${parts[1]}' : '.00';

    String formatted = '';
    int count = 0;
    for (int i = integer.length - 1; i >= 0; i--) {
      formatted = integer[i] + formatted;
      count++;
      if (count % 3 == 0 && i != 0) formatted = ',$formatted';
    }
    return '₱$formatted$decimal';
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final transactions = _walletService.getTransactions();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'EUni Wallet',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF8B1E1E),
        elevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshBalance,
            color: Colors.white,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Balance Card
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              color: const Color(0xFF8B1E1E),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 24,
                  horizontal: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Current Balance',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 14),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        formattedBalance,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _ActionButton(
                          icon: Icons.add,
                          label: 'Cash In',
                          onTap: () => _navigateToCashIn(context),
                        ),
                        _ActionButton(
                          icon: Icons.send,
                          label: 'Send',
                          onTap: () => _navigateToSendMoney(context),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Recent Transactions
            _buildTransactionsSection(transactions),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionsSection(List<Map<String, dynamic>> txs) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TransactionsHeader(onSeeAll: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AllTransactionsScreen()),
            );
            _refreshBalance();
          }),
          const SizedBox(height: 16),
          if (txs.isEmpty)
            const _EmptyTransactions()
          else
            Column(
              children:
              txs.take(5).map((tx) => TransactionTile(tx)).toList(),
            ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Column(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: Colors.white,
          child: Icon(icon, color: Colors.black, size: 28),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(color: Colors.white)),
      ],
    ),
  );
}

class _TransactionsHeader extends StatelessWidget {
  final Future<void> Function() onSeeAll;

  const _TransactionsHeader({required this.onSeeAll});

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      const Text(
        'Recent Transactions',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
      GestureDetector(
        onTap: onSeeAll,
        child: const Text(
          'See All',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF8B1E1E),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ],
  );
}

class _EmptyTransactions extends StatelessWidget {
  const _EmptyTransactions();

  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      children: const [
        Icon(Icons.receipt_long, size: 48, color: Colors.black26),
        SizedBox(height: 8),
        Text(
          'No recent transactions yet',
          style: TextStyle(color: Colors.black54, fontSize: 14),
        ),
      ],
    ),
  );
}

// Transaction Tile Widget
class TransactionTile extends StatelessWidget {
  final Map<String, dynamic> tx;

  const TransactionTile(this.tx, {super.key});

  @override
  Widget build(BuildContext context) {
    // Parse the ISO date string back into a DateTime
    final rawDate = tx['date'];
    final date = rawDate is String ? DateTime.parse(rawDate) : rawDate as DateTime;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: const Color(0xFFE0E0E0),
              child: Icon(
                tx['type'] == 'Cash In'
                    ? Icons.account_balance_wallet
                    : Icons.send,
                color: Colors.black,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(tx['type'], style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(tx['description'], style: const TextStyle(color: Colors.black54)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _formatDate(date),
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Text(
                  '${tx['isCredit'] ? '+' : '-'}₱${(tx['amount'] as double).toStringAsFixed(2)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: tx['isCredit'] ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to format date
  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${date.day.toString().padLeft(2, '0')} ${months[date.month - 1]} ${date.year}';
  }
}

// All Transaction History Screen
class AllTransactionsScreen extends StatefulWidget {
  const AllTransactionsScreen({super.key});

  @override
  State<AllTransactionsScreen> createState() => _AllTransactionsScreenState();
}

class _AllTransactionsScreenState extends State<AllTransactionsScreen> {
  late WalletService _walletService;

  @override
  void initState() {
    super.initState();
    _walletService = WalletService();
  }

  @override
  Widget build(BuildContext context) {
    final transactions = _walletService.getTransactions();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF8B1E1E),
        title: const Text(
          'All Transaction History',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: transactions.isEmpty
          ? const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.receipt_long, size: 64, color: Colors.black26),
            SizedBox(height: 12),
            Text(
              'No transactions found',
              style: TextStyle(color: Colors.black54, fontSize: 16),
            ),
          ],
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          final tx = transactions[index];
          return TransactionTile(tx);
        },
      ),
    );
  }
}
