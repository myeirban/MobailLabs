import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('My Profile')),
      body:
          !authProvider.isAuth
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'You need to login to view your profile',
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed('/login');
                      },
                      child: const Text('Login'),
                    ),
                  ],
                ),
              )
              : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundImage:
                                  authProvider.user!.avatar.isNotEmpty
                                      ? NetworkImage(authProvider.user!.avatar)
                                      : null,
                              child:
                                  authProvider.user!.avatar.isEmpty
                                      ? Text(
                                        authProvider.user!.name.substring(0, 1),
                                        style: const TextStyle(fontSize: 40),
                                      )
                                      : null,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              authProvider.user!.name,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              authProvider.user!.email,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      _buildSectionItem(
                        context,
                        title: 'My orders',
                        icon: Icons.shopping_bag_outlined,
                        onTap: () {},
                      ),
                      _buildSectionItem(
                        context,
                        title: 'Shipping addresses',
                        icon: Icons.location_on_outlined,
                        onTap: () {},
                      ),
                      _buildSectionItem(
                        context,
                        title: 'Payment methods',
                        icon: Icons.credit_card_outlined,
                        onTap: () {},
                      ),
                      _buildSectionItem(
                        context,
                        title: 'Promotion codes',
                        icon: Icons.discount_outlined,
                        onTap: () {},
                      ),
                      _buildSectionItem(
                        context,
                        title: 'My reviews',
                        icon: Icons.star_border_outlined,
                        onTap: () {},
                      ),
                      _buildSectionItem(
                        context,
                        title: 'Settings',
                        icon: Icons.settings_outlined,
                        onTap: () {},
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            authProvider.logout();
                            Navigator.of(context).pushReplacementNamed('/');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text(
                            'LOGOUT',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }

  Widget _buildSectionItem(
    BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        ListTile(
          title: Text(title, style: const TextStyle(fontSize: 16)),
          leading: Icon(icon),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: onTap,
        ),
        const Divider(),
      ],
    );
  }
}
