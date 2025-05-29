import 'package:objectbox/objectbox.dart';

@Entity()
@Sync()
class AppNotification {
  @Id()
  int id;

  int userId;
  String content;
  bool isRead;
  DateTime timestamp;

  AppNotification({
    this.id = 0,
    required this.userId,
    required this.content,
    this.isRead = false,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}







