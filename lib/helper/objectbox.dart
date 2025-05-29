import 'package:objectbox/objectbox.dart';

// Import all model classes
import 'package:eunissentials/models/cart_item.dart';
import 'package:eunissentials/models/chat_message.dart';
import 'package:eunissentials/models/item.dart';
import 'package:eunissentials/models/notification.dart';
import 'package:eunissentials/models/transaction.dart';
import 'package:eunissentials/models/user.dart';
import 'package:eunissentials/models/wallet_transaction.dart';

import 'package:eunissentials/objectbox.g.dart'; // Generated file

class ObjectBox {
  late final Store _store;

  // Boxes for all models
  late final Box<User> _userBox;
  late final Box<Item> _itemBox;
  late final Box<CartItem> _cartItemBox;
  late final Box<ChatMessage> _chatMessageBox;
  late final Box<AppNotification> _notificationBox;
  late final Box<Transaction> _transactionBox;
  late final Box<WalletTransaction> _walletTransactionBox;

  ObjectBox._init(this._store) {
    _userBox = Box<User>(_store);
    _itemBox = Box<Item>(_store);
    _cartItemBox = Box<CartItem>(_store);
    _chatMessageBox = Box<ChatMessage>(_store);
    _notificationBox = Box<AppNotification>(_store);
    _transactionBox = Box<Transaction>(_store);
    _walletTransactionBox = Box<WalletTransaction>(_store);
  }

  static Future<ObjectBox> init() async {
    final store = await openStore();

    if (Sync.isAvailable()) {
      final syncClient = Sync.client(
          store,
          'ws://0.0.0:9999',
          SyncCredentials.none(),
      ).buildAndStart();
    }
    return ObjectBox._init(store);
  }

  // =====================
  // USER METHODS
  // =====================
  User? getUser(int id) => _userBox.get(id);
  Stream<List<User>> getUsers() => _userBox.query().watch(triggerImmediately: true).map((q) => q.find());
  int insertUser(User user) => _userBox.put(user);
  bool deleteUser(int id) => _userBox.remove(id);

  // =====================
  // ITEM METHODS
  // =====================
  Item? getItem(int id) => _itemBox.get(id);
  Stream<List<Item>> getItems() => _itemBox.query().watch(triggerImmediately: true).map((q) => q.find());
  int insertItem(Item item) => _itemBox.put(item);
  bool deleteItem(int id) => _itemBox.remove(id);

  // =====================
  // CART ITEM METHODS
  // =====================
  CartItem? getCartItem(int id) => _cartItemBox.get(id);
  Stream<List<CartItem>> getCartItems() => _cartItemBox.query().watch(triggerImmediately: true).map((q) => q.find());
  int insertCartItem(CartItem item) => _cartItemBox.put(item);
  bool deleteCartItem(int id) => _cartItemBox.remove(id);

  // =====================
  // CHAT MESSAGE METHODS
  // =====================
  ChatMessage? getChatMessage(int id) => _chatMessageBox.get(id);
  Stream<List<ChatMessage>> getChatMessages() => _chatMessageBox.query().watch(triggerImmediately: true).map((q) => q.find());
  int insertChatMessage(ChatMessage msg) => _chatMessageBox.put(msg);
  bool deleteChatMessage(int id) => _chatMessageBox.remove(id);

  // =====================
  // NOTIFICATION METHODS
  // =====================
  AppNotification? getNotification(int id) => _notificationBox.get(id);
  Stream<List<AppNotification>> getNotifications() => _notificationBox.query().watch(triggerImmediately: true).map((q) => q.find());
  int insertNotification(AppNotification notif) => _notificationBox.put(notif);
  bool deleteNotification(int id) => _notificationBox.remove(id);

  // =====================
  // TRANSACTION METHODS
  // =====================
  Transaction? getTransaction(int id) => _transactionBox.get(id);
  Stream<List<Transaction>> getTransactions() => _transactionBox.query().watch(triggerImmediately: true).map((q) => q.find());
  int insertTransaction(Transaction tx) => _transactionBox.put(tx);
  bool deleteTransaction(int id) => _transactionBox.remove(id);

  // =====================
  // WALLET TRANSACTION METHODS
  // =====================
  WalletTransaction? getWalletTransaction(int id) => _walletTransactionBox.get(id);
  Stream<List<WalletTransaction>> getWalletTransactions() => _walletTransactionBox.query().watch(triggerImmediately: true).map((q) => q.find());
  int insertWalletTransaction(WalletTransaction wt) => _walletTransactionBox.put(wt);
  bool deleteWalletTransaction(int id) => _walletTransactionBox.remove(id);
}

extension on SyncClient {
  buildAndStart() {}
}
