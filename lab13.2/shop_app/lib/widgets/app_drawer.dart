import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: const Text('Shop App'),
            automaticallyImplyLeading: false,
          ),
          ListTile(
            leading: const Icon(Icons.shop),
            title: const Text('Shop'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.shopping_cart),
            title: const Text('Cart'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/cart');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.favorite),
            title: const Text('Favorites'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/favorites');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/profile');
            },
          ),
          const Divider(),
          if (authProvider.isAuth)
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Logout'),
              onTap: () {
                Navigator.of(context).pop();
                authProvider.logout();
                Navigator.of(context).pushReplacementNamed('/');
              },
            ),
          if (!authProvider.isAuth)
            ListTile(
              leading: const Icon(Icons.login),
              title: const Text('Login'),
              onTap: () {
                Navigator.of(context).pushReplacementNamed('/login');
              },
            ),
        ],
      ),
    );
  }
} 