import 'package:flutter/material.dart';

class BurnAffordance extends StatelessWidget {
  const BurnAffordance({
    required this.enabled,
    required this.onTriggered,
    super.key,
  });

  final bool enabled;
  final VoidCallback onTriggered;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      container: true,
      enabled: enabled,
      explicitChildNodes: true,
      label: 'Swipe to burn',
      child: GestureDetector(
        onHorizontalDragEnd: enabled
            ? (details) {
                if ((details.primaryVelocity ?? 0) > 0) onTriggered();
              }
            : null,
        child: SizedBox(
          height: 56,
          width: double.infinity,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: enabled
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                'Swipe to burn',
                style: TextStyle(
                  color: enabled
                      ? Theme.of(context).colorScheme.onPrimary
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
