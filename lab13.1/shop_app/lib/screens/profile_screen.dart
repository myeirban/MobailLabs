import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import '../providers/auth_provider.dart';
import '../services/language_service.dart';
import '../providers/cart_provider.dart';
import '../providers/favorites_provider.dart';

//ene huudasnii gol uureg ni hereglegchiin hubiin medeelel,tohirgoo bolon
//garah bolomjiig haruuldag.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final languageService =
        Provider.of<LanguageService>(context, listen: false);
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final favoritesProvider = Provider.of<FavoritesProvider>(context, listen: false);
    final user = authProvider.user;

    return Scaffold(
      appBar: AppBar(
        title: Text('profile.title').tr(),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await cartProvider.clearCartPrefs();
              await authProvider.logout();
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, '/login');
              } //hereglegch log out hiisnii daraa login huudas ruu shiljij,
              //profile screeniig stekees ustgadag.
            },
          ),
        ],
      ),
      body: user == null //end ta nevtreegui gsn messej haruuldag.
          ? Center(child: Text('profile.not_logged_in').tr())
          : SingleChildScrollView(
              //elementuud bagtahaargui bolson yed doosh guilgeh bolomjiig olgodog.
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: user.avatar.isNotEmpty
                          ? NetworkImage(user.avatar)
                          : null,
                      child: user.avatar.isEmpty
                          ? const Icon(Icons.person, size: 50)
                          : null, //herev zurag baihguibol icons.person iig haruulna.
                      //zurag baigaa bol internetees tataad haruulna.
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildInfoCard(
                    title: 'profile.personal_info'.tr(),
                    children: [
                      _buildInfoRow('profile.name'.tr(), user.name),
                      _buildInfoRow('profile.username'.tr(), user.username),
                      _buildInfoRow('profile.email'.tr(), user.email),
                      _buildInfoRow('profile.phone'.tr(), user.phone),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildInfoCard(
                    title: 'profile.settings'.tr(),
                    children: [
                      ListTile(
                        leading: const Icon(Icons.favorite),
                        title: Text('profile.favorites').tr(),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          Navigator.pushNamed(context, '/favorites');
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.shopping_bag),
                        title: Text('profile.order_history').tr(),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {},
                      ),
                      ListTile(
                        leading: const Icon(Icons.language),
                        title: Text('profile.language').tr(),
                        trailing: DropdownButton<String>(
                          value: context.locale.languageCode,
                          items: [
                            DropdownMenuItem(
                              value: 'en',
                              child: Text('settings.english').tr(),
                            ),
                            DropdownMenuItem(
                              value: 'mn',
                              child: Text('settings.mongolian').tr(),
                            ),
                          ],
                          onChanged: (String? value) {
                            if (value != null) {
                              context.setLocale(Locale(
                                  value)); //helee songohod appin hel soligdoj bn

                              languageService.setLanguage(
                                  value); //tuhain songoltiig hadgalsan;
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
