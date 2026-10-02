import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/repositories/release_counter_repository.dart';

class ReleaseCounterRepositoryImpl implements ReleaseCounterRepository {
  ReleaseCounterRepositoryImpl(this._preferences);

  static const _key = 'release_count_v1';
  final SharedPreferences _preferences;

  @override
  Future<void> increment() async {
    final current = _preferences.getInt(_key) ?? 0;
    await _preferences.setInt(_key, current + 1);
  }
}
