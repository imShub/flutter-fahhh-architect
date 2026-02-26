# Flutter Fahhh Architect

Flutter Fahhh Architect is a VS Code extension that scaffolds opinionated Flutter apps with clean architecture, state management wiring, and safe pubspec patching.

It’s built for teams who want a solid project structure from day one, not another throwaway demo.

---

## Why use this extension?

Setting up a serious Flutter app involves more than running `flutter create`. You need:

- A clear architectural layout
- A consistent state management approach
- Dependencies and assets wired correctly
- A starting point your team can maintain

Flutter Fahhh Architect automates that setup with two production-minded templates and a lean workflow inside VS Code.

---

## Features

- **Single command scaffolding**
  - `Flutter Fahhh: Create App`
  - Prompts for:
    - Destination folder
    - App name (validated as a Flutter package name)
    - Architecture:
      - **Clean Architecture**
      - **MVVM**
    - State management:
      - **Riverpod**
      - **Bloc**
      - **Provider**

- **Lib-only architecture templates**
  - **Clean Architecture template (`flutter-clean`)**
    - `core/` (constants, services, theme, utils)
    - `features/` (home, dashboard, profile, settings)
    - `routes/` for navigation shell
    - `localization/` with simple EN/HI example
    - Riverpod-based state management
  - **MVVM template (`flutter-mvvm`)**
    - `home/model`, `home/viewmodel`, `home/view`
    - Dashboard, profile, settings screens
    - Provider-based state management

- **State management aware**
  - Clean template defaults to **Riverpod**.
  - MVVM template defaults to **Provider**.
  - If you select a different state management option, the extension adds the corresponding dependency alongside the template’s default so the code still compiles and you can migrate gradually.

- **Safe pubspec.yaml patching (no YAML parser)**
  - String-based, newline-normalized editing.
  - Ensures:
    - `dependencies:` section with `flutter: sdk: flutter`.
    - `flutter_localizations: sdk: flutter`.
    - `dio`, `audioplayers`, `url_launcher`.
    - Relevant state management packages.
    - `flutter: assets: - assets/sounds/`.
  - Avoids duplicating existing dependencies or asset entries.

- **CLI guard rails**
  - Verifies `flutter --version` before doing work.
  - Runs `flutter create` and `flutter pub get` via a thin exec wrapper with:
    - 5-minute timeout.
    - Generous output buffer.
    - Cancellation support via `AbortController`.
    - CRLF→LF normalization for clean logs.

- **Structured logging**
  - OutputChannel sections:
    - `==== Flutter Doctor ====`
    - `==== Flutter Create ====`
    - `==== Template Injection ====`
    - `==== Pub Get ====`
  - Major steps automatically show the OutputChannel when scaffolding.

- **Configurable defaults & tone**
  - Default architecture and state management are configurable.
  - Humor mode can be dialed from completely professional to slightly more playful.

---

## Usage

1. Install the extension from the VS Code Marketplace.
2. Ensure the Flutter SDK is installed and `flutter` is available on your PATH.
3. Open VS Code and press **Ctrl/Cmd+Shift+P**, then run:

   ```text
   Flutter Fahhh: Create App
   ```

4. Follow the prompts:
   - Choose a **destination folder**.
   - Enter a **Flutter package name** (e.g. `my_fahhh_app`).
   - Select an **architecture** (Clean Architecture or MVVM).
   - Select **state management** (Riverpod / Bloc / Provider).

5. The extension will:
   - Run `flutter create <appName>`.
   - Replace the generated `lib/` with the selected template’s `lib/`.
   - Patch `pubspec.yaml` to add required dependencies and `assets/sounds/`.
   - Run `flutter pub get`.

6. From there:

   ```bash
   cd <destination>/<appName>
   flutter run
   ```

---

## Configuration

You can adjust defaults and tone via **Settings → Extensions → Flutter Fahhh Architect** or `settings.json`:

```jsonc
{
  "flutterFahhhArchitect.defaultArchitecture": "Clean Architecture", // or "MVVM"
  "flutterFahhhArchitect.defaultStateManagement": "Riverpod",        // or "Bloc", "Provider"
  "flutterFahhhArchitect.humorMode": "balanced"                      // "professional", "balanced", "chaotic"
}
```

### Default architecture

- Controls which architecture appears first and is preselected in the architecture QuickPick.

### Default state management

- Same idea for the state management QuickPick.
- You can still change it manually each time.

### Humor mode

- `professional` – Minimal commentary, straightforward logs.
- `balanced` – Subtle, modern developer humor (default).
- `chaotic` – More playful messages, still work-appropriate.

Humor only affects log messages, never behavior.

---

## Architecture overview

### Clean Architecture template

The `flutter-clean` template uses a layered layout:

- `lib/core/`
  - `constants/` – colors, strings, API endpoints.
  - `services/` – HTTP via Dio, audio via audioplayers.
  - `theme/` – light/dark Material themes.
  - `utils/` – responsive utilities.
- `lib/features/`
  - `home/` – data/domain/presentation, with a Riverpod-based controller and immutable state.
  - `dashboard/`, `profile`, `settings/` – simple screens illustrating feature boundaries.
- `lib/routes/`
  - Main shell with a BottomNavigationBar across four tabs.
- `lib/localization/`
  - Simple EN/HI localization helper for core strings.

This template is intentionally small but directional: it’s meant to be kept and evolved, not discarded.

### MVVM template

The `flutter-mvvm` template follows a ViewModel-driven approach:

- `lib/features/home/model/` – pure state model.
- `lib/features/home/viewmodel/` – `ChangeNotifier` ViewModel.
- `lib/features/home/view/` – UI widgets listening via Provider.
- `lib/features/settings/` – ViewModel controlling `ThemeMode`.
- `lib/routes/` – the same multi-tab shell used in the Clean template.

Both templates normalise where “businessy” decisions live versus view code, and give your team a clean starting point for further refactors.

---

## State management behavior

- **Clean Architecture template**
  - Ships with **Riverpod** as the primary mechanism (Notifier + immutable state).
- **MVVM template**
  - Ships with **Provider** and `ChangeNotifier` ViewModels.

When you select:

- **Riverpod** – the extension ensures `flutter_riverpod` is in `pubspec.yaml`.
- **Provider** – ensures `provider` is present.
- **Bloc** – ensures `flutter_bloc` is present.

The template’s default state package is always added so the template compiles as-is. Choosing another option adds that package as well so you can layer in an alternative state management style without breaking the skeleton.

---

## Humor mode

The extension has a small humor engine used for OutputChannel lines during:

- `flutter create`
- Template injection
- `flutter pub get`
- Error reporting

You control the tone via `flutterFahhhArchitect.humorMode`:

- `professional` – Just the facts.
- `balanced` – Calm, slightly witty logs.
- `chaotic` – Higher energy, still readable for a production team.

If you prefer strictly neutral logs, set the mode to `professional`.

---

## Sound assets

The templates reference two sound assets:

```text
assets/sounds/fahhh.mp3
assets/sounds/bruh.mp3
```

The extension will:

- Add `assets/sounds/` to `flutter.assets` in `pubspec.yaml`.
- Create the `assets/sounds` directory if it doesn’t exist.

You are responsible for:

- Providing the actual `.mp3` files.
- Respecting any licenses for audio content you use.

If you don’t need sounds, you can either remove the asset references from `pubspec.yaml` and the code, or adjust the templates to fit your needs.

---

## Support

**Author:** Shubham Madhav Waghmare

If this extension saves you time or helps keep your `lib/` folder disciplined:

- **GitHub:** [github.com/imShub/flutter-fahhh-architect](https://github.com/imShub/flutter-fahhh-architect) — issues and source
- **LinkedIn:** [linkedin.com/in/imshub](https://linkedin.com/in/imshub)
- **Buy Me a Coffee:** [buymeacoffee.com/imshub](https://buymeacoffee.com/imshub)

You can also run **Flutter Fahhh: Support (Buy Me a Coffee)** from the command palette to open the support link.

Bug reports and improvement ideas are welcome via the [GitHub issue tracker](https://github.com/imShub/flutter-fahhh-architect/issues).

---

## Contributing

Contributions are welcome, provided they keep the extension:

- Lightweight and Node-compatible.
- Friendly to esbuild (no heavy or dynamic dependencies).
- Free of YAML parsers or CLI wrapper libraries such as `execa`.

Good contribution areas include:

- Additional architecture variants.
- Template refinements.
- Safer string-based pubspec editing.
- Tests around pubspec manipulation and CLI behavior.

Open an issue first for larger proposals so the direction stays cohesive.

---

## License

This project is licensed under the [MIT License](./LICENSE).

---

**Flutter Fahhh Architect** by [Shubham Madhav Waghmare](https://github.com/imShub).  
[GitHub](https://github.com/imShub/flutter-fahhh-architect) · [LinkedIn](https://linkedin.com/in/imshub) · [Buy Me a Coffee](https://buymeacoffee.com/imshub)