import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/core/services/api_client.dart';
import 'package:mobile_app/features/auth/providers/auth_provider.dart';
import 'package:mobile_app/features/coins/models/coin_balance.dart';
import 'package:mobile_app/features/coins/models/coin_transaction.dart';

class CoinsRepository {
  final ApiClient _api;
  CoinsRepository(this._api);

  Future<CoinBalance> getBalance() async {
    final response = await _api.get('/coins/balance');
    return CoinBalance.fromJson(response.data['data']);
  }

  Future<List<CoinTransaction>> getHistory({int page = 1, int limit = 20}) async {
    final response = await _api.get('/coins/history', queryParameters: {
      'page': page,
      'limit': limit,
    });
    final list = response.data['data'] as List<dynamic>;
    return list.map((t) => CoinTransaction.fromJson(t as Map<String, dynamic>)).toList();
  }
}

final coinsRepositoryProvider = Provider((ref) {
  return CoinsRepository(ref.read(apiClientProvider));
});
