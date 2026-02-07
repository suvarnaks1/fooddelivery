import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/cart_provider.dart';

class OrderSummaryScreen extends StatelessWidget {
  const OrderSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final items = cart.items.values.toList();

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text("Order Summary"),
      ),
      body: Column(
        children: [
          // TOP GREEN BAR
          Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(12),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.green.shade900,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              "${items.length} Dishes - ${cart.totalCount} Items",
              style: const TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),

          // ITEM LIST
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];

                return Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Veg / Non-Veg
                      Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: item.isVeg ? Colors.green : Colors.red,
                          ),
                        ),
                        child: Center(
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: item.isVeg
                                  ? Colors.green
                                  : Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 8),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                                "INR ${item.price.toStringAsFixed(2)}"),
                            Text("${item.calories} calories"),
                          ],
                        ),
                      ),

                      Column(
                        children: [
                          // + - BUTTON
                          Container(
                            width: 110,
                            height: 36,
                            decoration: BoxDecoration(
                              color: Colors.green.shade900,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                              children: [
                                GestureDetector(
                                  onTap: () =>
                                      cart.removeItem(item.id),
                                  child: const Icon(Icons.remove,
                                      color: Colors.white),
                                ),
                                Text(
                                  item.quantity.toString(),
                                  style: const TextStyle(
                                      color: Colors.white),
                                ),
                                GestureDetector(
                                  onTap: () =>
                                      cart.addItem(item),
                                  child: const Icon(Icons.add,
                                      color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "INR ${(item.price * item.quantity).toStringAsFixed(2)}",
                          ),
                        ],
                      )
                    ],
                  ),
                );
              },
            ),
          ),

          const Divider(),

          // TOTAL
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Total Amount",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  "INR ${cart.totalAmount.toStringAsFixed(2)}",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green),
                ),
              ],
            ),
          ),

          // PLACE ORDER
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      content: const Text(
                          "Order successfully placed"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            cart.clearCart();
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          child: const Text("OK"),
                        )
                      ],
                    ),
                  );
                },
                child: const Text("Place Order"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
