import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/core/services/api_client.dart';
import 'package:mobile_app/features/auth/providers/auth_provider.dart';
import 'package:mobile_app/features/profile/models/user_stats.dart';

class ProfileRepository {
  final ApiClient _api;
  ProfileRepository(this._api);

  Future<UserStats> getUserStats(String userId) async {
    final response = await _api.get('/users/$userId/stats');
    return UserStats.fromJson(response.data['data']);
  }
}

final profileRepositoryProvider = Provider((ref) {
  return ProfileRepository(ref.read(apiClientProvider));
});
