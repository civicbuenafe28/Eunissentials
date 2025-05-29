class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final List<Map<String, dynamic>> _notifications = [];

  List<Map<String, dynamic>> getNotifications({bool unreadOnly = false}) {
    if (unreadOnly) {
      return _notifications.where((n) => n['unread'] == true).toList();
    }
    return _notifications;
  }

  void addNotification(String user, String message) {
    _notifications.insert(0, {
      'user': user,
      'message': message,
      'unread': true,
      'timestamp': DateTime.now(),
    });
  }

  void markAllAsRead() {
    for (var n in _notifications) {
      n['unread'] = false;
    }
  }
}
