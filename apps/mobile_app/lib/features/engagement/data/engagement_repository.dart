import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/core/services/api_client.dart';
import 'package:mobile_app/features/auth/providers/auth_provider.dart';
import 'package:mobile_app/features/engagement/models/leaderboard_models.dart';
import 'package:mobile_app/features/engagement/models/hostel_models.dart';
import 'package:mobile_app/features/engagement/models/challenge_models.dart';
import 'package:mobile_app/features/engagement/models/achievement_models.dart';

class EngagementRepository {
  final ApiClient _api;
  EngagementRepository(this._api);

  // ── Leaderboards ──

  Future<List<LeaderboardEntry>> getFilteredLeaderboard({
    String filter = 'campus',
    String? value,
    int limit = 50,
  }) async {
    final response = await _api.get(
      '/leaderboards',
      queryParameters: {'filter': filter, 'value': value, 'limit': limit},
    );
    final data = response.data['data'] as List<dynamic>;
    return data
        .map((e) => LeaderboardEntry.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<LeaderboardEntry>> getFriendLeaderboard({int limit = 50}) async {
    final response = await _api.get(
      '/leaderboards/friends',
      queryParameters: {'limit': limit},
    );
    final data = response.data['data'] as List<dynamic>;
    return data
        .map((e) => LeaderboardEntry.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<HostelEntry>> getHostelLeaderboard({
    String? college,
    int limit = 50,
  }) async {
    final response = await _api.get(
      '/leaderboards/hostels',
      queryParameters: {'college': college, 'limit': limit},
    );
    final data = response.data['data'] as List<dynamic>;
    return data
        .map((e) => HostelEntry.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<LeaderboardEntry>> getPeriodLeaderboard({
    String period = 'weekly',
    String filter = 'campus',
    String? value,
    int limit = 50,
  }) async {
    final response = await _api.get(
      '/leaderboards/period/$period',
      queryParameters: {'filter': filter, 'value': value, 'limit': limit},
    );
    final data = response.data['data'] as List<dynamic>;
    return data
        .map((e) => LeaderboardEntry.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // ── Hostels ──

  Future<List<Hostel>> getHostels({String? college}) async {
    final response = await _api.get(
      '/hostels',
      queryParameters: {'college': college},
    );
    final data = response.data['data'] as List<dynamic>;
    return data.map((e) => Hostel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> joinHostel(String hostelName) async {
    await _api.post('/hostels/join', data: {'hostel_name': hostelName});
  }

  Future<List<HostelBattle>> getBattles({String? hostelId}) async {
    final response = await _api.get(
      '/hostels/battles/all',
      queryParameters: {'hostel_id': hostelId},
    );
    final data = response.data['data'] as List<dynamic>;
    return data
        .map((e) => HostelBattle.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<HostelBattle> createBattle({
    required String title,
    required String description,
    required String hostelerId,
    required String challengerId,
    String metric = 'total_score',
    int durationDays = 7,
  }) async {
    final response = await _api.post('/hostels/battles/create', data: {
      'title': title,
      'description': description,
      'hosteler_id': hostelerId,
      'hosteler_challenger': challengerId,
      'metric': metric,
      'duration_days': durationDays,
    });
    return HostelBattle.fromJson(response.data['data']);
  }

  // ── Challenges / Friends ──

  Future<List<Friend>> getFriends() async {
    final response = await _api.get('/challenges/friends');
    final data = response.data['data'] as List<dynamic>;
    return data.map((e) => Friend.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> sendFriendRequest(String addresseeId) async {
    await _api.post(
      '/challenges/friends/request',
      data: {'addressee_id': addresseeId},
    );
  }

  Future<void> respondToFriendRequest(String friendshipId, bool accept) async {
    await _api.put(
      '/challenges/friends/respond',
      data: {'friendship_id': friendshipId, 'accept': accept},
    );
  }

  Future<void> removeFriend(String friendshipId) async {
    await _api.delete('/challenges/friends/$friendshipId');
  }

  Future<List<FriendRequest>> getPendingRequests() async {
    final response = await _api.get('/challenges/friends/pending');
    final data = response.data['data'] as List<dynamic>;
    return data
        .map((e) => FriendRequest.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<FriendChallenge> createChallenge({
    required String challengeeId,
    required String title,
    required String description,
    required String goalAction,
    int goalCount = 1,
    int durationDays = 7,
    int xpReward = 100,
    int coinReward = 25,
  }) async {
    final response = await _api.post('/challenges/create', data: {
      'challengee_id': challengeeId,
      'title': title,
      'description': description,
      'goal_action': goalAction,
      'goal_count': goalCount,
      'duration_days': durationDays,
      'xp_reward': xpReward,
      'coin_reward': coinReward,
    });
    return FriendChallenge.fromJson(response.data['data']);
  }

  Future<void> respondToChallenge(String challengeId, bool accept) async {
    await _api.put(
      '/challenges/$challengeId/respond',
      data: {'accept': accept},
    );
  }

  Future<List<FriendChallenge>> getMyChallenges({String? status}) async {
    final response = await _api.get(
      '/challenges/my',
      queryParameters: {'status': status},
    );
    final data = response.data['data'] as List<dynamic>;
    return data
        .map((e) => FriendChallenge.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> updateChallengeProgress(String challengeId, {int increment = 1}) async {
    await _api.put(
      '/challenges/$challengeId/progress',
      data: {'increment': increment},
    );
  }

  // ── Achievements ──

  Future<List<Achievement>> getAchievements() async {
    final response = await _api.get('/rewards/achievements');
    final data = response.data['data'] as List<dynamic>;
    return data
        .map((e) => Achievement.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}

final engagementRepositoryProvider = Provider((ref) {
  return EngagementRepository(ref.read(apiClientProvider));
});
