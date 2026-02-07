import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String name;
  final double price;
  final int calories;
  final bool isVeg;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.calories,
    required this.isVeg,
  });
}

class CartProvider extends ChangeNotifier {
  final Map<String, int> _items = {};
  final Map<String, CartItem> _details = {};

  int get totalCount =>
      _items.values.fold(0, (sum, qty) => sum + qty);

  double get totalAmount {
    double total = 0;
    _items.forEach((id, qty) {
      total += _details[id]!.price * qty;
    });
    return total;
  }

  List<MapEntry<CartItem, int>> get cartItems =>
      _items.entries.map((e) => MapEntry(_details[e.key]!, e.value)).toList();

  int getItemCount(String id) => _items[id] ?? 0;

  void addItem(CartItem item) {
    _details[item.id] = item;
    _items[item.id] = getItemCount(item.id) + 1;
    notifyListeners();
  }

  void removeItem(String id) {
    if (!_items.containsKey(id)) return;

    if (_items[id]! > 1) {
      _items[id] = _items[id]! - 1;
    } else {
      _items.remove(id);
      _details.remove(id);
    }
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    _details.clear();
    notifyListeners();
  }
}
