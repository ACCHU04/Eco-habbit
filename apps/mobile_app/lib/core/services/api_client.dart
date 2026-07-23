import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobile_app/core/config/app_config.dart';
import 'package:mobile_app/core/services/storage_service.dart';

class ApiClient {
  late final Dio dio;
  final StorageService _storage;
  bool _refreshing = false;

  ApiClient(this._storage) {
    dio = Dio(BaseOptions(
      baseUrl: AppConfig.apiBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Content-Type': 'application/json'},
    ));

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = _storage.getToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
      onError: (error, handler) async {
        if (error.response?.statusCode == 401 && !_refreshing) {
          _refreshing = true;
          try {
            final user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              final newToken = await user.getIdToken(true);
              await _storage.saveFirebaseIdToken(newToken!);
              error.requestOptions.headers['Authorization'] = 'Bearer $newToken';
              final retryResponse = await dio.fetch(error.requestOptions);
              _refreshing = false;
              return handler.resolve(retryResponse);
            }
          } catch (_) {
            _refreshing = false;
          }
          _storage.clearAuth();
        }
        handler.next(error);
      },
    ));
  }

  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) {
    return dio.get(path, queryParameters: queryParameters);
  }

  Future<Response> post(String path, {dynamic data}) {
    return dio.post(path, data: data);
  }

  Future<Response> put(String path, {dynamic data}) {
    return dio.put(path, data: data);
  }

  Future<Response> delete(String path) {
    return dio.delete(path);
  }

  Future<Response> postMultipart(
    String path, {
    required String fieldName,
    required String filePath,
    Map<String, dynamic>? fields,
  }) async {
    final formData = FormData.fromMap({
      if (fields != null) ...fields,
      fieldName: await MultipartFile.fromFile(filePath),
    });
    return dio.post(path, data: formData);
  }
}
