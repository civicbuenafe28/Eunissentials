import 'package:objectbox/objectbox.dart';

@Entity()
@Sync()
class ChatMessage {
  @Id()
  int id;

  int senderId;
  int receiverId;
  String message;
  DateTime timestamp;
  bool isRead;

  ChatMessage({
    this.id = 0,
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.timestamp,
    this.isRead = false,
  });
}
