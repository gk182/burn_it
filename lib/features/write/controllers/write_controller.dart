import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/logging/app_logger.dart';
import '../../../domain/usecases/validate_release_text.dart';
import '../data/prompt_catalog.dart';
import '../models/prompt_model.dart';

class ReleaseDraft {
  const ReleaseDraft({
    required this.text,
    required this.promptId,
    required this.createdAt,
  });

  final String text;
  final String? promptId;
  final DateTime createdAt;
}

enum WriteStatus { editing, requestingBurn, error }

class WriteController extends GetxController {
  WriteController({
    this.prompts = PromptCatalog.items,
    required this.onBurnRequested,
    this.validator = const ValidateReleaseText(),
    this.logger = const AppLogger(),
  }) {
    currentPrompt.value = prompts.first;
  }

  static const maxTextLength = 500;

  final Future<void> Function(ReleaseDraft draft) onBurnRequested;
  final List<PromptModel> prompts;
  final ValidateReleaseText validator;
  final AppLogger logger;
  final TextEditingController textController = TextEditingController();
  final draftText = ''.obs;
  final currentPrompt = Rxn<PromptModel>();
  final status = WriteStatus.editing.obs;
  final errorMessage = RxnString();

  int _promptIndex = 0;

  bool get canBurn =>
      status.value == WriteStatus.editing && validator(draftText.value) == null;

  void updateText(String value) {
    final limited = value.length > maxTextLength
        ? value.substring(0, maxTextLength)
        : value;
    draftText.value = limited;
    if (textController.text != limited) {
      textController.value = textController.value.copyWith(
        text: limited,
        selection: TextSelection.collapsed(offset: limited.length),
      );
    }
    if (status.value == WriteStatus.error) {
      status.value = WriteStatus.editing;
      errorMessage.value = null;
    }
  }

  void refreshPrompt() {
    if (prompts.length < 2) return;
    _promptIndex = (_promptIndex + 1) % prompts.length;
    currentPrompt.value = prompts[_promptIndex];
  }

  Future<void> requestBurn() async {
    if (!canBurn) return;

    status.value = WriteStatus.requestingBurn;
    errorMessage.value = null;
    final draft = ReleaseDraft(
      text: draftText.value.trim(),
      promptId: currentPrompt.value?.id,
      createdAt: DateTime.now(),
    );

    try {
      await onBurnRequested(draft);
    } catch (error, stackTrace) {
      logger.error('burn_request_failed', error: error, stackTrace: stackTrace);
      status.value = WriteStatus.error;
      errorMessage.value = 'We could not start the release. Please try again.';
    }
  }

  void clearDraft() {
    draftText.value = '';
    textController.clear();
  }

  @override
  void onClose() {
    clearDraft();
    textController.dispose();
    currentPrompt.value = null;
    super.onClose();
  }
}
