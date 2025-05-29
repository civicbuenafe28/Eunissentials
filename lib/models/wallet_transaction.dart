import 'package:objectbox/objectbox.dart';

@Entity()
@Sync()
class WalletTransaction {
  @Id()
  int id;

  int userId;
  double amount;
  String method; // e.g., GCash, PayMaya, BDO
  String type;   // "cash_in", "cash_out"
  DateTime timestamp;

  WalletTransaction({
    this.id = 0,
    required this.userId,
    required this.amount,
    required this.method,
    required this.type,
    required this.timestamp,
  });
}
