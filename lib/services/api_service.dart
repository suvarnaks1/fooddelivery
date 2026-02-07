import 'package:http/http.dart' as http;
import '../models/menu_model.dart';

class ApiService {
  final String url =
      "https://faheemkodi.github.io/mock-menu-api/menu.json";

  Future<Menu> fetchMenu() async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return menuFromJson(response.body);
    } else {
      throw Exception("Failed to fetch menu");
    }
  }
}
