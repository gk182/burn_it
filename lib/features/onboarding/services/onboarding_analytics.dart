abstract interface class OnboardingAnalytics {
  Future<void> track(String event);
}

class NoopOnboardingAnalytics implements OnboardingAnalytics {
  const NoopOnboardingAnalytics();

  @override
  Future<void> track(String event) async {}
}
