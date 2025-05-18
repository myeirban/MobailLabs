import 'package:flutter/material.dart';

import 'screens/login_screen.dart';
import 'screens/menu_screen.dart';
import 'screens/order_screen.dart';
//hereglegch ehleed login screen iig harna.daraa menu screen bolon order
//screen iig harna
import 'models/customer.dart';

//
void main() {
  runApp(const MyApp());
}

// MyApp app ni static butetstei tul stateless widgetiig udamshuulsan
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Хоолны Захиалга',
      theme: ThemeData(
        primarySwatch: Colors.orange, // Гол өнгө
      ),

      // Эхэлж ачаалагдах дэлгэц
      home: const LoginScreen(),

      // menu zam ruu cashiername string helbereer damjdag.
      routes: {
        '/menu': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as String;

          return MenuScreen(cashierName: args);
        },

        '/order': (context) {
          // order zam ruu customer zagvariin hereglegchiin medeelel damjdag
          final customer =
              ModalRoute.of(context)!.settings.arguments as Customer;

          // OrderScreen-д хэрэглэгч дамжуулах
          return OrderScreen(customer: customer);
        },
      },
    );
  }
}
