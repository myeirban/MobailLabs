import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/products_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/auth_provider.dart';

import 'screens/products_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/favorites_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      //neg dor olon provider burtgej, negen zereg appt hurgej ogson
      providers: [
        //widget uudad medegdej,notify listeners ashiglan UI g shinecleh bolomj olgodog
        ChangeNotifierProvider(create: (ctx) => AuthProvider()),
        ChangeNotifierProvider(create: (ctx) => ProductsProvider()),
        ChangeNotifierProvider(create: (ctx) => CartProvider()),
      ], //Material appiig dahin zurj ogdog.Appin butes oorchlogdoh bolomjtoi boldog
      child: Consumer<AuthProvider>(
        builder:
            (ctx, auth, _) => MaterialApp(
              title: 'Shop App',
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                useMaterial3: true,
                appBarTheme: const AppBarTheme(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  elevation: 0,
                  centerTitle: true,
                ),
              ),
              //bottom navigation bar ashiglan dorvon huudas hoorondoo shiljih bolomjtoi
              //undsn layout g hariutsaj baigaa
              home:
                  const ShopHomePage(), //hamgiin anhni delgetsiig zaaj ogch baigaa
              //Shop home page ni main/home page bolj baigaa
              routes: {
                //nerlesen zamar udirdaj ogdog.
                '/cart': (ctx) => const CartScreen(),
                '/favorites': (ctx) => const FavoritesScreen(),
                '/profile': (ctx) => const ProfileScreen(),
                '/login': (ctx) => const LoginScreen(),
              },
            ),
      ),
    );
  }
}

class ShopHomePage extends StatefulWidget {
  const ShopHomePage({super.key});

  @override
  State<ShopHomePage> createState() => _ShopHomePageState();
}

class _ShopHomePageState extends State<ShopHomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const ProductsScreen(),
    const CartScreen(),
    const FavoritesScreen(),
    const ProfileScreen(),
  ];
  //huvsagchiin utgiig oorchilj body hesegt haruulj bui huudsiig solih uuregtei
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; //statefull widget ashiglasan
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: 'Bag'),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}
