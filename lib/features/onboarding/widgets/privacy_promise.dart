import 'package:flutter/material.dart';

import '../../../app/theme/app_spacing.dart';

class PrivacyPromise extends StatelessWidget {
  const PrivacyPromise({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'No account. No history.',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Your words stay here while you write. They disappear when you burn them.',
          style: theme.textTheme.bodyLarge,
        ),
      ],
    );
  }
}
