import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/menu_viewmodel.dart';
import '../utils/api_status.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  void initState() {
    super.initState();
    context.read<MenuViewModel>().fetchMenu();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 🔹 DRAWER ADDED
      drawer: _buildDrawer(),

      appBar: AppBar(
        // ❌ removed title
        elevation: 1,
        actions: const [
          Padding(
            padding: EdgeInsets.all(12),
            child: Icon(Icons.shopping_cart),
          )
        ],
      ),

      body: Consumer<MenuViewModel>(
        builder: (context, vm, _) {
          if (vm.status == ApiStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (vm.status == ApiStatus.error) {
            return Center(child: Text(vm.errorMessage));
          }

          final categories = vm.menu!.categories;

          return DefaultTabController(
            length: categories.length,
            child: Column(
              children: [
                // 🔴 CATEGORY TABS
                Material(
                  color: Colors.white,
                  child: TabBar(
                    isScrollable: true,
                    labelColor: Colors.red,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: Colors.red,
                    tabs: categories
                        .map((c) => Tab(text: c.name))
                        .toList(),
                  ),
                ),

                // 🔽 TAB CONTENT
                Expanded(
                  child: TabBarView(
                    children: categories.map((category) {
                      return ListView.builder(
                        itemCount: category.dishes.length,
                        itemBuilder: (context, index) {
                          return _DishCard(dish: category.dishes[index]);
                        },
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ================= DRAWER UI =================
  Drawer _buildDrawer() {
    return Drawer(
      child: Column(
        children: [
          // GREEN HEADER
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 40),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF43A047), Color(0xFF66BB6A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              children: const [
                CircleAvatar(
                  radius: 35,
                  backgroundImage: NetworkImage(
                    "https://i.pravatar.cc/150?img=3",
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  "Muhammed Naseem",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "ID : 410",
                  style: TextStyle(color: Colors.black54),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // LOGOUT
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Log out"),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
class _DishCard extends StatelessWidget {
  final dish;

  const _DishCard({required this.dish});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // LEFT CONTENT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Veg / Non-Veg Indicator
                Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: dish.isVeg ? Colors.green : Colors.red,
                    ),
                  ),
                  child: Center(
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: dish.isVeg ? Colors.green : Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  dish.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  "₹${dish.price}  •  ${dish.calories} calories",
                  style: const TextStyle(fontSize: 13),
                ),

                const SizedBox(height: 6),

                Text(
                  dish.description,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),

                const SizedBox(height: 10),

                // ADD BUTTON
                Container(
                  width: 120,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: const [
                      Icon(Icons.remove, color: Colors.white),
                      Text(
                        "0",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(Icons.add, color: Colors.white),
                    ],
                  ),
                ),

                if (dish.customizationsAvailable)
                  const Padding(
                    padding: EdgeInsets.only(top: 6),
                    child: Text(
                      "Customizations Available",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // IMAGE
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              dish.imageUrl,
              width: 90,
              height: 90,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
