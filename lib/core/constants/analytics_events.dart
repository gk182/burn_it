abstract final class AnalyticsEvents {
  static const onboardingCompleted = 'onboarding_completed';
  static const writeStarted = 'write_started';
  static const burnStarted = 'burn_started';
  static const burnCompleted = 'burn_completed';
  static const writeAnother = 'write_another';
  static const supportOpened = 'support_opened';

  static const all = <String>{
    onboardingCompleted,
    writeStarted,
    burnStarted,
    burnCompleted,
    writeAnother,
    supportOpened,
  };
}
