import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/utils/responsive.dart';
import '../viewmodel/home_view_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _lastShownSnack;

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<HomeViewModel>();
    final state = vm.state;

    if (_lastShownSnack != state.memeSnack) {
      _lastShownSnack = state.memeSnack;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.memeSnack)));
      });
    }

    final padding = Responsive.isDesktop(context) ? 24.0 : 16.0;

    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: ListView(
        padding: EdgeInsets.all(padding),
        children: [
          Text(
            'Counter demo, but with a Fahhh twist.',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Counter value', style: Theme.of(context).textTheme.labelLarge),
                  const SizedBox(height: 8),
                  Text('${state.counter}', style: Theme.of(context).textTheme.displaySmall),
                  const SizedBox(height: 12),
                  Text(state.sarcasticMessage, style: Theme.of(context).textTheme.bodyLarge),
                  if (state.lastSoundAsset.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text('Last sound: ${state.lastSoundAsset}', style: Theme.of(context).textTheme.bodySmall),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Assets referenced: assets/sounds/fahhh.mp3, assets/sounds/bruh.mp3',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async => vm.increment(),
        icon: const Icon(Icons.add),
        label: const Text('Increment'),
      ),
    );
  }
}

