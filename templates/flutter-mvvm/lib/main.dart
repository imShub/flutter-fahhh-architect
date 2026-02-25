/*
  Flutter Fahhh Architect — MVVM + Provider

  Support the Fahhh:
  https://www.buymeacoffee.com/
*/

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'core/constants/app_strings.dart';
import 'core/services/sound_service.dart';
import 'core/services/url_service.dart';
import 'core/theme/app_theme.dart';
import 'features/home/viewmodel/home_view_model.dart';
import 'features/settings/settings_view_model.dart';
import 'routes/app_routes.dart';

void main() {
  debugPrint('Injecting SOLID principles...');
  debugPrint('Eliminating spaghetti code...');
  debugPrint('Fahhh injection complete 🚀');

  runApp(const FahhhApp());
}

class FahhhApp extends StatelessWidget {
  const FahhhApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<SoundService>(create: (_) => SoundService()),
        Provider<UrlService>(create: (_) => UrlService()),
        ChangeNotifierProvider<SettingsViewModel>(create: (_) => SettingsViewModel()),
        ChangeNotifierProxyProvider<SoundService, HomeViewModel>(
          create: (ctx) => HomeViewModel(soundService: ctx.read<SoundService>()),
          update: (ctx, sound, prev) => prev ?? HomeViewModel(soundService: sound),
        ),
      ],
      child: Consumer<SettingsViewModel>(
        builder: (context, settings, _) {
          return MaterialApp(
            title: AppStrings.appTitle,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            themeMode: settings.themeMode,
            onGenerateRoute: AppRoutes.onGenerateRoute,
            initialRoute: AppRoutes.root,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en'),
              Locale('hi'),
            ],
          );
        },
      ),
    );
  }
}

