import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Profile screen: because every app needs one.',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

