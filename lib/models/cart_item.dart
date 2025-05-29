import 'package:objectbox/objectbox.dart';
import 'item.dart';

@Entity()
@Sync()
class CartItem {
  @Id()
  int id;

  int userId;
  final item = ToOne<Item>(); // Proper ObjectBox relation
  int quantity;
  String? imagePath;

  CartItem({
    this.id = 0,
    required this.userId,
    required this.quantity,
    this.imagePath,
  });
}

