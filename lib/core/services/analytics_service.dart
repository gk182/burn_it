import '../constants/analytics_events.dart';

abstract interface class AnalyticsService {
  Future<void> track(String event);
}

class NoopAnalyticsService implements AnalyticsService {
  const NoopAnalyticsService();

  @override
  Future<void> track(String event) async {
    if (!AnalyticsEvents.all.contains(event)) {
      throw ArgumentError.value(event, 'event', 'Event is not allowlisted');
    }
  }
}
