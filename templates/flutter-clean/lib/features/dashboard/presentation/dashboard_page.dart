import 'package:flutter/material.dart';

import '../../../localization/app_localizations.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.dashboardTitle)),
      body: Center(
        child: Text(
          l10n.dashboardBody,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

