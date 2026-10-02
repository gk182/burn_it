import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../app/theme/app_spacing.dart';
import '../controllers/write_controller.dart';

class PaperSurface extends StatelessWidget {
  const PaperSurface({
    required this.controller,
    required this.onChanged,
    super.key,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: TextField(
          controller: controller,
          onChanged: onChanged,
          maxLines: 8,
          minLines: 5,
          maxLength: WriteController.maxTextLength,
          maxLengthEnforcement: MaxLengthEnforcement.enforced,
          textInputAction: TextInputAction.newline,
          decoration: const InputDecoration(
            hintText: 'Write what you are ready to put down.',
            border: InputBorder.none,
            counterText: '',
          ),
        ),
      ),
    );
  }
}
