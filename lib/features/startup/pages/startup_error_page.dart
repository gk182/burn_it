import 'package:flutter/material.dart';

class StartupErrorPage extends StatelessWidget {
  const StartupErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(child: Center(child: Text('Unable to start Burn It'))),
    );
  }
}
