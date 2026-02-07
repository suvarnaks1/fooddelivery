import 'package:flutter/material.dart';
import '../models/menu_model.dart';
import '../services/api_service.dart';
import '../utils/api_status.dart';

class MenuViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  Menu? menu;
  ApiStatus status = ApiStatus.initial;
  String errorMessage = "";

  Future<void> fetchMenu() async {
    status = ApiStatus.loading;
    notifyListeners();

    try {
      menu = await _apiService.fetchMenu();
      status = ApiStatus.success;
    } catch (e) {
      status = ApiStatus.error;
      errorMessage = e.toString();
    }

    notifyListeners();
  }
}
