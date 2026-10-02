abstract interface class HapticService {
  Future<void> impact();
}

class NoopHapticService implements HapticService {
  const NoopHapticService();

  @override
  Future<void> impact() async {}
}
