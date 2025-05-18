import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';
import 'services/api_service.dart';
import 'services/language_service.dart';
import 'providers/cart_provider.dart';
import 'providers/products_provider.dart';
import 'providers/favorites_provider.dart';
import 'screens/login_screen.dart';
import 'screens/shop_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/settings_screen.dart';

import 'screens/products_screen.dart';
import 'screens/favorites_screen.dart';
import 'screens/profile_screen.dart';
import 'providers/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final languageService = LanguageService(prefs);
  final apiService = ApiService();

  runApp(
    //easy ni helee angli/mongol solij boldog bolgoson
    EasyLocalization(
      supportedLocales: const [
        Locale('en'),
        Locale('mn'),
      ],
      path: 'assets/translations', //->
      fallbackLocale: const Locale('en'),
      child: MyApp(
        languageService: languageService,
        apiService: apiService,
      ),
    ),
  );
}

//shared/p iig hereglegchiin helnii songoltiig hadgalahad ashiglasan,hadgalsan medeelliig sergeej hereglene
class MyApp extends StatelessWidget {
  final LanguageService languageService;
  final ApiService apiService;

  const MyApp({
    Key? key,
    required this.languageService,
    required this.apiService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      //neg dor olon provider burtgej tedgeeriig material appiin buh hesegt hylbarhan huvaaltsan
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        Provider<ApiService>.value(value: apiService),
        Provider<LanguageService>.value(value: languageService),
        ChangeNotifierProvider(
          create: (context) => ProductsProvider(apiService),
        ),
        ChangeNotifierProvider(
          create: (context) => CartProvider(apiService),
        ),
        ChangeNotifierProvider(
          create: (context) => FavoritesProvider(),
        ),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          final favoritesProvider =
              Provider.of<FavoritesProvider>(context, listen: false);
          final cartProvider =
              Provider.of<CartProvider>(context, listen: false);
          authProvider.setProviders(favoritesProvider,
              cartProvider); //durtai,sagsiig zov id aar ni achaaluulahiin tuld id aar ni damjuulah heregtei.
//ene ni medeelliig sergeej ,holboh uuregtei
          return MaterialApp(
            title: 'Shop App',
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            theme: ThemeData(
              primarySwatch: Colors.blue,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            home: const LoginScreen(), //anh home d
            routes: {//authProvider.login ashiglan amjilttai nevtervel
              '/shop': (context) => const ShopScreen(),
              '/cart': (context) => const CartScreen(),
              '/settings': (context) => const SettingsScreen(),
              '/favorites': (context) => const FavoritesScreen(),
              '/profile': (context) => const ProfileScreen(),
              '/login': (context) => const LoginScreen(),
            },
          );
        },
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

  final List<Widget> _pages = const [
    ProductsScreen(),
    CartScreen(),
    FavoritesScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex], //olon huudasd shijih bolomjtoi bolson
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Bag',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex:
            _selectedIndex, //selected ni ali tab deer baigaag zaaj ogson,odoogiin songogdson
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}
