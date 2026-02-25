import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_strings.dart';
import '../../core/services/url_service.dart';
import 'settings_view_model.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SettingsViewModel>();
    final urlService = context.read<UrlService>();

    final isDark = vm.themeMode == ThemeMode.dark;
    final isLight = vm.themeMode == ThemeMode.light;

    return Scaffold(
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Dark mode'),
            subtitle: Text(isDark ? 'Dark' : (isLight ? 'Light' : 'System')),
            value: isDark,
            onChanged: (v) => vm.setThemeMode(v ? ThemeMode.dark : ThemeMode.light),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.coffee_outlined),
            title: const Text('Support (Buy Me a Coffee)'),
            subtitle: const Text('Fuel the Fahhh. Open Buy Me a Coffee.'),
            onTap: () async {
              final ok = await urlService.openExternal(AppStrings.supportUrl);
              if (!ok && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Could not open link.')));
              }
            },
          ),
          const Divider(height: 1),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Tip: If it feels like spaghetti, it probably is.',
              style: TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

