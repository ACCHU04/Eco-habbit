import '../../../core/services/api_client.dart';
import '../models/campus.dart';

class CampusRepository {
  final ApiClient _api;
  CampusRepository(this._api);

  Future<List<Campus>> getActiveCampuses() async {
    final res = await _api.get('/campuses');
    final data = res.data['data'] as List;
    return data.map((j) => Campus.fromJson(j)).toList();
  }

  Future<Campus> getCampusBySlug(String slug) async {
    final res = await _api.get('/campuses/$slug');
    return Campus.fromJson(res.data['data']);
  }

  Future<void> setUserCampus(String slug) async {
    await _api.put('/users/me/campus', data: {'slug': slug});
  }
}
