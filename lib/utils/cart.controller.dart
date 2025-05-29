import 'package:get/get.dart';

class CartItemController {
  final String name;
  final RxInt quantity;
  final double price;
  final RxBool isSelected;
  final String? imageUrl;

  CartItemController({
    required this.name,
    int quantity = 1,
    this.price = 0.0,
    bool selected = false,
    this.imageUrl,
  })  : quantity = RxInt(quantity),
        isSelected = RxBool(selected);
}

class CartController extends GetxController {
  var isEditing = false.obs;
  var items = <CartItemController>[].obs;

  // Method to add an item to the cart with an optional image URL
  void addItem(String name, int quantity, {double price = 0.0, String? imageUrl}) {
    final index = items.indexWhere((item) => item.name == name);
    if (index != -1) {
      // If the item already exists, update its quantity
      items[index].quantity.value += quantity;
    } else {
      // Add a new CartItem
      items.add(CartItemController(
        name: name,
        quantity: quantity,
        price: price,
        imageUrl: imageUrl,
      ));
    }
  }

  // Check if there are selected items in the cart
  bool get hasSelectedItems =>
      items.any((item) => item.isSelected.value);

  // Toggle the edit mode for selecting/deselecting items
  void toggleEditMode() => isEditing.value = !isEditing.value;

  // Delete selected items from the cart
  void deleteSelectedItems() {
    items.removeWhere((item) => item.isSelected.value);
  }

  // Calculate the total price of all items in the cart
  double get totalPrice {
    return items.fold(0.0, (sum, item) => sum + item.price * item.quantity.value);
  }

  // Increase the quantity of a specific cart item
  void increaseQuantity(CartItemController item) {
    item.quantity.value++;
  }

  // Decrease the quantity of a specific cart item
  void decreaseQuantity(CartItemController item) {
    if (item.quantity.value > 1) {
      item.quantity.value--;
    }
  }

  // Select or deselect all items in the cart during editing mode
  void selectAllItems(bool selected) {
    for (var item in items) {
      item.isSelected.value = selected;
    }
  }
}
