// lib/services/wallet_service.dart

import 'dart:convert';
import 'package:eunissentials/utils/shared_prefs.dart';

class WalletService {
  // Singleton instance
  static final WalletService _instance = WalletService._internal();

  // Private constructor
  WalletService._internal();

  // Factory returns the same instance
  factory WalletService() => _instance;

  // In-memory balance and transaction log
  double _balance = 0.0;
  final List<Map<String, dynamic>> _transactions = [];

  /// Call once during app startup to load the persisted balance and transactions
  Future<void> init() async {
    // 1) Load balance
    _balance = await SharedPrefs.getWalletBalance();
    // 2) Load transactions from storage
    final loaded = await SharedPrefs.getTransactionList();
    // Convert stored date strings back to DateTime
    _transactions.clear();
    for (var tx in loaded) {
      final parsedTx = Map<String, dynamic>.from(tx);
      if (parsedTx['date'] is String) {
        parsedTx['date'] = DateTime.parse(parsedTx['date']);
      }
      _transactions.add(parsedTx);
    }

    print('WalletService initialized - Balance: \$_balance, Transactions: \${_transactions.length}');
  }

  /// Getter for the current wallet balance
  double getBalance() => _balance;

  /// Getter for transactions (newest first), with DateTime date
  List<Map<String, dynamic>> getTransactions() {
    // Return a reversed copy so newest are first
    return _transactions
        .map((tx) => Map<String, dynamic>.from(tx))
        .toList()
        .reversed
        .toList();
  }

  /// Add amount to the current balance and log transaction
  Future<void> add(double amount, {String? bankSource}) async {
    if (amount <= 0) return;

    _balance += amount;
    await SharedPrefs.saveWalletBalance(_balance);

    // Build description
    String desc;
    if (bankSource != null) {
      desc = 'Added ₱${amount.toStringAsFixed(2)} from $bankSource to your wallet';
    } else {
      desc = 'Added ₱${amount.toStringAsFixed(2)} to your wallet';
    }

    // Create transaction
    final tx = {
      'type': 'Cash In',
      'description': desc,
      'amount': amount,
      'isCredit': true,
      'date': DateTime.now(), // keep as DateTime in memory
      'bankSource': bankSource ?? 'Unknown',
    };
    _transactions.add(tx);

    // Persist list with date serialized
    final serializable = _transactions.map((t) {
      final copy = Map<String, dynamic>.from(t);
      copy['date'] = (copy['date'] as DateTime).toIso8601String();
      return copy;
    }).toList();
    await SharedPrefs.saveTransactionList(serializable);
  }

  /// Subtract amount and log transaction
  Future<void> subtract(double amount, {String? recipient}) async {
    if (amount <= 0 || amount > _balance) return;

    _balance -= amount;
    await SharedPrefs.saveWalletBalance(_balance);

    // Build description
    String desc;
    if (recipient != null) {
      desc = 'Sent ₱${amount.toStringAsFixed(2)} to $recipient';
    } else {
      desc = 'Payment of ₱${amount.toStringAsFixed(2)}';
    }

    // Create transaction
    final tx = {
      'type': 'Purchase',
      'description': desc,
      'amount': amount,
      'isCredit': false,
      'date': DateTime.now(),
      'recipient': recipient ?? 'Unknown',
    };
    _transactions.add(tx);

    // Persist list with date serialized
    final serializable = _transactions.map((t) {
      final copy = Map<String, dynamic>.from(t);
      copy['date'] = (copy['date'] as DateTime).toIso8601String();
      return copy;
    }).toList();
    await SharedPrefs.saveTransactionList(serializable);
  }

  /// Add a custom transaction
  Future<void> addTransaction({
    required String description,
    required double amount,
    required String type,
    required bool isCredit,
    String? recipient,
    String? bankSource,
  }) async {
    // Update balance
    if (isCredit) {
      _balance += amount;
    } else {
      _balance -= amount;
    }
    await SharedPrefs.saveWalletBalance(_balance);

    // Create transaction
    final tx = {
      'type': type,
      'description': description,
      'amount': amount,
      'isCredit': isCredit,
      'date': DateTime.now(),
      'recipient': recipient,
      'bankSource': bankSource,
    };
    _transactions.add(tx);

    // Persist list with date serialized
    final serializable = _transactions.map((t) {
      final copy = Map<String, dynamic>.from(t);
      copy['date'] = (copy['date'] as DateTime).toIso8601String();
      return copy;
    }).toList();
    await SharedPrefs.saveTransactionList(serializable);
  }

  /// Set the balance to a specific amount
  Future<void> set(double amount) async {
    _balance = amount;
    await SharedPrefs.saveWalletBalance(_balance);
    // Persist transactions as-is
    final serializable = _transactions.map((t) {
      final copy = Map<String, dynamic>.from(t);
      copy['date'] = (copy['date'] as DateTime).toIso8601String();
      return copy;
    }).toList();
    await SharedPrefs.saveTransactionList(serializable);
  }

  /// Reset the balance and clear transactions
  Future<void> reset() async {
    _balance = 0.0;
    _transactions.clear();
    await SharedPrefs.saveWalletBalance(_balance);
    await SharedPrefs.saveTransactionList([]);
  }
}
