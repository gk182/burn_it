import 'package:flutter/material.dart';

import '../../../app/theme/app_spacing.dart';
import '../models/prompt_model.dart';

class PromptHeader extends StatelessWidget {
  const PromptHeader({
    required this.prompt,
    required this.onRefresh,
    super.key,
  });

  final PromptModel? prompt;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            prompt?.text ?? '',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        IconButton(
          onPressed: onRefresh,
          tooltip: 'Change prompt',
          icon: const Icon(Icons.refresh),
          padding: const EdgeInsets.all(AppSpacing.xs),
          constraints: const BoxConstraints.tightFor(width: 44, height: 44),
        ),
      ],
    );
  }
}
