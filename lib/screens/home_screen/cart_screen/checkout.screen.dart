import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eunissentials/utils/cart.controller.dart';
import 'package:eunissentials/services/wallet.service.dart';
import 'package:eunissentials/services/notification.service.dart';
import 'package:eunissentials/screens/home_screen/main_menu.screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final walletService = WalletService();
  final CartController controller = Get.find<CartController>();
  late final List<int> selectedIndices;
  late final List<CartItemController> items;
  String selectedDelivery = 'standard';

  @override
  void initState() {
    super.initState();
    selectedIndices = List<int>.from(Get.arguments as List);
    items = selectedIndices.map((i) => controller.items[i]).toList();
  }

  double get deliveryFee => selectedDelivery == 'express' ? 50.0 : 40.0;
  double get subtotal =>
      items.fold(0.0, (sum, item) => sum + item.price * item.quantity.value);
  double get total => subtotal + deliveryFee;

  void _showOrderConfirmationDialog() {
    const Color maroon = Color(0xFF800000);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Order"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Please review your order details:"),
            const SizedBox(height: 16),
            _detailRow("Total Amount", "₱${total.toStringAsFixed(2)}"),
            _detailRow("Payment Method", "Euni Wallet"),
            _detailRow(
              "Delivery Option",
              selectedDelivery == 'expr ess'
                  ? 'Express (₱50)'
                  : 'Standard (₱40)',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _confirmOrder();
            },
            style: ElevatedButton.styleFrom(backgroundColor: maroon),
            child: const Text("Confirm", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _confirmOrder() {
    final currentBalance = walletService.getBalance();
    if (total > currentBalance) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Insufficient funds."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    walletService.subtract(total);

    // remove purchased items from cart
    final toRemove = List<int>.from(selectedIndices);
    toRemove.sort((a, b) => b.compareTo(a));
    for (var index in toRemove) {
      controller.items.removeAt(index);
    }

    NotificationService().addNotification("You", "Your Order has been confirmed.");
    // back to cart screen
    Get.offAll(() => const MainMenuScreen());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Order Successful"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Paid ₱${total.toStringAsFixed(2)}"),
            Text("For ${items.length} item(s)"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(label, style: const TextStyle(fontWeight: FontWeight.bold)), Text(value)],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color maroon = Color(0xFF800000);
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: maroon,
        elevation: 0,
        title: const Text('Checkout', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20)),
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Get.back()),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Address section
                  Container(
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        const Icon(Icons.location_on_outlined, color: Colors.grey),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Shipping Address', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                              const SizedBox(height: 4),
                              Text('Manuel S. Enverga University Foundation, Enverga Blvd, Ibabang Dupay, Lucena, 4301 Quezon Province', style: TextStyle(color: Colors.grey.shade700, fontSize: 14)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Product Review
                  Container(
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Review Items', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                        const SizedBox(height: 12),
                        ...items.map((item) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: SizedBox(
                                  width: 60,
                                  height: 60,
                                  child: item.imageUrl != null ? Image.asset(item.imageUrl!, fit: BoxFit.cover) : const Icon(Icons.photo),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 4),
                                    Text('₱${item.price.toStringAsFixed(2)} x ${item.quantity.value}'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ))
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Delivery Options
                  Container(
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Delivery Options', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Radio(value: 'express', groupValue: selectedDelivery, onChanged: (v) => setState(() => selectedDelivery = v!), activeColor: maroon),
                            const Text('Express Delivery ₱50'),
                          ],
                        ),
                        const Padding(padding: EdgeInsets.only(left: 40), child: Text('COD is supported', style: TextStyle(color: Colors.grey))),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Radio(value: 'standard', groupValue: selectedDelivery, onChanged: (v) => setState(() => selectedDelivery = v!), activeColor: maroon),
                            const Text('Standard Delivery ₱40'),
                          ],
                        ),
                        const Padding(padding: EdgeInsets.only(left: 40), child: Text('COD is supported', style: TextStyle(color: Colors.grey))),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Payment Method
                  Container(
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(top: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Payment Method', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                        const SizedBox(height: 8),
                        Row(children: const [Icon(Icons.payments_outlined, color: Colors.grey), SizedBox(width: 12), Text('Euni Wallet')]),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Order Summary
                  Container(
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Order Summary', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 12),
                        buildSummaryRow('Delivery Fee:', '₱${deliveryFee.toStringAsFixed(2)}'),
                        const SizedBox(height: 8),
                        buildSummaryRow('Product Total:', '₱${subtotal.toStringAsFixed(2)}'),
                        const SizedBox(height: 8),
                        buildSummaryRow('Total:', '₱${total.toStringAsFixed(2)}'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Bottom Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), blurRadius: 3, offset: Offset(0, -1))]),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Total:', style: TextStyle(fontSize: 14, color: Colors.grey)), Text('₱${total.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold))]),
                ElevatedButton(onPressed: _showOrderConfirmationDialog, style: ElevatedButton.styleFrom(backgroundColor: maroon, padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))), child: const Text('Place Order', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Row buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [Text(label, style: TextStyle(color: Colors.grey.shade700, fontSize: 14)), Text(value, style: const TextStyle(fontSize: 14))],
    );
  }
}
