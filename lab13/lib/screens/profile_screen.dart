import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/shop_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Settings',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Consumer<ShopProvider>(
              builder: (context, provider, _) {
                return Card(
                  child: ListTile(
                    title: const Text('Language'),
                    subtitle: Text(
                      provider.language == 'en' ? 'English' : 'Монгол',
                    ),
                    trailing: DropdownButton<String>(
                      value: provider.language,
                      items: const [
                        DropdownMenuItem(
                          value: 'en',
                          child: Text('English'),
                        ),
                        DropdownMenuItem(
                          value: 'mn',
                          child: Text('Монгол'),
                        ),
                      ],
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          provider.setLanguage(newValue);
                        }
                      },
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
} 