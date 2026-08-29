import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/features/diy/data/diy_repository.dart';
import 'package:mobile_app/features/diy/models/diy_project_model.dart';
import 'package:mobile_app/features/diy/models/diy_filters.dart';

final diyFilterProvider = StateProvider<DiyFilters>((ref) => const DiyFilters());

class DiyProjectsNotifier extends AsyncNotifier<PaginatedProjects> {
  @override
  Future<PaginatedProjects> build() async {
    final filters = ref.watch(diyFilterProvider);
    return ref.read(diyRepositoryProvider).getProjects(filters: filters);
  }

  Future<void> loadMore() async {
    final current = state.valueOrNull;
    if (current == null || !current.hasMore) return;
    state = AsyncValue.data(current);
    try {
      final filters = ref.read(diyFilterProvider);
      final next = await ref.read(diyRepositoryProvider).getProjects(
        filters: filters,
        page: current.page + 1,
        limit: current.limit,
      );
      state = AsyncValue.data(PaginatedProjects(
        projects: [...current.projects, ...next.projects],
        page: next.page,
        limit: next.limit,
        total: next.total,
        totalPages: next.totalPages,
      ));
    } catch (e) {
      state = AsyncValue.data(current);
      rethrow;
    }
  }
}

final diyProjectsProvider = AsyncNotifierProvider<DiyProjectsNotifier, PaginatedProjects>(
  DiyProjectsNotifier.new,
);

final diyDetailProvider = FutureProvider.family<DiyProject, String>((ref, id) async {
  return ref.read(diyRepositoryProvider).getProject(id);
});

class SavedProjectsNotifier extends AsyncNotifier<List<SavedProject>> {
  @override
  Future<List<SavedProject>> build() async {
    return ref.read(diyRepositoryProvider).getSavedProjects();
  }
}

final savedProjectsProvider = AsyncNotifierProvider<SavedProjectsNotifier, List<SavedProject>>(
  SavedProjectsNotifier.new,
);
