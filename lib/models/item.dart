import 'package:objectbox/objectbox.dart';

@Entity()
@Sync()
class Item {
  @Id()
  int id;

  int sellerId; // Relation to User
  String title;
  String description;
  double price;
  String imageUrl;
  bool isAvailable;
  DateTime createdAt;

  Item({
    this.id = 0,
    required this.sellerId,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isAvailable = true,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}
