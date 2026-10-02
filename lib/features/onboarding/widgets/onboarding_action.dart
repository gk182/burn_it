import 'package:flutter/material.dart';

class OnboardingAction extends StatelessWidget {
  const OnboardingAction({
    required this.label,
    required this.semanticLabel,
    required this.onPressed,
    this.isPrimary = false,
    super.key,
  });

  final String label;
  final String semanticLabel;
  final VoidCallback? onPressed;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    final button = isPrimary
        ? FilledButton(onPressed: onPressed, child: Text(label))
        : TextButton(onPressed: onPressed, child: Text(label));

    return Semantics(
      button: true,
      container: true,
      label: semanticLabel,
      child: button,
    );
  }
}
