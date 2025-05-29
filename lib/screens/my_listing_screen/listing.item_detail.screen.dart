import 'package:flutter/material.dart';
import 'dart:io';

class ListingItemDetailScreen extends StatefulWidget {
  final Map<String, dynamic> item;

  const ListingItemDetailScreen({super.key, required this.item});

  @override
  State<ListingItemDetailScreen> createState() => _ListingItemDetailScreenState();
}

class _ListingItemDetailScreenState extends State<ListingItemDetailScreen> {
  int _quantity = 1;

  void _incrementQuantity() {
    setState(() => _quantity++);
  }

  void _decrementQuantity() {
    if (_quantity > 1) setState(() => _quantity--);
  }

  @override
  Widget build(BuildContext context) {
    final name = widget.item['name'] as String? ?? 'No Name';
    final price = widget.item['price'] as String? ?? '₱0.00';
    final rawImage = widget.item['image'] as String?;
    final description = widget.item['description'] as String? ?? 'No description available.';

    // Use FileImage for user-provided images, fallback to placeholder
    ImageProvider imageProvider;
    if (rawImage != null && rawImage.isNotEmpty) {
      imageProvider = FileImage(File(rawImage));
    } else {
      imageProvider = const AssetImage('assets/placeholder.png');
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(name),
        backgroundColor: const Color(0xFF8B1E1E),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image(
                    image: imageProvider,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stack) => Container(
                      color: Colors.grey[300],
                      child: const Center(child: Icon(Icons.broken_image, size: 48)),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(
                    price,
                    style: TextStyle(fontSize: 18, color: Colors.red[900], fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  const Text('Description:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(description, style: const TextStyle(fontSize: 16)),
                  const Spacer(),
                  Row(
                    children: <Widget>[
                      const Text('Quantity:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: _decrementQuantity,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.grey),
                          ),
                          child: const Icon(Icons.remove, size: 16),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text('$_quantity', style: const TextStyle(fontSize: 16)),
                      ),
                      GestureDetector(
                        onTap: _incrementQuantity,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.grey),
                          ),
                          child: const Icon(Icons.add, size: 16),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
