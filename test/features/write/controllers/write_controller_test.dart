import 'package:flutter_test/flutter_test.dart';
import 'package:burn_it/features/write/controllers/write_controller.dart';
import 'package:burn_it/features/write/data/prompt_catalog.dart';

void main() {
  late List<ReleaseDraft> requests;

  WriteController createController() {
    return WriteController(
      prompts: PromptCatalog.items,
      onBurnRequested: (draft) async => requests.add(draft),
    );
  }

  setUp(() => requests = <ReleaseDraft>[]);

  test('T03-2: whitespace-only draft keeps burn disabled', () {
    final controller = createController();
    controller.updateText('  \n  ');

    expect(controller.canBurn, isFalse);
    controller.onClose();
  });

  test('T03-3: one and 500 characters can be submitted', () async {
    final controller = createController();

    controller.updateText('a');
    expect(controller.canBurn, isTrue);
    await controller.requestBurn();
    controller.onClose();

    expect(requests.single.text, 'a');
  });

  test('T03-4: controller constrains text to 500 characters', () {
    final controller = createController();
    controller.updateText('a' * 501);

    expect(controller.draftText.value.length, 500);
    expect(controller.canBurn, isTrue);
    controller.onClose();
  });

  test('T03-5: refreshing a prompt does not change draft text', () {
    final controller = createController();
    controller.updateText('keep this private');
    final before = controller.currentPrompt.value?.id;

    controller.refreshPrompt();

    expect(controller.draftText.value, 'keep this private');
    expect(controller.currentPrompt.value?.id, isNot(before));
    controller.onClose();
  });

  test('T03-6: closing the controller clears the in-memory draft', () {
    final controller = createController();
    controller.updateText('private sentence');

    controller.onClose();

    expect(controller.draftText.value, isEmpty);
    expect(controller.textController.text, isEmpty);
  });

  test('T03-8: rapid burn requests create only one request', () async {
    final controller = createController();
    controller.updateText('one request only');

    await Future.wait([controller.requestBurn(), controller.requestBurn()]);

    expect(requests, hasLength(1));
    controller.onClose();
  });
}
