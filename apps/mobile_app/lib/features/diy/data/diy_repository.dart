import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/core/services/api_client.dart';
import 'package:mobile_app/features/auth/providers/auth_provider.dart';
import 'package:mobile_app/features/diy/models/diy_project_model.dart';
import 'package:mobile_app/features/diy/models/diy_filters.dart';

class PaginatedProjects {
  final List<DiyProject> projects;
  final int page;
  final int limit;
  final int total;
  final int totalPages;

  const PaginatedProjects({
    required this.projects,
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
  });

  bool get hasMore => page < totalPages;
}

class SavedProject {
  final String savedId;
  final DiyProject project;

  const SavedProject({required this.savedId, required this.project});

  factory SavedProject.fromJson(Map<String, dynamic> json) {
    return SavedProject(
      savedId: json['saved_id'] as String? ?? '',
      project: DiyProject.fromJson(json['project'] as Map<String, dynamic>? ?? {}),
    );
  }
}

class DiyRepository {
  final ApiClient _api;
  DiyRepository(this._api);

  Future<PaginatedProjects> getProjects({DiyFilters? filters, int page = 1, int limit = 20}) async {
    final params = <String, dynamic>{'page': page, 'limit': limit};
    if (filters != null) {
      if (filters.search.isNotEmpty) params['search'] = filters.search;
      if (filters.category != null) params['category'] = filters.category;
      if (filters.difficulty != null) params['difficulty'] = filters.difficulty;
    }
    final response = await _api.get('/diy/projects', queryParameters: params);
    final data = response.data['data'] as List<dynamic>;
    final pagination = response.data['pagination'] as Map<String, dynamic>;
    return PaginatedProjects(
      projects: data.map((p) => DiyProject.fromJson(p)).toList(),
      page: pagination['page'] as int? ?? page,
      limit: pagination['limit'] as int? ?? limit,
      total: pagination['total'] as int? ?? 0,
      totalPages: pagination['total_pages'] as int? ?? 1,
    );
  }

  Future<DiyProject> getProject(String id) async {
    final response = await _api.get('/diy/projects/$id');
    return DiyProject.fromJson(response.data['data']);
  }

  Future<void> saveProject(String projectId) async {
    await _api.post('/diy/saved', data: {'project_id': projectId});
  }

  Future<void> unsaveProject(String projectId) async {
    await _api.delete('/diy/saved/$projectId');
  }

  Future<List<SavedProject>> getSavedProjects() async {
    final response = await _api.get('/diy/saved');
    final data = response.data['data'] as List<dynamic>;
    return data.map((s) => SavedProject.fromJson(s)).toList();
  }
}

final diyRepositoryProvider = Provider((ref) {
  return DiyRepository(ref.read(apiClientProvider));
});
