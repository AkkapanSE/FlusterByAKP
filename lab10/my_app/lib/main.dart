import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// Import Providers
import 'providers/user_provider.dart';
import 'providers/product_provider.dart';
import 'providers/cart_provider.dart';
// Import Screens
import 'screens/login_screen.dart';
import 'screens/user_list_screen.dart';
import 'screens/product_list_screen.dart';
import 'screens/cart_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()), 
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: MaterialApp(
        title: 'FakeStore Management System',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        ),
        home: const LoginScreen(), 
        routes: {
          '/user_list': (context) => const UserListScreen(),
          '/product_list': (context) => const ProductListScreen(),
          // ลบ const ออกเพื่อให้ทำงานร่วมกับ Provider ได้อย่างสมบูรณ์
          '/cart': (context) => CartScreen(), 
        },
      ),
    );
  }
}