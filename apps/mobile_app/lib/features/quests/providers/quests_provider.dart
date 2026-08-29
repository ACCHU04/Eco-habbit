import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/features/quests/data/quests_repository.dart';
import 'package:mobile_app/features/quests/models/quest.dart';

class TodayQuestsNotifier extends AsyncNotifier<List<Quest>> {
  @override
  Future<List<Quest>> build() async {
    return ref.read(questsRepositoryProvider).getTodayQuests();
  }

  Future<QuestProgressResult?> completeQuest(String questId) async {
    try {
      final result = await ref.read(questsRepositoryProvider).updateQuestProgress(questId);
      ref.invalidateSelf();
      return result;
    } catch (_) {
      return null;
    }
  }

  Future<void> reload() async {
    ref.invalidateSelf();
    await future;
  }
}

final todayQuestsProvider =
    AsyncNotifierProvider<TodayQuestsNotifier, List<Quest>>(TodayQuestsNotifier.new);

class AllQuestsNotifier extends AsyncNotifier<List<Quest>> {
  @override
  Future<List<Quest>> build() async {
    return ref.read(questsRepositoryProvider).getAllQuests();
  }

  Future<void> reload() async {
    ref.invalidateSelf();
    await future;
  }
}

final allQuestsProvider =
    AsyncNotifierProvider<AllQuestsNotifier, List<Quest>>(AllQuestsNotifier.new);
