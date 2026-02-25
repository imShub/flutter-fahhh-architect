import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../localization/app_localizations.dart';
import '../../../core/constants/app_strings.dart';
import '../../../routes/app_routes.dart';

final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  static const _supportUrl = 'https://www.buymeacoffee.com/';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final themeMode = ref.watch(themeModeProvider);

    final isDark = themeMode == ThemeMode.dark;
    final isLight = themeMode == ThemeMode.light;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settingsTitle),
        actions: [
          IconButton(
            tooltip: l10n.goToHome,
            onPressed: () => Navigator.of(context).pushNamed(AppRoutes.root),
            icon: const Icon(Icons.home_outlined),
          ),
        ],
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: Text(l10n.themeToggleTitle),
            subtitle: Text(isDark ? l10n.themeDark : (isLight ? l10n.themeLight : l10n.themeSystem)),
            value: isDark,
            onChanged: (v) => ref.read(themeModeProvider.notifier).state = v ? ThemeMode.dark : ThemeMode.light,
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.coffee_outlined),
            title: const Text(AppStrings.supportTitle),
            subtitle: Text(l10n.supportSubtitle),
            onTap: () async {
              final uri = Uri.parse(_supportUrl);
              final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
              if (!ok && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.couldNotOpenLink)),
                );
              }
            },
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              l10n.settingsFooter,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}

