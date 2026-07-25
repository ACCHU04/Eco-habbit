import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/core/services/api_client.dart';
import 'package:mobile_app/features/auth/providers/auth_provider.dart';
import 'package:mobile_app/features/quests/models/quest.dart';

class QuestsRepository {
  final ApiClient _api;
  QuestsRepository(this._api);

  Future<List<Quest>> getTodayQuests() async {
    final response = await _api.get('/quests/today');
    final list = response.data['data'] as List<dynamic>;
    return list.map((q) => Quest.fromJson(q as Map<String, dynamic>)).toList();
  }

  Future<List<Quest>> getAllQuests() async {
    final response = await _api.get('/quests');
    final list = response.data['data'] as List<dynamic>;
    return list.map((q) => Quest.fromJson(q as Map<String, dynamic>)).toList();
  }

  Future<QuestProgressResult> updateQuestProgress(String questId) async {
    final response = await _api.post('/quests/$questId/progress');
    return QuestProgressResult.fromJson(response.data['data']);
  }

  Future<Map<String, dynamic>> getLevelThresholds() async {
    final response = await _api.get('/quests/levels');
    return response.data['data'] as Map<String, dynamic>;
  }
}

final questsRepositoryProvider = Provider((ref) {
  return QuestsRepository(ref.read(apiClientProvider));
});
