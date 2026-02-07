import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zartek/models/provider/cart_provider.dart';
import 'viewmodels/menu_viewmodel.dart';
import 'views/menu_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MenuViewModel()),
         ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const MenuScreen(),
      ),
    );
  }
}
