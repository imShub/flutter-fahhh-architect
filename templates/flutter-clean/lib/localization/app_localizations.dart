import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static const supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi'),
  ];

  static AppLocalizations of(BuildContext context) {
    final l10n = Localizations.of<AppLocalizations>(context, AppLocalizations);
    assert(l10n != null, 'AppLocalizations not found in widget tree.');
    return l10n!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  static const _strings = <String, Map<String, String>>{
    'en': {
      'appTitle': 'Flutter Fahhh',
      'homeTitle': 'Home',
      'dashboardTitle': 'Dashboard',
      'profileTitle': 'Profile',
      'settingsTitle': 'Settings',
      'homeIntro': 'Behold: a counter demo, but with a Fahhh twist.',
      'counterLabel': 'Counter value',
      'increment': 'Increment',
      'lastSoundPlayed': 'Last sound',
      'assetsNote': 'Assets referenced: assets/sounds/fahhh.mp3, assets/sounds/bruh.mp3',
      'dashboardBody': 'Dashboards are where charts go to look important.',
      'profileBody': 'Profile screen: because every app needs one.',
      'themeToggleTitle': 'Dark mode',
      'themeLight': 'Light',
      'themeDark': 'Dark',
      'themeSystem': 'System',
      'supportSubtitle': 'Fuel the Fahhh. Open Buy Me a Coffee.',
      'couldNotOpenLink': 'Could not open link.',
      'settingsFooter': 'Tip: Keep layers clean. If it feels like spaghetti, it probably is.',
      'goToHome': 'Go to Home',
      'navHome': 'Home',
      'navDashboard': 'Dashboard',
      'navProfile': 'Profile',
      'navSettings': 'Settings',
    },
    'hi': {
      'appTitle': 'Flutter Fahhh',
      'homeTitle': 'होम',
      'dashboardTitle': 'डैशबोर्ड',
      'profileTitle': 'प्रोफ़ाइल',
      'settingsTitle': 'सेटिंग्स',
      'homeIntro': 'यह एक काउंटर डेमो है — लेकिन “Fahhh” स्टाइल में।',
      'counterLabel': 'काउंटर वैल्यू',
      'increment': 'बढ़ाएँ',
      'lastSoundPlayed': 'आख़िरी साउंड',
      'assetsNote': 'Assets: assets/sounds/fahhh.mp3, assets/sounds/bruh.mp3',
      'dashboardBody': 'डैशबोर्ड: जहाँ चार्ट गंभीर दिखते हैं।',
      'profileBody': 'प्रोफ़ाइल स्क्रीन: क्योंकि ज़रूरी है।',
      'themeToggleTitle': 'डार्क मोड',
      'themeLight': 'लाइट',
      'themeDark': 'डार्क',
      'themeSystem': 'सिस्टम',
      'supportSubtitle': 'Fahhh को फ़्यूल करें। Buy Me a Coffee खोलें।',
      'couldNotOpenLink': 'लिंक नहीं खुल पाया।',
      'settingsFooter': 'टिप: लेयर्स साफ़ रखें। स्पेगेटी से बचें।',
      'goToHome': 'होम जाएँ',
      'navHome': 'होम',
      'navDashboard': 'डैशबोर्ड',
      'navProfile': 'प्रोफ़ाइल',
      'navSettings': 'सेटिंग्स',
    },
  };

  String _t(String key) => _strings[locale.languageCode]?[key] ?? _strings['en']![key] ?? key;

  String get appTitle => _t('appTitle');
  String get homeTitle => _t('homeTitle');
  String get dashboardTitle => _t('dashboardTitle');
  String get profileTitle => _t('profileTitle');
  String get settingsTitle => _t('settingsTitle');
  String get homeIntro => _t('homeIntro');
  String get counterLabel => _t('counterLabel');
  String get increment => _t('increment');
  String get lastSoundPlayed => _t('lastSoundPlayed');
  String get assetsNote => _t('assetsNote');
  String get dashboardBody => _t('dashboardBody');
  String get profileBody => _t('profileBody');
  String get themeToggleTitle => _t('themeToggleTitle');
  String get themeLight => _t('themeLight');
  String get themeDark => _t('themeDark');
  String get themeSystem => _t('themeSystem');
  String get supportSubtitle => _t('supportSubtitle');
  String get couldNotOpenLink => _t('couldNotOpenLink');
  String get settingsFooter => _t('settingsFooter');
  String get goToHome => _t('goToHome');
  String get navHome => _t('navHome');
  String get navDashboard => _t('navDashboard');
  String get navProfile => _t('navProfile');
  String get navSettings => _t('navSettings');
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => AppLocalizations.supportedLocales.any((l) => l.languageCode == locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) => SynchronousFuture(AppLocalizations(locale));

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) => false;
}

