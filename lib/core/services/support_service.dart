import 'package:url_launcher/url_launcher.dart';

import 'analytics_service.dart';

abstract interface class SupportService {
  Future<void> open();
}

class UrlLauncherSupportService implements SupportService {
  UrlLauncherSupportService(this.analytics);

  final AnalyticsService analytics;
  static final _supportUri = Uri.parse('https://findahelpline.com/');

  @override
  Future<void> open() async {
    await analytics.track('support_opened');
    final launched = await launchUrl(
      _supportUri,
      mode: LaunchMode.externalApplication,
    );
    if (!launched) {
      throw StateError('Support resource could not be opened');
    }
  }
}
