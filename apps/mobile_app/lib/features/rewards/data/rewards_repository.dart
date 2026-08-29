import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/core/services/api_client.dart';
import 'package:mobile_app/features/auth/providers/auth_provider.dart';
import 'package:mobile_app/features/rewards/models/reward_models.dart';

class RewardsRepository {
  final ApiClient _api;
  RewardsRepository(this._api);

  Future<UserPoints> getUserPoints() async {
    final response = await _api.get('/rewards/points');
    return UserPoints.fromJson(response.data);
  }

  Future<PaginatedPointsHistory> getPointsHistory({int page = 1, int limit = 20}) async {
    final response = await _api.get('/rewards/points/history', queryParameters: {'page': page, 'limit': limit});
    final data = response.data['data'] as List<dynamic>;
    final pagination = response.data['pagination'] as Map<String, dynamic>;
    return PaginatedPointsHistory(
      items: data.map((e) => PointsHistoryItem.fromJson(e)).toList(),
      page: pagination['page'] as int? ?? page,
      limit: pagination['limit'] as int? ?? limit,
      total: pagination['total'] as int? ?? 0,
      totalPages: pagination['total_pages'] as int? ?? 1,
    );
  }

  Future<List<Badge>> getBadges() async {
    final response = await _api.get('/rewards/badges');
    final data = response.data['data'] as List<dynamic>;
    return data.map((e) => Badge.fromJson(e)).toList();
  }

  Future<List<LeaderboardEntry>> getLeaderboard({int limit = 50}) async {
    final response = await _api.get('/rewards/leaderboard', queryParameters: {'limit': limit});
    final data = response.data['data'] as List<dynamic>;
    return data.asMap().entries.map((e) => LeaderboardEntry.fromJson(e.value, rank: e.key + 1)).toList();
  }
}

final rewardsRepositoryProvider = Provider((ref) {
  return RewardsRepository(ref.read(apiClientProvider));
});
