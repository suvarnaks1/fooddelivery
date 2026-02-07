import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zartek/models/provider/cart_provider.dart';
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
    final cart = context.watch<CartProvider>();

    return Consumer<MenuViewModel>(
      builder: (context, vm, _) {
        if (vm.status == ApiStatus.loading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (vm.status == ApiStatus.error) {
          return Scaffold(
            body: Center(child: Text(vm.errorMessage)),
          );
        }

        final categories = vm.menu!.categories;

        return DefaultTabController(
          length: categories.length,
          child: Scaffold(
            drawer: _buildDrawer(),
            appBar: AppBar(
              
              bottom: TabBar(
                isScrollable: true,
                indicatorColor: Colors.white,
                tabs: categories
                    .map((c) => Tab(text: c.name))
                    .toList(),
              ),
              actions: [
                Stack(
                  alignment: Alignment.topRight,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(12),
                      child: Icon(Icons.shopping_cart),
  

                    ),
                    if (cart.totalCount > 0)
                      Positioned(
                        right: 6,
                        top: 6,
                        child: CircleAvatar(
                          radius: 9,
                          backgroundColor: Colors.red,
                          child: Text(
                            cart.totalCount.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      )
                  ],
                )
              ],
            ),

            // TAB CONTENT
            body: TabBarView(
              children: categories.map((category) {
                return ListView(
                  children: category.dishes
                      .map((dish) => DishCard(dish: dish))
                      .toList(),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
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
              
            },
          ),
        ],
      ),
    );
  }
class DishCard extends StatelessWidget {
  final dish;

  const DishCard({super.key, required this.dish});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final String dishId = dish.id.toString();
    final count = cart.getItemCount(dishId);

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                  "₹${dish.price} • ${dish.calories} calories",
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

                // ADD / REMOVE BUTTON
                Container(
                  width: 120,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: count > 0
                            ? () => cart.removeItem(dishId)
                            : null,
                        child: const Icon(Icons.remove,
                            color: Colors.white),
                      ),
                      Text(
                        count.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => cart.addItem(
  CartItem(
    id: dishId,
    name: dish.name,
    price: double.parse(dish.price),
    calories: dish.calories,
    isVeg: dish.isVeg,
  ),
),

                        child: const Icon(Icons.add,
                            color: Colors.white),
                      ),
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
