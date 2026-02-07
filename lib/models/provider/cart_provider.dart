import 'package:flutter/material.dart';

class CartProvider extends ChangeNotifier {
  final Map<String, int> _items = {};

  int get totalCount =>
      _items.values.fold(0, (sum, qty) => sum + qty);

  int getItemCount(String id) => _items[id] ?? 0;

  void addItem(String id) {
    _items[id] = getItemCount(id) + 1;
    notifyListeners();
  }

  void removeItem(String id) {
    if (!_items.containsKey(id)) return;
    if (_items[id]! > 1) {
      _items[id] = _items[id]! - 1;
    } else {
      _items.remove(id);
    }
    notifyListeners();
  }
}
