typedef LogSink = void Function(String message);

class AppLogger {
  const AppLogger({this._sink});

  final LogSink? _sink;

  void error(
    String event, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, Object?> context = const <String, Object?>{},
  }) {
    final safeContext = <String, Object?>{};
    for (final entry in context.entries) {
      final key = entry.key.toLowerCase();
      safeContext[entry.key] = _isSensitiveKey(key)
          ? '[REDACTED]'
          : entry.value?.toString() ?? 'null';
    }

    final message = StringBuffer('event=$event');
    if (safeContext.isNotEmpty) message.write(' context=$safeContext');
    if (error != null) message.write(' error_type=${error.runtimeType}');
    if (stackTrace != null) message.write(' stack=true');
    _sink?.call(message.toString());
  }

  static bool _isSensitiveKey(String key) {
    return key.contains('text') ||
        key.contains('prompt') ||
        key.contains('content') ||
        key.contains('body') ||
        key.contains('message');
  }
}
