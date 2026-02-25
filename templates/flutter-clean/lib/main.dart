/*
  Flutter Fahhh Architect — Clean Architecture + Riverpod

  Support the Fahhh:
  https://www.buymeacoffee.com/
*/

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/constants/app_strings.dart';
import 'core/theme/app_theme.dart';
import 'features/settings/presentation/settings_page.dart';
import 'localization/app_localizations.dart';
import 'routes/app_routes.dart';

void main() {
  // Humorous logs (also mirrored by the VS Code extension when scaffolding).
  debugPrint('Injecting SOLID principles...');
  debugPrint('Eliminating spaghetti code...');
  debugPrint('Fahhh injection complete 🚀');

  runApp(const ProviderScope(child: FahhhApp()));
}

class FahhhApp extends ConsumerWidget {
  const FahhhApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      title: AppStrings.appTitle,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode,
      onGenerateRoute: AppRoutes.onGenerateRoute,
      initialRoute: AppRoutes.root,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}

