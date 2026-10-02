class ValidateReleaseText {
  const ValidateReleaseText();

  String? call(String value) {
    final length = value.trim().length;
    if (length == 0) return 'Write something before you burn it.';
    if (length > 500) return 'Keep it under 500 characters.';
    return null;
  }
}
