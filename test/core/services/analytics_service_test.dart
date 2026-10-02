import 'package:flutter_test/flutter_test.dart';
import 'package:burn_it/core/services/analytics_service.dart';

void main() {
  test('T05-3: analytics rejects events outside the allowlist', () async {
    const analytics = NoopAnalyticsService();

    await expectLater(
      analytics.track('private_text_was_here'),
      throwsArgumentError,
    );
  });

  test('T05-3: analytics accepts approved events without a payload', () async {
    const analytics = NoopAnalyticsService();

    await analytics.track('support_opened');
  });
}
