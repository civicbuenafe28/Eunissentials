import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eunissentials/screens/home_screen/inbox.screen.dart';
import 'package:eunissentials/utils/cart.controller.dart';
import 'cart_screen/checkout.screen.dart';

class AddtoCartScreen extends StatefulWidget {
  const AddtoCartScreen({super.key});

  @override
  State<AddtoCartScreen> createState() => _AddtoCartScreenState();
}

class _AddtoCartScreenState extends State<AddtoCartScreen> {
  final CartController controller = Get.put(CartController());
  final Set<int> selectedForDelete = {};
  final Set<int> selectedForCheckout = {};

  @override
  Widget build(BuildContext context) {
    const Color maroon = Color(0xFF800000);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: maroon,
        title: const Text('Shopping Cart', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.message, color: Colors.white),
            onPressed: () => Get.to(() => const InboxScreen()),
          ),
          Obx(() =>
              TextButton(
                onPressed: () {
                  controller.toggleEditMode();
                  setState(() {
                    selectedForDelete.clear();
                    selectedForCheckout.clear();
                  });
                },
                child: Text(
                  controller.isEditing.value ? 'Done' : 'Edit',
                  style: const TextStyle(color: Colors.white),
                ),
              )),
        ],
      ),
      body: Obx(() =>
          Column(
            children: [
              Expanded(
                child: controller.items.isEmpty
                    ? const Center(child: Text('No items in the cart.'))
                    : ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: controller.items.length,
                  itemBuilder: (context, index) {
                    final item = controller.items[index];
                    final isEditing = controller.isEditing.value;
                    final isSelected = isEditing
                        ? selectedForDelete.contains(index)
                        : selectedForCheckout.contains(index);

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Checkbox(
                              value: isSelected,
                              onChanged: (val) {
                                setState(() {
                                  if (isEditing) {
                                    val == true
                                        ? selectedForDelete.add(index)
                                        : selectedForDelete.remove(index);
                                  } else {
                                    val == true
                                        ? selectedForCheckout.add(index)
                                        : selectedForCheckout.remove(index);
                                  }
                                });
                              },
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                width: 60,
                                height: 60,
                                color: Colors.grey.shade300,
                                child: item.imageUrl != null
                                    ? Image.asset(
                                  item.imageUrl!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(Icons.broken_image, color: Colors.red);
                                  },
                                )
                                    : const Center(child: Text('Photo')),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 4),
                                  Text('₱${item.price.toStringAsFixed(2)}', style: const TextStyle(color: Colors.grey)),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                const Text('Qty', style: TextStyle(fontSize: 12)),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.remove, size: 16),
                                      onPressed: () => controller.decreaseQuantity(item),
                                    ),
                                    Text('${item.quantity.value}', style: const TextStyle(fontSize: 14)), // Changed to item.quantity.value
                                    IconButton(
                                      icon: const Icon(Icons.add, size: 16),
                                      onPressed: () => controller.increaseQuantity(item),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const Divider(thickness: 1),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  children: [
                    Checkbox(
                      value: controller.isEditing.value
                          ? selectedForDelete.length == controller.items.length && controller.items.isNotEmpty
                          : selectedForCheckout.length == controller.items.length && controller.items.isNotEmpty,
                      onChanged: (val) {
                        setState(() {
                          final target = controller.isEditing.value ? selectedForDelete : selectedForCheckout;
                          target.clear();
                          if (val == true) {
                            target.addAll(List.generate(controller.items.length, (index) => index));
                          }
                        });
                      },
                    ),
                    Text(controller.isEditing.value ? 'All' : ''),
                    const Spacer(),
                    controller.isEditing.value
                        ? ElevatedButton(
                      onPressed: selectedForDelete.isEmpty
                          ? null
                          : () => Get.defaultDialog(
                        title: 'Remove Items',
                        middleText: 'Are you sure you want to delete selected items?',
                        confirm: ElevatedButton(
                          onPressed: () {
                            final toRemove = selectedForDelete.toList()..sort((a, b) => b.compareTo(a));
                            for (var index in toRemove) {
                              controller.items.removeAt(index);
                            }
                            selectedForDelete.clear();
                            Get.back();
                          },
                          style: ElevatedButton.styleFrom(backgroundColor: maroon),
                          child: const Text('Yes', style: TextStyle(color: Colors.white)),
                        ),
                        cancel: TextButton(
                          onPressed: () => Get.back(),
                          child: const Text('Cancel'),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: maroon,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                      child: const Text('Delete', style: TextStyle(color: Colors.white)),
                    )
                        : Row(
                      children: [
                        Text('Total: ₱${_calculateSelectedTotal().toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: selectedForCheckout.isEmpty
                              ? null
                              : () {
                            // Pass indices to CheckoutScreen
                            Get.to(() => CheckoutScreen(),
                                arguments: selectedForCheckout.toList());
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: maroon,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          ),
                          child: const Text('Check Out', style: TextStyle(color: Colors.white)),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }

  double _calculateSelectedTotal() {
    double total = 0;
    for (var i in selectedForCheckout) {
      final item = controller.items[i];
      total += item.price * item.quantity.value;
    }
    return total;
  }
}
