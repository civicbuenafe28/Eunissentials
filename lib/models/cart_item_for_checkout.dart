import 'package:eunissentials/models/item.dart';

class CartItemForCheckout {
  final Item item;
  final int quantity;

  CartItemForCheckout({required this.item, required this.quantity});
}
