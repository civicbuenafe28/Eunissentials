import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  // Save user data
  static Future<void> saveUserData({
    required String userName,
    required String membershipType,
    required String birthday,
    required String email,
    required String contactNumber,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    // Print for debugging
    print("SAVING DATA TO PREFS: Name=$userName, Type=$membershipType");

    await prefs.setString('userName', userName);
    await prefs.setString('membershipType', membershipType);
    await prefs.setString('birthday', birthday);
    await prefs.setString('userEmail', email);
    await prefs.setString('contactNumber', contactNumber);

    // Initialize wallet balance to 0.0 for new users if it doesn't exist yet
    if (!prefs.containsKey('walletBalance')) {
      await prefs.setDouble('walletBalance', 0.0);
      print("INITIALIZED NEW USER BALANCE: 0.0");
    }

    // Verify data was saved correctly
    final savedName = prefs.getString('userName');
    final savedType = prefs.getString('membershipType');
    final savedBalance = prefs.getDouble('walletBalance');
    print("VERIFICATION - SAVED VALUES: Name=$savedName, Type=$savedType, Balance=$savedBalance");
  }

  // Retrieve user data
  static Future<Map<String, dynamic>> getUserData() async {
    final prefs = await SharedPreferences.getInstance();

    // Get all values
    String userName = prefs.getString('userName') ?? '[Name Displayed Here]';
    String membershipType = prefs.getString('membershipType') ?? '[Membership Type Displayed Here]';
    String birthday = prefs.getString('birthday') ?? '[Birthday Display Here]';
    String email = prefs.getString('userEmail') ?? '[Email Display Here]';
    String contactNumber = prefs.getString('contactNumber') ?? '[Contact No. Display Here]';
    double walletBalance = prefs.getDouble('walletBalance') ?? 0.0;

    // Print for debugging
    print("RETRIEVED FROM PREFS: Name=$userName, Type=$membershipType, Email=$email, Balance=$walletBalance");

    return {
      'userName': userName,
      'membershipType': membershipType,
      'birthday': birthday,
      'userEmail': email,
      'contactNumber': contactNumber,
      'walletBalance': walletBalance,
    };
  }

  // Save/update wallet balance
  static Future<void> saveWalletBalance(double amount) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('walletBalance', amount);
    print("WALLET BALANCE UPDATED: $amount");
  }

  // Cash in (add money to wallet)
  static Future<double> cashIn(double amount) async {
    final prefs = await SharedPreferences.getInstance();
    double currentBalance = prefs.getDouble('walletBalance') ?? 0.0;
    double newBalance = currentBalance + amount;

    await prefs.setDouble('walletBalance', newBalance);
    print("CASH IN: $amount, NEW BALANCE: $newBalance");

    return newBalance;
  }

  // Get wallet balance
  static Future<double> getWalletBalance() async {
    final prefs = await SharedPreferences.getInstance();
    double balance = prefs.getDouble('walletBalance') ?? 0.0;
    print("CURRENT WALLET BALANCE: $balance");
    return balance;
  }

  // Clear user profile data (useful for logout)
  // This will NOT clear the wallet balance - it stays preserved
  static Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userName');
    await prefs.remove('membershipType');
    await prefs.remove('birthday');
    await prefs.remove('userEmail');
    await prefs.remove('contactNumber');

    // Wallet balance is intentionally preserved even after logout
    print("USER LOGGED OUT: Wallet balance preserved: ${await getWalletBalance()}");
  }

  // Only use this method if you need to reset everything including wallet balance
  static Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userName');
    await prefs.remove('membershipType');
    await prefs.remove('birthday');
    await prefs.remove('userEmail');
    await prefs.remove('contactNumber');
    await prefs.remove('walletBalance');
    await prefs.remove('transactionList'); // clear stored transactions too
    print("ALL DATA CLEARED INCLUDING WALLET BALANCE AND TRANSACTIONS");
  }

  // ————————————————
  // Transaction-list persistence
  // ————————————————

  /// Save the entire transaction list as JSON
  static Future<void> saveTransactionList(List<Map<String, dynamic>> txList) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(txList);
    await prefs.setString('transactionList', encoded);
    print("SAVED TRANSACTIONS: $encoded");
  }

  /// Retrieve the saved transaction list (or empty list)
  static Future<List<Map<String, dynamic>>> getTransactionList() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = prefs.getString('transactionList');
    if (encoded == null) return [];
    final decoded = jsonDecode(encoded) as List<dynamic>;
    return decoded.map((e) => Map<String, dynamic>.from(e)).toList();
  }
}
