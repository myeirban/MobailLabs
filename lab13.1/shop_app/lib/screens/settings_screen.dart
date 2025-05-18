import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/language_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);
//settings screen deer yamar ch dotood state hadgalahgui.
  @override
  Widget build(BuildContext context) {
    final languageService =
        Provider.of<LanguageService>(context, listen: false);
//UI avtomataar dahin zurj hereggui yum
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Language'),
            trailing: DropdownButton<String>(
              //hereglegchees songolt avahad ashiglasan.

              value: languageService
                  .currentLanguage, //yamar hel anh songogdsoniig haruulsan.
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
              onChanged: (String? value) async {
                if (value != null) {
                  await languageService
                      .setLanguage(value); //helnii kodiig hadgalsan
                  if (context.mounted) {
                    await languageService.initializeLanguage(
                        context); //orchuulgiin sistemd shine hel tohiruulna.
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
