import 'dart:async';

import 'package:flutter/material.dart';

import '../../../app/theme/app_spacing.dart';

class SafetyPage extends StatefulWidget {
  const SafetyPage({required this.onSupport, super.key});

  final Future<void> Function() onSupport;

  @override
  State<SafetyPage> createState() => _SafetyPageState();
}

class _SafetyPageState extends State<SafetyPage> {
  bool _isOpening = false;
  String? _error;

  Future<void> _openSupport() async {
    if (_isOpening) return;
    setState(() {
      _isOpening = true;
      _error = null;
    });
    try {
      await widget.onSupport();
    } catch (_) {
      if (!mounted) return;
      setState(() => _error = 'Support resources could not be opened.');
    } finally {
      if (mounted) setState(() => _isOpening = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Support')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Text(
            'Need immediate support?',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: AppSpacing.md),
          const Text(
            'Burn It is not professional care. If you may be in immediate danger, '
            'contact local emergency services or a trusted person now.',
          ),
          const SizedBox(height: AppSpacing.lg),
          FilledButton(
            onPressed: _isOpening ? null : _openSupport,
            child: Text(_isOpening ? 'Opening...' : 'Find support'),
          ),
          if (_error != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              _error!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ],
        ],
      ),
    );
  }
}
