import 'package:get/get.dart';
import 'package:eunissentials/models/item.dart';

class CartItemForCheckout {
  final Item item;
  final int quantity;

  CartItemForCheckout({required this.item, required this.quantity});
}

class CheckoutController extends GetxController {
  var deliveryMethod = 'Standard'.obs;
  var paymentMethod = 'Cash on Delivery'.obs;
  var cartItems = <CartItemForCheckout>[].obs;

  double get totalPrice => cartItems.fold(
    0,
        (sum, item) => sum + item.item.price * item.quantity,
  );

  void updateDeliveryMethod(String method) {
    deliveryMethod.value = method;
  }

  void updatePaymentMethod(String method) {
    paymentMethod.value = method;
  }

  void setCartItems(List<CartItemForCheckout> items) {
    cartItems.assignAll(items);
  }

  void clearCheckout() {
    cartItems.clear();
    deliveryMethod.value = 'Standard';
    paymentMethod.value = 'Cash on Delivery';
  }

  void setFromCartItems(List<CartItemForCheckout> items) {
    cartItems.assignAll(items);
  }

}
