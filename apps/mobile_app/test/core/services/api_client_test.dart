import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mobile_app/core/config/app_config.dart';
import 'package:mobile_app/core/services/api_client.dart';
import 'package:mobile_app/core/services/storage_service.dart';

import 'api_client_test.mocks.dart';

@GenerateMocks([StorageService])
void main() {
  late MockStorageService mockStorage;
  late ApiClient client;

  setUp(() {
    mockStorage = MockStorageService();
    client = ApiClient(mockStorage);
  });

  group('Constructor configuration', () {
    test('sets correct baseUrl', () {
      expect(client.dio.options.baseUrl, AppConfig.apiBaseUrl);
    });

    test('sets connect timeout to 90 seconds', () {
      expect(client.dio.options.connectTimeout, const Duration(seconds: 90));
    });

    test('sets receive timeout to 90 seconds', () {
      expect(client.dio.options.receiveTimeout, const Duration(seconds: 90));
    });

    test('sets Content-Type header', () {
      expect(client.dio.options.headers['Content-Type'], 'application/json');
    });
  });

  group('Authorization header injection', () {
    test('attaches Bearer token when token is present', () async {
      when(mockStorage.getToken()).thenReturn('tok123');

      final adapter = _FakeAdapter(jsonEncode({'ok': true}), 200);
      client.dio.httpClientAdapter = adapter;

      await client.get('/test');

      expect(adapter.lastRequest?.headers['Authorization'], 'Bearer tok123');
    });

    test('omits Authorization header when token is null', () async {
      when(mockStorage.getToken()).thenReturn(null);

      final adapter = _FakeAdapter(jsonEncode({'ok': true}), 200);
      client.dio.httpClientAdapter = adapter;

      await client.get('/test');

      expect(adapter.lastRequest?.headers.containsKey('Authorization'), false);
    });
  });

  group('HTTP delegation', () {
    setUp(() {
      when(mockStorage.getToken()).thenReturn(null);
      client.dio.httpClientAdapter = _FakeAdapter(jsonEncode({'ok': true}), 200);
    });

    test('get delegates to Dio.get', () async {
      final response = await client.get('/items', queryParameters: {'q': '1'});
      expect(response.statusCode, 200);
    });

    test('post delegates to Dio.post', () async {
      final response = await client.post('/items', data: {'name': 'test'});
      expect(response.statusCode, 200);
    });

    test('delete delegates to Dio.delete', () async {
      final response = await client.delete('/items/1');
      expect(response.statusCode, 200);
    });
  });
}

class _FakeAdapter implements HttpClientAdapter {
  final String responseBody;
  final int statusCode;
  RequestOptions? lastRequest;

  _FakeAdapter(this.responseBody, this.statusCode);

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) {
    lastRequest = options;
    return Future.value(
      ResponseBody.fromString(responseBody, statusCode),
    );
  }

  @override
  void close({bool force = false}) {}
}
