import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eunissentials/utils/global.colors.dart';
import 'package:eunissentials/screens/my_listing_screen/add_item.screen.dart';
import 'package:eunissentials/screens/my_listing_screen/listing.item_detail.screen.dart';

class ListingsScreen extends StatefulWidget {
  const ListingsScreen({super.key});

  @override
  State<ListingsScreen> createState() => _ListingsScreenState();
}

class _ListingsScreenState extends State<ListingsScreen> {
  bool _selectionMode = false;
  final Set<int> _selectedItems = {};
  final List<Map<String, dynamic>> _items = [];
  int _nextId = 1;

  void _toggleSelectionMode() {
    setState(() {
      _selectionMode = !_selectionMode;
      if (!_selectionMode) _selectedItems.clear();
    });
  }

  void _toggleItemSelection(int itemId) {
    setState(() {
      if (_selectedItems.contains(itemId)) {
        _selectedItems.remove(itemId);
      } else {
        _selectedItems.add(itemId);
      }
      if (_selectedItems.isEmpty) _selectionMode = false;
    });
  }

  void _removeSelectedItems() {
    setState(() {
      _items.removeWhere((item) => _selectedItems.contains(item['id']));
      _selectedItems.clear();
      _selectionMode = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Selected items removed')),
    );
  }

  Future<void> _navigateToAddItem() async {
    final newItem = await Get.to(() => const AddItemScreen());
    if (newItem != null && newItem is Map<String, dynamic>) {
      setState(() {
        newItem['id'] = _nextId++;
        _items.add(newItem);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: AppBar(
          backgroundColor: GlobalColors.textColor,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: const Padding(
            padding: EdgeInsets.only(top: 16),
            child: Text(
              'My Listings',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          elevation: 0,
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Search Bar',
                  prefixIcon: Icon(Icons.search, size: 20),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
          ),

          // Buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _navigateToAddItem,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: GlobalColors.textColor,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: const Text(
                      'Add Item',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed:
                    _selectionMode ? _removeSelectedItems : _toggleSelectionMode,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: GlobalColors.textColor,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: Text(
                      _selectionMode ? 'Remove Selected Items' : 'Remove Items',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Item Grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: 1,
              ),
              itemCount: _items.length,
              itemBuilder: (context, index) {
                final item = _items[index];
                final isSelected = _selectedItems.contains(item['id']);
                final imagePath = item['image'] as String?;

                return GestureDetector(
                  onTap: () {
                    if (_selectionMode) {
                      _toggleItemSelection(item['id']);
                    } else {
                      Get.to(() => ListingItemDetailScreen(item: item));
                    }
                  },
                  onLongPress: () {
                    if (!_selectionMode) {
                      _toggleSelectionMode();
                      _toggleItemSelection(item['id']);
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (imagePath != null && File(imagePath).existsSync())
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(
                                    File(imagePath),
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )
                            else
                              const Expanded(
                                child: Icon(Icons.image_not_supported, size: 50),
                              ),
                            const SizedBox(height: 4),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(
                                item['name'],
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (_selectionMode)
                          Positioned(
                            top: 8,
                            left: 8,
                            child: Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? Colors.red.shade900
                                    : Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: isSelected
                                  ? const Icon(Icons.check,
                                  color: Colors.white, size: 14)
                                  : null,
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
