import 'package:flutter_test/flutter_test.dart';
import 'package:burn_it/core/logging/app_logger.dart';

void main() {
  test('T01-5: redacts text-like values and exception details', () {
    final messages = <String>[];
    final logger = AppLogger(sink: messages.add);

    logger.error(
      'burn failed',
      error: StateError('private user sentence'),
      context: {'text': 'private user sentence', 'route': '/write'},
    );

    expect(messages, hasLength(1));
    expect(messages.single, contains('[REDACTED]'));
    expect(messages.single, isNot(contains('private user sentence')));
  });
}
