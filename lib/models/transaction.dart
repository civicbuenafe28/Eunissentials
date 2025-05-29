import 'package:objectbox/objectbox.dart';

@Entity()
@Sync()
class Transaction {
  @Id()
  int id;

  int userId;
  int itemId;
  double totalAmount;
  String paymentMethod;
  String status;
  DateTime timestamp;

  Transaction({
    this.id = 0,
    required this.userId,
    required this.itemId,
    required this.totalAmount,
    required this.paymentMethod,
    required this.status,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}
