import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Repository for handling user-specific local security and compliance state.
class UserRepository {
  final _storage = const FlutterSecureStorage();
  static const _ageVerifiedKey = 'is_age_verified';

  Future<bool> isAgeVerified() async {
    final verified = await _storage.read(key: _ageVerifiedKey);
    return verified == 'true';
  }

  Future<void> setAgeVerified(bool value) async {
    await _storage.write(key: _ageVerifiedKey, value: value.toString());
  }
}

/// Provider for user-related state management.
final userRepositoryProvider = Provider<UserRepository>((ref) => UserRepository());

/// Async notifier for age verification status.
final ageVerificationStatusProvider = FutureProvider<bool>((ref) async {
  final repo = ref.watch(userRepositoryProvider);
  return repo.isAgeVerified();
});
