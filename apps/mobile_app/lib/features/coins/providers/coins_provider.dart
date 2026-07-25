import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/features/coins/data/coins_repository.dart';
import 'package:mobile_app/features/coins/models/coin_balance.dart';
import 'package:mobile_app/features/coins/models/coin_transaction.dart';

class CoinBalanceNotifier extends AsyncNotifier<CoinBalance> {
  @override
  Future<CoinBalance> build() async {
    return ref.read(coinsRepositoryProvider).getBalance();
  }

  Future<void> reload() async {
    ref.invalidateSelf();
    await future;
  }
}

final coinBalanceProvider =
    AsyncNotifierProvider<CoinBalanceNotifier, CoinBalance>(CoinBalanceNotifier.new);

class CoinHistoryNotifier extends AsyncNotifier<List<CoinTransaction>> {
  @override
  Future<List<CoinTransaction>> build() async {
    return ref.read(coinsRepositoryProvider).getHistory();
  }

  Future<void> loadMore(int page) async {
    final more = await ref.read(coinsRepositoryProvider).getHistory(page: page);
    final current = state.valueOrNull ?? [];
    state = AsyncData([...current, ...more]);
  }

  Future<void> reload() async {
    ref.invalidateSelf();
    await future;
  }
}

final coinHistoryProvider =
    AsyncNotifierProvider<CoinHistoryNotifier, List<CoinTransaction>>(CoinHistoryNotifier.new);
