import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/core/services/api_client.dart';
import 'package:mobile_app/features/auth/providers/auth_provider.dart';
import 'package:mobile_app/features/home/models/dashboard_data.dart';

class HomeRepository {
  final ApiClient _api;
  HomeRepository(this._api);

  Future<DashboardData> getDashboard() async {
    final response = await _api.get('/home/dashboard');
    return DashboardData.fromJson(response.data['data']);
  }
}

final homeRepositoryProvider = Provider((ref) {
  return HomeRepository(ref.read(apiClientProvider));
});
