import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../localization/app_localizations.dart';
import '../../../core/utils/responsive.dart';
import 'home_controller.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  String? _lastShownSnack;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(homeControllerProvider);

    // Show snackbar when meme text changes (side effect kept in UI layer).
    if (_lastShownSnack != state.memeSnack) {
      _lastShownSnack = state.memeSnack;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.memeSnack)),
        );
      });
    }

    final padding = Responsive.isDesktop(context) ? 24.0 : 16.0;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.homeTitle)),
      body: ListView(
        padding: EdgeInsets.all(padding),
        children: [
          Text(
            l10n.homeIntro,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.counterLabel, style: Theme.of(context).textTheme.labelLarge),
                  const SizedBox(height: 8),
                  Text(
                    '${state.counter}',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    state.sarcasticMessage,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  if (state.lastSoundAsset.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text(
                      '${l10n.lastSoundPlayed}: ${state.lastSoundAsset}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.assetsNote,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await ref.read(homeControllerProvider.notifier).increment();
        },
        icon: const Icon(Icons.add),
        label: Text(l10n.increment),
      ),
    );
  }
}

