import 'package:flutter_test/flutter_test.dart';
import 'package:burn_it/domain/usecases/validate_release_text.dart';

void main() {
  const validator = ValidateReleaseText();

  test('T03-2: whitespace-only text cannot be released', () {
    expect(validator('   '), isNotNull);
  });

  test('T03-3: one and 500 characters are accepted', () {
    expect(validator('a'), isNull);
    expect(validator('a' * 500), isNull);
  });

  test('T03-4: text above 500 characters is rejected', () {
    expect(validator('a' * 501), isNotNull);
  });
}
