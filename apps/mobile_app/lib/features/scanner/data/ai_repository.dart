import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/core/services/api_client.dart';
import 'package:mobile_app/features/auth/providers/auth_provider.dart';
import 'package:mobile_app/features/scanner/models/classify_result.dart';

class AiRepository {
  final ApiClient _api;
  AiRepository(this._api);

  Future<ClassifyResult> classifyImage(File image) async {
    final response = await _api.postMultipart(
      '/ai/classify',
      fieldName: 'file',
      filePath: image.path,
    );
    return ClassifyResult.fromJson(response.data);
  }

  Future<Map<String, dynamic>> getScanHistory({int page = 1, int limit = 20}) async {
    final response = await _api.get('/ai/scans', queryParameters: {'page': page, 'limit': limit});
    return response.data;
  }
}

final aiRepositoryProvider = Provider((ref) {
  return AiRepository(ref.read(apiClientProvider));
});
