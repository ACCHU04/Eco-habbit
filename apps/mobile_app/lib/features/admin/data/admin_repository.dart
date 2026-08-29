import '../../../core/services/api_client.dart';
import '../models/admin_user.dart';
import '../models/admin_report.dart';
import '../models/admin_audit_entry.dart';
import '../models/admin_dashboard_stats.dart';

class AdminRepository {
  final ApiClient _api;
  AdminRepository(this._api);

  Future<AdminDashboardStats> getDashboard() async {
    final res = await _api.get('/admin/dashboard');
    return AdminDashboardStats.fromJson(res.data['data']);
  }

  Future<Map<String, dynamic>> getUsers({
    String? search,
    String? role,
    String? status,
    int page = 1,
    int limit = 20,
  }) async {
    final params = <String, dynamic>{'page': page, 'limit': limit};
    if (search != null && search.isNotEmpty) params['search'] = search;
    if (role != null && role.isNotEmpty) params['role'] = role;
    if (status != null && status.isNotEmpty) params['status'] = status;

    final res = await _api.get('/admin/users', queryParameters: params);
    final data = (res.data['data'] as List)
        .map((j) => AdminUser.fromJson(j))
        .toList();
    return {'users': data, 'pagination': res.data['pagination']};
  }

  Future<AdminUser> getUserDetail(String userId) async {
    final res = await _api.get('/admin/users/$userId');
    return AdminUser.fromJson(res.data['data']);
  }

  Future<void> changeRole(String userId, String role, {String? reason}) async {
    await _api.put('/admin/users/$userId/role', data: {
      'role': role,
      if (reason != null) 'reason': reason,
    });
  }

  Future<void> changeStatus(String userId, String status, {String? reason}) async {
    await _api.put('/admin/users/$userId/status', data: {
      'status': status,
      if (reason != null) 'reason': reason,
    });
  }

  Future<Map<String, dynamic>> getReports({
    String? status,
    int page = 1,
    int limit = 20,
  }) async {
    final params = <String, dynamic>{'page': page, 'limit': limit};
    if (status != null && status.isNotEmpty) params['status'] = status;

    final res = await _api.get('/admin/reports', queryParameters: params);
    final data = (res.data['data'] as List)
        .map((j) => AdminReport.fromJson(j))
        .toList();
    return {'reports': data, 'pagination': res.data['pagination']};
  }

  Future<void> resolveReport(
    String reportId, {
    required String status,
    String? actionTaken,
    String? reason,
  }) async {
    await _api.put('/admin/reports/$reportId', data: {
      'status': status,
      if (actionTaken != null) 'action_taken': actionTaken,
      if (reason != null) 'reason': reason,
    });
  }

  Future<void> deletePost(String postId, {String? reason}) async {
    await _api.delete('/admin/posts/$postId');
  }

  Future<void> deleteListing(String listingId, {String? reason}) async {
    await _api.delete('/admin/listings/$listingId');
  }

  Future<Map<String, dynamic>> getAuditLog({
    String? adminId,
    String? action,
    String? resourceType,
    int page = 1,
    int limit = 50,
  }) async {
    final params = <String, dynamic>{'page': page, 'limit': limit};
    if (adminId != null && adminId.isNotEmpty) params['admin_id'] = adminId;
    if (action != null && action.isNotEmpty) params['action'] = action;
    if (resourceType != null && resourceType.isNotEmpty) {
      params['resource_type'] = resourceType;
    }

    final res = await _api.get('/admin/audit-log', queryParameters: params);
    final data = (res.data['data'] as List)
        .map((j) => AdminAuditEntry.fromJson(j))
        .toList();
    return {'entries': data, 'pagination': res.data['pagination']};
  }
}
