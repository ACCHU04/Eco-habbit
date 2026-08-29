import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/core/services/api_client.dart';
import 'package:mobile_app/features/auth/providers/auth_provider.dart';
import 'package:mobile_app/features/passport/models/passport_data.dart';

class PassportRepository {
  final ApiClient _api;
  PassportRepository(this._api);

  Future<ImpactData> getImpact() async {
    final response = await _api.get('/passport/impact');
    return ImpactData.fromJson(response.data['data']);
  }

  Future<List<TimelineEntry>> getTimeline({int page = 1, int limit = 20}) async {
    final response = await _api.get('/passport/timeline', queryParameters: {
      'page': page,
      'limit': limit,
    });
    final list = response.data['data'] as List<dynamic>;
    return list.map((t) => TimelineEntry.fromJson(t as Map<String, dynamic>)).toList();
  }

  Future<StreakData> getStreak() async {
    final response = await _api.get('/passport/streak');
    return StreakData.fromJson(response.data['data']);
  }
}

final passportRepositoryProvider = Provider((ref) {
  return PassportRepository(ref.read(apiClientProvider));
});
