import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eunissentials/utils/global.colors.dart';
import 'package:eunissentials/screens/home_screen/inbox.screen.dart';
import 'package:eunissentials/screens/my_listing_screen/my_listings.screen.dart';
import 'package:eunissentials/screens/history_screen/transaction_history.screen.dart';
import 'package:eunissentials/screens/profile_screen/profile.screen.dart';
import 'package:eunissentials/screens/home_screen/item_details.screen.dart';
import 'package:eunissentials/screens/home_screen/notification.screen.dart';
import 'package:eunissentials/screens/home_screen/add_to_cart.screen.dart';

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeContent(),
    const ListingsScreen(),
    const TransactionHistoryScreen(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.red.shade900,
        unselectedItemColor: Colors.grey.shade700,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'My Listings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// ✅ Updated to StatefulWidget
class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<Map<String, String>> allProducts = const [
    {
      'name': 'Maroon Necktie',
      'price': '₱299.00',
      'image': 'lib/assets/Clothing/maroon_necktie.jpg',
      'description': 'A formal maroon necktie perfect for uniforms or events.'
    },
    {
      'name': 'Maroon Skirt',
      'price': '₱399.00',
      'image': 'lib/assets/Clothing/Maroon_skirt.jpg',
      'description': 'Comfortable maroon skirt ideal for school or office attire.'
    },
    {
      'name': 'Slacks',
      'price': '₱399.00',
      'image': 'lib/assets/Clothing/Slacks_Clothing.jpg',
      'description': 'Classic fit slacks suitable for everyday wear or uniforms.'
    },
    {
      'name': 'White Blouse',
      'price': '₱299.00',
      'image': 'lib/assets/Clothing/white_blouse.png',
      'description': 'A breathable white blouse perfect for school or office use.'
    },
    {
      'name': 'White Polo',
      'price': '₱299.00',
      'image': 'lib/assets/Clothing/White_Polo_Clothing.jpg',
      'description': 'White polo shirt that’s simple, clean, and comfortable.'
    },
    {
      'name': 'White Polo-Shirt',
      'price': '₱399.00',
      'image': 'lib/assets/Clothing/White_Polo_Shirt_Clothing.jpg',
      'description': 'A premium version of the white polo-shirt with extra comfort.'
    },
    {
      'name': 'Kleenex Tissue',
      'price': '₱99.00',
      'image': 'lib/assets/Hygiene/Kleenex_Tissue.jpg',
      'description': 'Soft and gentle tissue for everyday hygiene needs.'
    },
    {
      'name': 'Nice Facial Tissue',
      'price': '₱149.00',
      'image': 'lib/assets/Hygiene/Nice_Facial_Tissue.jpg',
      'description': 'Facial tissue with soft texture and durable quality.'
    },
    {
      'name': 'Sanicare Tissue',
      'price': '₱149.00',
      'image': 'lib/assets/Hygiene/Sanicare_Ecolayers_Tissue.jpg',
      'description': 'Sanicare tissue for hygienic and clean use on the go.'
    },
    {
      'name': 'Scotties Tissue',
      'price': '₱79.00',
      'image': 'lib/assets/Hygiene/Scotties_Tissue.jpeg',
      'description': 'Affordable and reliable tissue for all purposes.'
    },
    {
      'name': 'Sting',
      'price': '₱25.00',
      'image': 'lib/assets/Drinks/Sting_Drink.jpg',
      'description': 'Energy drink that boosts stamina and keeps you alert.'
    },
    {
      'name': 'Fudgee Bar',
      'price': '₱10.00',
      'image': 'lib/assets/Foods/Fudgee_Barr_Foods.jpg',
      'description': 'Delicious chocolate-filled snack cake perfect for quick bites.',
    },
    {
      'name': 'ChocoMallows (6pcs)',
      'price': '₱60.00',
      'image': 'lib/assets/Foods/ChocoMallows_6pcs_Foods.jpg',
      'description': 'Pack of 6 chocolate-coated marshmallow treats.',
    },
    {
      'name': 'Smart C Calamansi',
      'price': '₱50.00',
      'image': 'lib/assets/Drinks/Smart_C_Calamansi_Drink.jpeg',
      'description': 'Refreshing calamansi-flavored vitamin C drink.',
    },
    {
      'name': 'Anker PowerBank',
      'price': '₱350.00',
      'image': 'lib/assets/techgadgets/powerbank.jpg',
      'description': 'Reliable Anker power bank to keep your devices charged on the go.',
    },
    {
      'name': 'Portable E Fan',
      'price': '₱479.00',
      'image': 'lib/assets/techgadgets/efan.jpg',
      'description': 'Rechargeable portable electric fan for cooling anytime, anywhere.',
    },
    {
      'name': 'Scientific Calculator',
      'price': '₱399.00',
      'image': 'lib/assets/techgadgets/scientifc.jpg',
      'description': 'Advanced calculator ideal for science and math computations.',
    },
    {
      'name': '10pcs Ballpen',
      'price': '₱199.00',
      'image': 'lib/assets/School_Supplies/10_Ballpens_School_Supplies.jpeg',
      'description': 'Set of 10 smooth-writing ballpoint pens for daily use.',
    },
    {
      'name': 'Yellow Pad',
      'price': '₱75.00',
      'image': 'lib/assets/School_Supplies/Cattleya_Yellow_RuledPad_School_Supplies.jpeg',
      'description': 'Ruled yellow pad paper, perfect for note-taking and assignments.',
    },
    {
      'name': 'Correction Tape',
      'price': '₱50.00',
      'image': 'lib/assets/School_Supplies/Correction_Tape_School_Supplies.jpeg',
      'description': 'Handy correction tape for clean and easy error fixing.',
    },
  ];

  List<Map<String, String>> get filteredProducts {
    if (_searchQuery.isEmpty) return allProducts;
    return allProducts.where((product) {
      final name = product['name']?.toLowerCase() ?? '';
      return name.contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black87, GlobalColors.textColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          title: Row(
            children: [
              Icon(Icons.shopping_cart, color: Colors.red.shade900, size: 38),
              const SizedBox(width: 5),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  ShaderMask(
                    shaderCallback: (Rect bounds) {
                      return LinearGradient(
                        colors: [
                          Colors.red.shade800,
                          GlobalColors.textColor,
                          Colors.white,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(bounds);
                    },
                    child: const Text(
                      'EU',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Text(
                    'nissentials',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          elevation: 8,
          automaticallyImplyLeading: false,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Search products...',
                        hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
                        prefixIcon: Icon(Icons.search, color: Colors.grey.shade600),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: Colors.red.shade900),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  _buildCircleIcon(
                    icon: Icons.notifications,
                    tooltip: 'Notifications',
                    onTap: () => Get.to(() => const NotifScreen()),
                  ),
                  const SizedBox(width: 8),
                  _buildCircleIcon(
                    icon: Icons.shopping_cart_checkout,
                    tooltip: 'Cart',
                    onTap: () => Get.to(() => const AddtoCartScreen()),
                  ),
                  const SizedBox(width: 8),
                  _buildCircleIcon(
                    icon: Icons.chat_bubble,
                    tooltip: 'Chat',
                    onTap: () => Get.to(() => const InboxScreen()),
                  ),
                ],
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: filteredProducts.length,
                itemBuilder: (context, index) {
                  final product = filteredProducts[index];
                  final String name = product['name'] ?? 'Product';
                  final String price = product['price'] ?? '₱0.00';
                  final String imageUrl = product['image'] ?? '';

                  return GestureDetector(
                    onTap: () {
                      Get.to(() => ItemDetailsScreen(product: product));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade200,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset(
                                  imageUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Center(
                                      child: Icon(Icons.broken_image, size: 48, color: Colors.grey),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 4.0),
                            child: Text(
                              name,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
                            child: Text(
                              price,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.red.shade900,
                                fontWeight: FontWeight.bold,
                              ),
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
      ),
    );
  }
}

Widget _buildCircleIcon({
  required IconData icon,
  required String tooltip,
  required VoidCallback onTap,
}) {
  return Container(
    decoration: BoxDecoration(
      color: GlobalColors.textColor,
      shape: BoxShape.circle,
      boxShadow: [
        BoxShadow(
          color: GlobalColors.textColor,
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: IconButton(
      icon: Icon(icon, color: Colors.white),
      onPressed: onTap,
      tooltip: tooltip,
    ),
  );
}
