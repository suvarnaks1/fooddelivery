import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartItem {
  final String id;
  final String name;
  final double price;
  final int calories;
  final bool isVeg;
  int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.calories,
    required this.isVeg,
    this.quantity = 1,
  });

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "price": price,
        "calories": calories,
        "isVeg": isVeg,
        "quantity": quantity,
      };

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      calories: json['calories'],
      isVeg: json['isVeg'],
      quantity: json['quantity'],
    );
  }
}

class CartProvider extends ChangeNotifier {
  final Map<String, CartItem> _items = {};

  CartProvider() {
    loadCart();
  }

  Map<String, CartItem> get items => _items;

  int get totalCount =>
      _items.values.fold(0, (sum, item) => sum + item.quantity);

  double get totalAmount =>
      _items.values.fold(0, (sum, item) => sum + item.price * item.quantity);

  // ---------------- ADD ITEM ----------------
  void addItem(CartItem item) {
    if (_items.containsKey(item.id)) {
      _items[item.id]!.quantity++;
    } else {
      _items[item.id] = item;
    }
    saveCart();
    notifyListeners();
  }

  // ---------------- REMOVE ITEM ----------------
  void removeItem(String id) {
    if (!_items.containsKey(id)) return;

    if (_items[id]!.quantity > 1) {
      _items[id]!.quantity--;
    } else {
      _items.remove(id);
    }
    saveCart();
    notifyListeners();
  }

  int getItemCount(String id) {
    return _items[id]?.quantity ?? 0;
  }

  // ---------------- CLEAR CART ----------------
  void clearCart() {
    _items.clear();
    saveCart();
    notifyListeners();
  }

  // ---------------- SHARED PREFS ----------------
  Future<void> saveCart() async {
    final prefs = await SharedPreferences.getInstance();
    final cartJson =
        jsonEncode(_items.map((key, value) => MapEntry(key, value.toJson())));
    await prefs.setString("cart_data", cartJson);
  }

  Future<void> loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString("cart_data");

    if (data == null) return;

    final decoded = jsonDecode(data) as Map<String, dynamic>;
    decoded.forEach((key, value) {
      _items[key] = CartItem.fromJson(value);
    });
    notifyListeners();
  }
}
