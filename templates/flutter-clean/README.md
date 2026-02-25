# Flutter Fahhh Architect — Clean Architecture (Riverpod)

This template is designed to be **copied into a freshly-created Flutter project** (after running `flutter create <appName>`).  
It is **not** a full Flutter project on its own — it contains only:

- `lib/`
- `pubspec.yaml` (dependency/asset reference snippet)
- `README.md`

## What you get

- **Clean Architecture-ish** separation (core vs feature layers, domain/data/presentation)
- **Riverpod** state management
- **Dio** API abstraction (`ApiService`)
- **audioplayers** sound abstraction (`SoundService`)
- **BottomNavigationBar** with 4 screens (Home/Dashboard/Profile/Settings)
- **Light/Dark theme toggle**
- **Localization** example (English + Hindi)
- **Named routes**
- **Responsive helper**
- A sarcastic counter demo with meme SnackBars and random “Fahhh” sounds

## How to use with this VS Code extension

1. Run the command: **Flutter Fahhh: Create App**
2. Pick **Clean Architecture**
3. Pick **Riverpod**
4. The extension will:
   - run `flutter create <appName>`
   - replace your generated `lib/` with this template’s `lib/`

## Pubspec merge

This template includes a `pubspec.yaml` that you should **merge** into the generated project’s `pubspec.yaml`.

At minimum, merge:

- dependencies:
  - `flutter_riverpod`
  - `dio`
  - `audioplayers`
  - `url_launcher`
  - `flutter_localizations` (SDK)
- assets:
  - `assets/sounds/`

Then run:

```bash
flutter pub get
```

## Assets you must add

Create these files in your Flutter app (real audio is up to you):

- `assets/sounds/fahhh.mp3`
- `assets/sounds/bruh.mp3`

## Support (Buy Me a Coffee)

If this template saved you from spaghetti code, consider supporting:

- Buy me a coffee: `https://www.buymeacoffee.com/`

